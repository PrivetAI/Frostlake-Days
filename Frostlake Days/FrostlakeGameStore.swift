import Foundation
import SwiftUI

final class FrostlakeGameStore: ObservableObject {
    @Published var state: FrostlakeGameState {
        didSet { save() }
    }
    @Published var lastEvent: String? = nil
    @Published var seasonClosed: Bool = false
    @Published var seasonGrade: Int = 0

    private let storeKey = "hca.gameState"

    init() {
        if let data = UserDefaults.standard.data(forKey: storeKey),
           let decoded = try? JSONDecoder().decode(FrostlakeGameState.self, from: data) {
            var s = decoded
            // Backfill unlockedSpots so existing saves see newly-added spots whose unlockDay has already passed.
            for spot in FrostlakeLakeSpotData.all where spot.unlockDay <= s.day {
                s.unlockedSpots.insert(spot.id)
            }
            self.state = s
        } else {
            self.state = FrostlakeGameState.freshState()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: storeKey)
        }
    }

    // MARK: - Time advancement
    func advanceTimeBlock(cost: Double = 1.0) {
        var s = state
        s.fatigue = min(10, s.fatigue + 0.25 * cost)
        if s.timeBlock < 5 {
            s.timeBlock += 1
        } else {
            // wrap to next day (this should only happen if forced)
            advanceDay(s: &s)
        }
        state = s
    }

    func sleep() {
        var s = state
        // Base nightly fatigue regen (lower — sleep no longer fully erases hard days).
        var regen = 3.0
        // Recipe buff "fatigue": reduces nightly fatigue regen burden.
        // Applies for the day cooked; tick logic below decays the buff at sleep.
        if s.buffsActiveKey == "fatigue" && s.buffsDaysRemaining > 0 {
            regen += 1.0
        }
        // Stove tier boosts nightly regen by 0.25 per tier (max +1.0 at tier 4).
        let stoveTier = s.homeTiers.indices.contains(1) ? s.homeTiers[1] : 0
        regen += Double(stoveTier) * 0.25
        s.fatigue = max(0, s.fatigue - regen)
        // tick buff if any
        if s.buffsDaysRemaining > 0 {
            s.buffsDaysRemaining -= 1
            if s.buffsDaysRemaining <= 0 {
                s.buffsActiveKey = nil
            }
        }
        // Reset per-day gift counter for "gift" buff cycle.
        s.giftsGivenToday = 0
        advanceDay(s: &s)
        state = s
    }

    private func advanceDay(s: inout FrostlakeGameState) {
        if s.day >= 30 {
            // Season closeout
            let grade = computeGradeFromState(s)
            seasonGrade = grade
            s.seasonsCompleted += 1
            if grade > s.bestSeasonGrade { s.bestSeasonGrade = grade }
            // Loop back keeping progression
            s.day = 1
            s.timeBlock = 0
            s.phase = 0
            // generate new weather forecast
            var rng = SystemRandomNumberGenerator()
            var forecast: [Int] = []
            for d in 1...30 {
                let phaseIdx: Int = (d - 1) / 10
                let weights: [Int] = {
                    switch phaseIdx {
                    case 0: return [4, 3, 1, 2, 1]
                    case 1: return [2, 3, 3, 2, 2]
                    default: return [3, 2, 1, 2, 3]
                    }
                }()
                forecast.append(FrostlakeGameState.weightedPick(weights, using: &rng))
            }
            s.weatherForecast = forecast
            s.weatherToday = forecast.first ?? 0
            s.fatigue = 0
            s.festivalsAttended = []
            s.giftsGivenToday = 0
            s.diaryEntries.append(FrostlakeDiaryEntry(
                id: UUID(), day: 30, timeBlock: 5,
                title: "Season Complete",
                body: "Frostlake closes the season. Grade: \(gradeLabel(grade)).",
                kind: "milestone"))
            seasonClosed = true
        } else {
            s.day += 1
            s.timeBlock = 0
            s.phase = (s.day - 1) / 10
            s.weatherToday = s.weatherForecast.indices.contains(s.day - 1) ? s.weatherForecast[s.day - 1] : 0
            // unlock spots by day
            for spot in FrostlakeLakeSpotData.all where spot.unlockDay <= s.day {
                s.unlockedSpots.insert(spot.id)
            }
            // refresh shop
            s.dailyShopSeed = s.day &* 31 + s.weatherToday
            s.dailyShopItems = FrostlakeGameState.computeShopRotation(seed: s.dailyShopSeed)
            // Reset per-day gift counter on every day transition (idempotent with sleep()).
            s.giftsGivenToday = 0
        }
    }

    // MARK: - Grade
    private func computeGradeFromState(_ s: FrostlakeGameState) -> Int {
        // 0..3 (C/B/A/S)
        let speciesScore = min(FrostlakeFishData.all.count, s.almanacSpecies.count) * 4   // up to 28*4 = 112
        let findsScore = min(FrostlakeForagedData.all.count, s.almanacFinds.count) * 2    // up to 16*2 = 32
        let festivalScore = min(FrostlakeFestivalData.all.count, s.festivalsAttended.count) * 5 // up to 9*5 = 45
        let relScore = s.npcRelationship.reduce(0, +) // up to 8*40 = 320
        let total = speciesScore + findsScore + festivalScore + relScore / 4
        // Recipe buff "grade" (Almanac Cake, baked on Day 30): bumps season grade by one band.
        let gradeBump = (s.buffsActiveKey == "grade" && s.buffsDaysRemaining > 0) ? 1 : 0
        // Tightened thresholds: harder to reach S, scales with the expanded content set.
        let raw: Int
        if total >= 175 { raw = 3 }       // S
        else if total >= 130 { raw = 2 }  // A
        else if total >= 85 { raw = 1 }   // B
        else { raw = 0 }                   // C
        return min(3, raw + gradeBump)
    }

    func gradeLabel(_ grade: Int) -> String {
        switch grade { case 3: return "S"; case 2: return "A"; case 1: return "B"; default: return "C" }
    }

    // MARK: - NPC actions
    func talkToNPC(_ npcId: Int) {
        // Bounds-check npcId against both the relationship array and data table.
        guard npcId >= 0, npcId < state.npcRelationship.count, npcId < FrostlakeNPCData.all.count else { return }
        var s = state
        s.npcRelationship[npcId] = min(40, s.npcRelationship[npcId] + 1)
        let tier = s.npcRelationship[npcId] / 10
        let stored = s.almanacNPCTiers[npcId] ?? -1
        if tier > stored {
            s.almanacNPCTiers[npcId] = tier
            let npc = FrostlakeNPCData.all[npcId]
            if tier >= 1 && tier - 1 < npc.loreCards.count {
                s.diaryEntries.append(FrostlakeDiaryEntry(
                    id: UUID(), day: s.day, timeBlock: s.timeBlock,
                    title: "\(npc.name): Tier Reached",
                    body: npc.loreCards[tier - 1],
                    kind: "tier"))
            }
        }
        s.fatigue = min(10, s.fatigue + 0.2)
        if s.timeBlock < 5 { s.timeBlock += 1 }
        state = s
    }

    func giftToNPC(_ npcId: Int) -> Bool {
        // Bounds-check npcId against both the relationship array and data table.
        guard npcId >= 0, npcId < state.npcRelationship.count, npcId < FrostlakeNPCData.all.count else { return false }
        // require any cooked item: simplest, require one ingredient (sugar/honey/etc) OR any common fish
        var s = state
        // Recipe buff "gift": allows +1 extra gift action per day. Base allowance = 1.
        let baseGiftCap = 1
        let bonus = (s.buffsActiveKey == "gift" && s.buffsDaysRemaining > 0) ? 1 : 0
        let cap = baseGiftCap + bonus
        guard s.giftsGivenToday < cap else { return false }
        if let firstFish = s.inventoryFish.first(where: { $0.value > 0 })?.key {
            s.inventoryFish[firstFish, default: 0] -= 1
            s.npcRelationship[npcId] = min(40, s.npcRelationship[npcId] + 3)
        } else if let firstFind = s.inventoryFinds.first(where: { $0.value > 0 })?.key {
            s.inventoryFinds[firstFind, default: 0] -= 1
            s.npcRelationship[npcId] = min(40, s.npcRelationship[npcId] + 2)
        } else {
            return false
        }
        s.giftsGivenToday += 1
        if s.buffsActiveKey == "rel" {
            s.npcRelationship[npcId] = min(40, s.npcRelationship[npcId] + 1)
        }
        let tier = s.npcRelationship[npcId] / 10
        let stored = s.almanacNPCTiers[npcId] ?? -1
        if tier > stored {
            s.almanacNPCTiers[npcId] = tier
            let npc = FrostlakeNPCData.all[npcId]
            if tier >= 1 && tier - 1 < npc.loreCards.count {
                s.diaryEntries.append(FrostlakeDiaryEntry(
                    id: UUID(), day: s.day, timeBlock: s.timeBlock,
                    title: "\(npc.name): Tier Reached",
                    body: npc.loreCards[tier - 1],
                    kind: "tier"))
            }
        }
        state = s
        return true
    }

    // MARK: - Fishing
    /// returns rolled fish id (or nil if none catchable in this context)
    func candidatesAt(spotId: Int) -> [FrostlakeFish] {
        let s = state
        return FrostlakeFishData.all.filter { fish in
            guard fish.availablePhases.contains(s.phase) else { return false }
            guard fish.availableSpots.contains(spotId) else { return false }
            guard fish.availableBlocks.contains(s.timeBlock) else { return false }
            if let weather = fish.allowedWeather, !weather.contains(s.weatherToday) { return false }
            return true
        }
    }

    /// Roll a single fish from candidates weighted by inverse rarity
    func rollCandidate(spotId: Int) -> FrostlakeFish? {
        let cands = candidatesAt(spotId: spotId)
        if cands.isEmpty { return nil }
        // Recipe buff "rare": boosts the weight of rare/legendary fish (~+10%).
        // Active for the day cooked.
        let rareBuff = (state.buffsActiveKey == "rare" && state.buffsDaysRemaining > 0)
        let weights = cands.map { f -> Int in
            let base: Int
            switch f.rarity {
            case 0: base = 8
            case 1: base = 4
            case 2: base = 2
            default: base = 1
            }
            if rareBuff && f.rarity >= 2 {
                // bump rare/legendary by +1 (proportional ~+50% on rare, +100% on legendary in absolute terms,
                // but still small overall since commons remain at 8). Keeps spec's "rare bite +10%" intent
                // by tilting the weighted draw toward higher-rarity fish.
                return base + 1
            }
            return base
        }
        let total = weights.reduce(0, +)
        if total <= 0 { return cands.first }
        var pick = Int.random(in: 0..<total)
        for (i, w) in weights.enumerated() {
            if pick < w { return cands[i] }
            pick -= w
        }
        return cands.last
    }

    /// resolve a successful catch — adds to inventory, updates almanac, returns species id
    func recordCatch(_ fish: FrostlakeFish) {
        var s = state
        s.inventoryFish[fish.id, default: 0] += 1
        let isFirst = !s.almanacSpecies.contains(fish.id)
        s.almanacSpecies.insert(fish.id)
        if isFirst {
            s.firstCaughtDate[fish.id] = s.day
            s.diaryEntries.append(FrostlakeDiaryEntry(
                id: UUID(), day: s.day, timeBlock: s.timeBlock,
                title: "First Catch: \(fish.name)",
                body: fish.lore,
                kind: "milestone"))
        }
        // occasional forage on cast (rarer than before — patience pays)
        if Int.random(in: 0..<9) == 0 {
            if let find = FrostlakeForagedData.all.randomElement() {
                s.inventoryFinds[find.id, default: 0] += 1
                if !s.almanacFinds.contains(find.id) {
                    s.almanacFinds.insert(find.id)
                }
            }
        }
        // Fatigue cost scales mildly with rarity — chasing legendaries tires you out.
        let rarityFatigue: Double = 0.55 + (Double(fish.rarity) * 0.08)
        s.fatigue = min(10, s.fatigue + rarityFatigue)
        state = s
    }

    func failedCatch() {
        var s = state
        // Failed casts still tire you: lake doesn't refund effort.
        s.fatigue = min(10, s.fatigue + 0.65)
        state = s
    }

    // MARK: - Cooking
    func canCook(_ recipe: FrostlakeRecipe) -> Bool {
        let s = state
        // Almanac Cake (id 17) is a Day-30-only celebration bake.
        if recipe.id == 17 && s.day != 30 { return false }
        for (key, qty) in recipe.ingredients {
            if key.hasPrefix("fish:") {
                let id = Int(key.dropFirst(5)) ?? -1
                if (s.inventoryFish[id] ?? 0) < qty { return false }
            } else if key.hasPrefix("find:") {
                let id = Int(key.dropFirst(5)) ?? -1
                if (s.inventoryFinds[id] ?? 0) < qty { return false }
            } else if key.hasPrefix("shop:") {
                if (s.inventoryIngredients[key] ?? 0) < qty { return false }
            }
        }
        return true
    }

    /// Cooks a recipe, consuming its ingredients and arming its buff.
    /// Active buff is consulted by:
    ///   - "bite"    -> biteWindowFraction (additive, clamped)
    ///   - "rare"    -> rollCandidate (rare/legendary weight bump)
    ///   - "coin"    -> attendCurrentFestival (coin reward multiplier)
    ///   - "sell"    -> attendCurrentFestival (exchange-price multiplier; sole coin-yield site)
    ///   - "fatigue" -> sleep() (extra nightly fatigue regen)
    ///   - "gift"    -> giftToNPC (raises per-day gift cap by +1)
    ///   - "rel"     -> giftToNPC (extra relationship +1 on gift)
    ///   - "grade"   -> computeGradeFromState (Almanac Cake season-grade +1)
    /// Buffs persist for recipe.buffDays (extended by Kitchen tier) and decay at sleep().
    func cook(_ recipe: FrostlakeRecipe) -> Bool {
        guard canCook(recipe) else { return false }
        var s = state
        for (key, qty) in recipe.ingredients {
            if key.hasPrefix("fish:") {
                let id = Int(key.dropFirst(5)) ?? -1
                s.inventoryFish[id, default: 0] -= qty
            } else if key.hasPrefix("find:") {
                let id = Int(key.dropFirst(5)) ?? -1
                s.inventoryFinds[id, default: 0] -= qty
            } else if key.hasPrefix("shop:") {
                s.inventoryIngredients[key, default: 0] -= qty
            }
        }
        s.buffsActiveKey = recipe.buffKey
        // Kitchen tier 0..4 boosts duration up to +2 days
        let kitchenTier = s.homeTiers.first ?? 0
        let extra = kitchenTier / 2
        s.buffsDaysRemaining = recipe.buffDays + extra
        s.diaryEntries.append(FrostlakeDiaryEntry(
            id: UUID(), day: s.day, timeBlock: s.timeBlock,
            title: "Cooked: \(recipe.name)",
            body: recipe.buffLabel,
            kind: "milestone"))
        state = s
        return true
    }

    // MARK: - Shop
    func buy(itemId: String) -> Bool {
        guard let item = FrostlakeShopData.all.first(where: { $0.id == itemId }) else { return false }
        var s = state
        let price = currentPrice(item)
        guard s.coins >= price else { return false }
        s.coins -= price
        if item.kind == "ingredient" {
            s.inventoryIngredients[item.id, default: 0] += 1
        } else if item.kind == "scroll" {
            // unlock a random not-yet-unlocked recipe
            let lockedIds = FrostlakeRecipeData.all.map { $0.id }.filter { !s.unlockedRecipes.contains($0) && $0 != 17 }
            if let pick = lockedIds.randomElement() {
                s.unlockedRecipes.insert(pick)
                // Defensive id-based lookup: recipe id may not equal array index.
                let unlockedName = FrostlakeRecipeData.all.first(where: { $0.id == pick })?.name ?? ""
                s.diaryEntries.append(FrostlakeDiaryEntry(
                    id: UUID(), day: s.day, timeBlock: s.timeBlock,
                    title: "Recipe Unlocked",
                    body: unlockedName,
                    kind: "milestone"))
            }
        } else {
            s.inventoryGear[item.id, default: 0] += 1
        }
        state = s
        return true
    }

    func currentPrice(_ item: FrostlakeShopItem) -> Int {
        // phase-based fluctuation
        let multiplier: Double = {
            switch state.phase {
            case 0: return 1.0
            case 1: return 1.10
            default: return 0.95
            }
        }()
        return max(1, Int(Double(item.basePrice) * multiplier))
    }

    // MARK: - Upgrades
    func upgradeRoom(_ roomId: Int) -> Bool {
        var s = state
        let tier = s.homeTiers[roomId]
        if tier >= 4 { return false }
        let cost = FrostlakeRoomData.upgradeCost(roomId: roomId, tier: tier)
        if s.coins < cost { return false }
        s.coins -= cost
        s.homeTiers[roomId] = tier + 1
        s.diaryEntries.append(FrostlakeDiaryEntry(
            id: UUID(), day: s.day, timeBlock: s.timeBlock,
            title: "Upgraded \(FrostlakeRoomData.all[roomId].name)",
            body: "Now at tier \(tier + 1).",
            kind: "milestone"))
        state = s
        return true
    }

    // MARK: - Festivals
    func attendCurrentFestival() -> FrostlakeFestival? {
        let s = state
        guard let fest = FrostlakeFestivalData.all.first(where: {
            $0.day == s.day && $0.timeBlock == s.timeBlock
        }) else { return nil }
        var s2 = state
        if !s2.festivalsAttended.contains(fest.id) {
            s2.festivalsAttended.insert(fest.id)
            s2.almanacFestivals.insert(fest.id)
            // Base reward (trimmed — festivals are now richer in numbers, not in coin).
            var reward = 18.0
            // Recipe buff "coin": +15-20% to coin reward today.
            if s2.buffsActiveKey == "coin" && s2.buffsDaysRemaining > 0 {
                reward *= 1.20
            }
            // Recipe buff "sell": +10% sell/exchange prices today (festival rep exchange counts).
            if s2.buffsActiveKey == "sell" && s2.buffsDaysRemaining > 0 {
                reward *= 1.10
            }
            s2.coins += Int(reward.rounded())
            // small rep with all
            for i in 0..<8 {
                s2.npcRelationship[i] = min(40, s2.npcRelationship[i] + 1)
            }
            s2.diaryEntries.append(FrostlakeDiaryEntry(
                id: UUID(), day: s2.day, timeBlock: s2.timeBlock,
                title: "Festival: \(fest.name)",
                body: fest.description,
                kind: "festival"))
        }
        state = s2
        return fest
    }

    /// Is there an attendable, not-yet-attended festival at the current day/timeBlock?
    func currentFestivalIfAny() -> FrostlakeFestival? {
        let s = state
        guard let fest = FrostlakeFestivalData.all.first(where: {
            $0.day == s.day && $0.timeBlock == s.timeBlock
        }) else { return nil }
        if s.festivalsAttended.contains(fest.id) { return nil }
        return fest
    }

    // MARK: - Diary
    func reflect(_ text: String) {
        var s = state
        let body = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !body.isEmpty else { return }
        s.diaryEntries.append(FrostlakeDiaryEntry(
            id: UUID(), day: s.day, timeBlock: s.timeBlock,
            title: "Reflection",
            body: body, kind: "manual"))
        s.fatigue = max(0, s.fatigue - 0.5)
        // Small bite buff — but only if no other buff is currently active.
        // This protects active coin/sell/rare/grade/fatigue/gift/rel buffs from being
        // clobbered by writing a reflection.
        if s.buffsActiveKey == nil || s.buffsActiveKey == "bite" {
            s.buffsActiveKey = "bite"
            s.buffsDaysRemaining = max(s.buffsDaysRemaining, 1)
        }
        state = s
    }

    // MARK: - Reset
    func resetProgress() {
        // Wipe any persisted hca.* keys before reassigning, so a stale snapshot can't
        // race the next save and resurrect old state across crashes / future migrations.
        let defaults = UserDefaults.standard
        let staleKeys = defaults.dictionaryRepresentation().keys.filter { $0.hasPrefix("hca.") }
        for key in staleKeys { defaults.removeObject(forKey: key) }
        state = FrostlakeGameState.freshState()
    }

    // MARK: - Onboarding
    func markOnboardingSeen() {
        var s = state
        s.onboardingSeen = true
        state = s
    }

    // MARK: - Settings
    func toggleSound() {
        var s = state
        s.soundOn.toggle()
        state = s
    }

    func toggleHaptics() {
        var s = state
        s.hapticsOn.toggle()
        state = s
    }

    // MARK: - Bite mini-game helpers
    func biteWindowFraction(for fish: FrostlakeFish) -> Double {
        // base by rarity
        let base: Double = {
            switch fish.rarity {
            case 0: return 0.25
            case 1: return 0.20
            case 2: return 0.18
            default: return 0.15
            }
        }()
        var w = base
        if state.buffsActiveKey == "bite" && state.buffsDaysRemaining > 0 {
            w += 0.05
        }
        // Spec caps bite window at 25% for commons; allow rarer fish a small headroom up to 30%.
        // Apply additive clamp then a hard cap (0.30) so the +5% buff cannot push past spec.
        let perTierCap: Double = (fish.rarity == 0) ? 0.25 : 0.30
        return min(perTierCap, w)
    }

    func biteDuration(for fish: FrostlakeFish) -> Double {
        // 1.5-4.0 seconds
        switch fish.rarity {
        case 0: return Double.random(in: 1.5...2.4)
        case 1: return Double.random(in: 2.0...3.2)
        case 2: return Double.random(in: 2.6...3.8)
        default: return Double.random(in: 3.0...4.0)
        }
    }
}
