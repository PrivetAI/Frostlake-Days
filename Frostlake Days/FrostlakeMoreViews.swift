import SwiftUI

// MARK: - More hub
struct FrostlakeMoreHubView: View {
    @EnvironmentObject var game: FrostlakeGameStore

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                FrostlakeDayHeader()
                Text("More")
                    .font(FrostlakeTypography.serifTitle(22))
                    .foregroundColor(FrostlakePalette.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)

                NavigationLink(destination: FrostlakeTalkListView()) {
                    moreRow("Talk", "Visit villagers", AnyView(StrokeIcon(PersonShape(), size: 22,
                                                                          color: FrostlakePalette.teal, lineWidth: 1.8)))
                }
                NavigationLink(destination: FrostlakeCookbookView()) {
                    moreRow("Cookbook", "Bake, simmer, smoke", AnyView(StrokeIcon(PotShape(), size: 22,
                                                                                   color: FrostlakePalette.ember, lineWidth: 1.8)))
                }
                NavigationLink(destination: FrostlakeShopView()) {
                    moreRow("Shop", "Market stalls open Morning–Afternoon", AnyView(StrokeIcon(CoinShape(), size: 22,
                                                                                                color: FrostlakePalette.ember, lineWidth: 1.8)))
                }
                NavigationLink(destination: FrostlakeDiaryView()) {
                    moreRow("Diary", "Reflections and milestones", AnyView(StrokeIcon(QuillShape(), size: 22,
                                                                                       color: FrostlakePalette.foxBrown, lineWidth: 1.8)))
                }
                // Belt-and-suspenders with the undismissable onboarding sheet:
                // Settings is also disabled until the user finishes onboarding.
                NavigationLink(destination: FrostlakeSettingsView()) {
                    moreRow("Settings", "Sound, haptics, reset", AnyView(StrokeIcon(HexagonShape(), size: 22,
                                                                                     color: FrostlakePalette.teal, lineWidth: 1.8)))
                }
                .disabled(!game.state.onboardingSeen)
                Spacer().frame(height: 24)
            }
            .padding(.top, 4)
        }
        .background(FrostlakePalette.parchment.edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle("More", displayMode: .inline)
    }

    private func moreRow(_ title: String, _ subtitle: String, _ icon: AnyView) -> some View {
        HStack(spacing: 14) {
            icon
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(FrostlakeTypography.serifTitle(16))
                    .foregroundColor(FrostlakePalette.ink)
                Text(subtitle)
                    .font(FrostlakeTypography.serifBody(12))
                    .foregroundColor(FrostlakePalette.foxBrown)
            }
            Spacer()
            StrokeIcon(ChevronRightShape(), size: 18, color: FrostlakePalette.foxBrown, lineWidth: 1.6)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(FrostlakePalette.skyPale)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(FrostlakePalette.teal.opacity(0.2), lineWidth: 1))
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - NPC list
struct FrostlakeTalkListView: View {
    @EnvironmentObject var game: FrostlakeGameStore

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                FrostlakeDayHeader()
                ForEach(FrostlakeNPCData.all) { npc in
                    NavigationLink(destination: FrostlakeNPCDetailView(npc: npc)) {
                        let presentToday = !(npc.id == 7 && ![5, 15, 25].contains(game.state.day))
                        HStack(spacing: 12) {
                            StrokeIcon(PersonShape(), size: 30,
                                       color: FrostlakePalette.teal, lineWidth: 1.8)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(npc.name)
                                    .font(FrostlakeTypography.serifTitle(15))
                                    .foregroundColor(FrostlakePalette.ink)
                                Text(npc.role)
                                    .font(FrostlakeTypography.serifBody(12))
                                    .foregroundColor(FrostlakePalette.foxBrown)
                                let tier = game.state.npcRelationship[npc.id] / 10
                                HStack(spacing: 3) {
                                    ForEach(0..<4) { i in
                                        Circle()
                                            .fill(i < tier ? FrostlakePalette.ember : FrostlakePalette.foxBrown.opacity(0.2))
                                            .frame(width: 8, height: 8)
                                    }
                                    Text(tierLabel(tier))
                                        .font(FrostlakeTypography.monoDate(10))
                                        .foregroundColor(FrostlakePalette.foxBrown)
                                }
                                if !presentToday {
                                    Text("Visits on Day 5, 15, 25 only")
                                        .font(FrostlakeTypography.monoDate(10))
                                        .foregroundColor(FrostlakePalette.foxBrown.opacity(0.7))
                                } else {
                                    Text("Now at: \(npc.schedule[game.state.timeBlock])")
                                        .font(FrostlakeTypography.monoDate(10))
                                        .foregroundColor(FrostlakePalette.teal)
                                }
                            }
                            Spacer()
                            StrokeIcon(ChevronRightShape(), size: 16,
                                       color: FrostlakePalette.foxBrown, lineWidth: 1.6)
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(presentToday ? FrostlakePalette.skyPale : FrostlakePalette.parchment)
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(FrostlakePalette.teal.opacity(presentToday ? 0.25 : 0.1), lineWidth: 1))
                        )
                        .padding(.horizontal, 16)
                    }
                    .disabled(npc.id == 7 && ![5, 15, 25].contains(game.state.day))
                    .buttonStyle(.plain)
                }
                Spacer().frame(height: 24)
            }
            .padding(.top, 4)
        }
        .background(FrostlakePalette.parchment.edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle("Talk", displayMode: .inline)
    }

    private func tierLabel(_ tier: Int) -> String {
        switch tier {
        case 0: return "Cold"
        case 1: return "Polite"
        case 2: return "Friendly"
        default: return "Bonded"
        }
    }
}

// MARK: - NPC detail
struct FrostlakeNPCDetailView: View {
    @EnvironmentObject var game: FrostlakeGameStore
    let npc: FrostlakeNPC
    @State private var lineIndex: Int = 0

    var body: some View {
        let tier = min(3, game.state.npcRelationship[npc.id] / 10)
        let lines = npc.dialogueTiers[tier]
        return ScrollView {
            VStack(spacing: 14) {
                FrostlakeDayHeader()
                VStack(spacing: 8) {
                    StrokeIcon(PersonShape(), size: 84,
                               color: FrostlakePalette.teal, lineWidth: 2)
                    Text(npc.name)
                        .font(FrostlakeTypography.serifTitle(22))
                        .foregroundColor(FrostlakePalette.ink)
                    Text(npc.role)
                        .font(FrostlakeTypography.serifBody(13))
                        .foregroundColor(FrostlakePalette.foxBrown)
                    Text(npc.bio)
                        .font(FrostlakeTypography.serifBody(13))
                        .foregroundColor(FrostlakePalette.foxBrown.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 22)
                    Text("Now at: \(npc.schedule[game.state.timeBlock])")
                        .font(FrostlakeTypography.monoDate(11))
                        .foregroundColor(FrostlakePalette.teal)
                }
                .padding(.top, 4)

                // dialogue line
                VStack(alignment: .leading, spacing: 8) {
                    Text(lines[min(lineIndex, lines.count - 1)])
                        .font(FrostlakeTypography.serifBody(15))
                        .foregroundColor(FrostlakePalette.ink)
                    HStack {
                        Text("Tier \(tier + 1) of 4")
                            .font(FrostlakeTypography.monoDate(10))
                            .foregroundColor(FrostlakePalette.foxBrown)
                        Spacer()
                        Button(action: {
                            lineIndex = (lineIndex + 1) % lines.count
                        }) {
                            Text("Next line")
                                .font(FrostlakeTypography.serifBody(13))
                                .foregroundColor(FrostlakePalette.teal)
                        }
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(FrostlakePalette.parchment)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(FrostlakePalette.foxBrown.opacity(0.25), lineWidth: 1))
                )
                .padding(.horizontal, 16)

                // Relationship bar
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        StrokeIcon(HeartShape(), size: 16,
                                   color: FrostlakePalette.ember, lineWidth: 1.6)
                        Text("Relationship")
                            .font(FrostlakeTypography.serifTitle(14))
                            .foregroundColor(FrostlakePalette.ink)
                        Spacer()
                        Text("\(game.state.npcRelationship[npc.id]) / 40")
                            .font(FrostlakeTypography.monoDate(11))
                            .foregroundColor(FrostlakePalette.foxBrown)
                    }
                    FrostlakeProgressBar(value: Double(game.state.npcRelationship[npc.id]), max: 40)
                }
                .padding(.horizontal, 16)

                // Actions
                HStack(spacing: 12) {
                    Button(action: { game.talkToNPC(npc.id); lineIndex = 0 }) {
                        Text("Talk (+1)")
                            .font(FrostlakeTypography.serifTitle(14))
                            .foregroundColor(FrostlakePalette.parchment)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(RoundedRectangle(cornerRadius: 10).fill(FrostlakePalette.teal))
                    }
                    Button(action: {
                        _ = game.giftToNPC(npc.id)
                    }) {
                        Text("Gift item")
                            .font(FrostlakeTypography.serifTitle(14))
                            .foregroundColor(FrostlakePalette.parchment)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(RoundedRectangle(cornerRadius: 10).fill(FrostlakePalette.ember))
                    }
                }
                .padding(.horizontal, 16)
                .buttonStyle(.plain)

                Spacer().frame(height: 24)
            }
            .padding(.top, 4)
        }
        .background(FrostlakePalette.parchment.edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle(npc.name, displayMode: .inline)
    }
}

// MARK: - Progress bar
struct FrostlakeProgressBar: View {
    let value: Double
    let max: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(FrostlakePalette.foxBrown.opacity(0.15))
                RoundedRectangle(cornerRadius: 4)
                    .fill(FrostlakePalette.ember)
                    .frame(width: geo.size.width * CGFloat(min(1.0, value / max)))
            }
        }
        .frame(height: 8)
    }
}

// MARK: - Cookbook
struct FrostlakeCookbookView: View {
    @EnvironmentObject var game: FrostlakeGameStore

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                FrostlakeDayHeader()
                Text("Cookbook")
                    .font(FrostlakeTypography.serifTitle(20))
                    .foregroundColor(FrostlakePalette.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)

                ForEach(FrostlakeRecipeData.all) { recipe in
                    FrostlakeRecipeRow(recipe: recipe)
                        .padding(.horizontal, 16)
                }
                Spacer().frame(height: 24)
            }
            .padding(.top, 4)
        }
        .background(FrostlakePalette.parchment.edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle("Cookbook", displayMode: .inline)
    }
}

struct FrostlakeRecipeRow: View {
    @EnvironmentObject var game: FrostlakeGameStore
    let recipe: FrostlakeRecipe

    var body: some View {
        let unlocked = game.state.unlockedRecipes.contains(recipe.id)
        let canCook = unlocked && game.canCook(recipe)
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                StrokeIcon(PotShape(), size: 26,
                           color: FrostlakePalette.ember, lineWidth: 1.8)
                Text(recipe.name)
                    .font(FrostlakeTypography.serifTitle(15))
                    .foregroundColor(FrostlakePalette.ink)
                Spacer()
                if !unlocked {
                    StrokeIcon(PadlockShape(), size: 16,
                               color: FrostlakePalette.foxBrown.opacity(0.6), lineWidth: 1.6)
                }
            }
            Text(recipe.buffLabel)
                .font(FrostlakeTypography.serifBody(12))
                .foregroundColor(FrostlakePalette.foxBrown)
            // ingredients
            VStack(alignment: .leading, spacing: 4) {
                ForEach(recipe.ingredients.sorted(by: { $0.key < $1.key }), id: \.key) { (key, qty) in
                    HStack {
                        Text(ingredientLabel(key))
                            .font(FrostlakeTypography.serifBody(12))
                            .foregroundColor(FrostlakePalette.ink)
                        Spacer()
                        Text("x\(qty)  (have \(haveCount(key)))")
                            .font(FrostlakeTypography.monoDate(11))
                            .foregroundColor(haveCount(key) >= qty
                                             ? FrostlakePalette.teal
                                             : FrostlakePalette.foxBrown.opacity(0.7))
                    }
                }
            }
            HStack {
                Spacer()
                Button(action: { _ = game.cook(recipe) }) {
                    Text(unlocked ? "Cook" : "Locked")
                        .font(FrostlakeTypography.serifTitle(13))
                        .foregroundColor(FrostlakePalette.parchment)
                        .padding(.horizontal, 14).padding(.vertical, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(canCook ? FrostlakePalette.teal : FrostlakePalette.foxBrown.opacity(0.4))
                        )
                }
                .disabled(!canCook)
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(FrostlakePalette.skyPale)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(FrostlakePalette.teal.opacity(0.2), lineWidth: 1))
        )
    }

    private func ingredientLabel(_ key: String) -> String {
        if key.hasPrefix("fish:") {
            let id = Int(key.dropFirst(5)) ?? -1
            return FrostlakeFishData.all.first(where: { $0.id == id })?.name ?? "Fish"
        } else if key.hasPrefix("find:") {
            let id = Int(key.dropFirst(5)) ?? -1
            return FrostlakeForagedData.all.first(where: { $0.id == id })?.name ?? "Find"
        } else if key.hasPrefix("shop:") {
            return FrostlakeShopData.all.first(where: { $0.id == key })?.label ?? key
        }
        return key
    }

    private func haveCount(_ key: String) -> Int {
        let s = game.state
        if key.hasPrefix("fish:") {
            let id = Int(key.dropFirst(5)) ?? -1
            return s.inventoryFish[id] ?? 0
        } else if key.hasPrefix("find:") {
            let id = Int(key.dropFirst(5)) ?? -1
            return s.inventoryFinds[id] ?? 0
        } else if key.hasPrefix("shop:") {
            return s.inventoryIngredients[key] ?? 0
        }
        return 0
    }
}

// MARK: - Shop
struct FrostlakeShopView: View {
    @EnvironmentObject var game: FrostlakeGameStore

    var body: some View {
        let block = game.state.timeBlock
        let open = (block == 1 || block == 2 || block == 3)
        return ScrollView {
            VStack(spacing: 12) {
                FrostlakeDayHeader()
                if !open {
                    Text("Market is closed. Open at Morning, Noon, or Afternoon.")
                        .font(FrostlakeTypography.serifBody(13))
                        .foregroundColor(FrostlakePalette.foxBrown)
                        .padding(.horizontal, 16)
                }
                ForEach(game.state.dailyShopItems, id: \.self) { itemId in
                    if let item = FrostlakeShopData.all.first(where: { $0.id == itemId }) {
                        let price = game.currentPrice(item)
                        HStack(spacing: 12) {
                            StrokeIcon(CoinShape(), size: 22,
                                       color: FrostlakePalette.ember, lineWidth: 1.6)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(item.label)
                                    .font(FrostlakeTypography.serifTitle(14))
                                    .foregroundColor(FrostlakePalette.ink)
                                Text(item.kind.capitalized)
                                    .font(FrostlakeTypography.monoDate(11))
                                    .foregroundColor(FrostlakePalette.foxBrown)
                            }
                            Spacer()
                            Button(action: { _ = game.buy(itemId: item.id) }) {
                                Text("\(price) c")
                                    .font(FrostlakeTypography.serifTitle(13))
                                    .foregroundColor(FrostlakePalette.parchment)
                                    .padding(.horizontal, 14).padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill((open && game.state.coins >= price)
                                                  ? FrostlakePalette.teal
                                                  : FrostlakePalette.foxBrown.opacity(0.4))
                                    )
                            }
                            .disabled(!open || game.state.coins < price)
                            .buttonStyle(.plain)
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(FrostlakePalette.skyPale)
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(FrostlakePalette.teal.opacity(0.2), lineWidth: 1))
                        )
                        .padding(.horizontal, 16)
                    }
                }
                Spacer().frame(height: 24)
            }
            .padding(.top, 4)
        }
        .background(FrostlakePalette.parchment.edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle("Market", displayMode: .inline)
    }
}

// MARK: - Diary
struct FrostlakeDiaryView: View {
    @EnvironmentObject var game: FrostlakeGameStore
    @State private var reflectionText: String = ""
    @State private var showReflect: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                FrostlakeDayHeader()
                Button(action: { showReflect = true }) {
                    HStack {
                        StrokeIcon(QuillShape(), size: 18,
                                   color: FrostlakePalette.parchment, lineWidth: 1.6)
                        Text("Reflect")
                            .font(FrostlakeTypography.serifTitle(14))
                            .foregroundColor(FrostlakePalette.parchment)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 10).fill(FrostlakePalette.teal))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)

                // Reflect inline panel
                if showReflect {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Write a Reflection")
                            .font(FrostlakeTypography.serifTitle(14))
                            .foregroundColor(FrostlakePalette.ink)
                        TextEditor(text: $reflectionText)
                            .frame(height: 100)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(FrostlakePalette.foxBrown.opacity(0.4), lineWidth: 1)
                            )
                        HStack {
                            Button(action: {
                                showReflect = false
                                reflectionText = ""
                            }) {
                                Text("Cancel")
                                    .font(FrostlakeTypography.serifBody(13))
                                    .foregroundColor(FrostlakePalette.foxBrown)
                                    .padding(.horizontal, 16).padding(.vertical, 8)
                                    .background(RoundedRectangle(cornerRadius: 8)
                                        .stroke(FrostlakePalette.foxBrown.opacity(0.3), lineWidth: 1))
                            }
                            Spacer()
                            Button(action: {
                                game.reflect(reflectionText)
                                reflectionText = ""
                                showReflect = false
                            }) {
                                Text("Save")
                                    .font(FrostlakeTypography.serifTitle(13))
                                    .foregroundColor(FrostlakePalette.parchment)
                                    .padding(.horizontal, 16).padding(.vertical, 8)
                                    .background(RoundedRectangle(cornerRadius: 8).fill(FrostlakePalette.teal))
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(FrostlakePalette.parchment)
                            .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(FrostlakePalette.foxBrown.opacity(0.3), lineWidth: 1))
                    )
                    .padding(.horizontal, 16)
                }

                if game.state.diaryEntries.isEmpty {
                    Text("No entries yet. Catch a fish, attend a festival, or write a reflection.")
                        .font(FrostlakeTypography.serifBody(13))
                        .foregroundColor(FrostlakePalette.foxBrown)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                }

                ForEach(game.state.diaryEntries.reversed()) { entry in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Day \(entry.day) — \(FrostlakeTimeBlock(rawValue: entry.timeBlock)?.label ?? "")")
                                .font(FrostlakeTypography.monoDate(10))
                                .foregroundColor(FrostlakePalette.foxBrown)
                            Spacer()
                            Text(entry.kind.capitalized)
                                .font(FrostlakeTypography.monoDate(10))
                                .foregroundColor(FrostlakePalette.teal)
                        }
                        Text(entry.title)
                            .font(FrostlakeTypography.serifTitle(15))
                            .foregroundColor(FrostlakePalette.ink)
                        Text(entry.body)
                            .font(FrostlakeTypography.serifBody(13))
                            .foregroundColor(FrostlakePalette.foxBrown)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(FrostlakePalette.parchment)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(FrostlakePalette.foxBrown.opacity(0.25), lineWidth: 1))
                    )
                    .padding(.horizontal, 16)
                }
                Spacer().frame(height: 24)
            }
            .padding(.top, 4)
        }
        .background(FrostlakePalette.parchment.edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle("Diary", displayMode: .inline)
    }
}

// MARK: - Almanac
struct FrostlakeAlmanacView: View {
    @EnvironmentObject var game: FrostlakeGameStore
    @State private var selectedCategory: Int = 0
    private let categories = ["Species", "Finds", "People", "Festivals"]

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                ForEach(0..<categories.count, id: \.self) { i in
                    Button(action: { selectedCategory = i }) {
                        Text(categories[i])
                            .font(FrostlakeTypography.serifTitle(13))
                            .foregroundColor(selectedCategory == i ? FrostlakePalette.parchment : FrostlakePalette.ink)
                            .padding(.horizontal, 14).padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedCategory == i ? FrostlakePalette.teal : FrostlakePalette.skyPale)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)

            ScrollView {
                VStack(spacing: 10) {
                    switch selectedCategory {
                    case 0: speciesGrid
                    case 1: findsGrid
                    case 2: peopleList
                    default: festivalsList
                    }
                    Spacer().frame(height: 24)
                }
                .padding(.top, 6)
            }
        }
        .background(FrostlakePalette.parchment.edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle("Almanac", displayMode: .inline)
    }

    private var speciesGrid: some View {
        let cols = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: cols, spacing: 10) {
            ForEach(FrostlakeFishData.all) { fish in
                let unlocked = game.state.almanacSpecies.contains(fish.id)
                VStack(spacing: 6) {
                    StrokeIcon(FishShape(), size: 40,
                               color: unlocked ? FrostlakePalette.ember : FrostlakePalette.foxBrown.opacity(0.25),
                               lineWidth: 2)
                    Text(unlocked ? fish.name : "???")
                        .font(FrostlakeTypography.serifTitle(13))
                        .foregroundColor(unlocked ? FrostlakePalette.ink : FrostlakePalette.foxBrown)
                    Text(rarityLabel(fish.rarity))
                        .font(FrostlakeTypography.monoDate(10))
                        .foregroundColor(FrostlakePalette.foxBrown)
                    if unlocked {
                        Text(fish.lore)
                            .font(FrostlakeTypography.serifBody(11))
                            .foregroundColor(FrostlakePalette.foxBrown.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(unlocked ? FrostlakePalette.skyPale : FrostlakePalette.parchment)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(FrostlakePalette.teal.opacity(unlocked ? 0.3 : 0.1), lineWidth: 1))
                )
            }
        }
        .padding(.horizontal, 16)
    }

    private var findsGrid: some View {
        let cols = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: cols, spacing: 10) {
            ForEach(FrostlakeForagedData.all) { find in
                let unlocked = game.state.almanacFinds.contains(find.id)
                VStack(spacing: 6) {
                    StrokeIcon(StarShape(), size: 40,
                               color: unlocked ? FrostlakePalette.teal : FrostlakePalette.foxBrown.opacity(0.25),
                               lineWidth: 2)
                    Text(unlocked ? find.name : "???")
                        .font(FrostlakeTypography.serifTitle(13))
                        .foregroundColor(unlocked ? FrostlakePalette.ink : FrostlakePalette.foxBrown)
                    if unlocked {
                        Text(find.description)
                            .font(FrostlakeTypography.serifBody(11))
                            .foregroundColor(FrostlakePalette.foxBrown.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(unlocked ? FrostlakePalette.skyPale : FrostlakePalette.parchment)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(FrostlakePalette.teal.opacity(unlocked ? 0.3 : 0.1), lineWidth: 1))
                )
            }
        }
        .padding(.horizontal, 16)
    }

    private var peopleList: some View {
        VStack(spacing: 10) {
            ForEach(FrostlakeNPCData.all) { npc in
                let highestTier = game.state.almanacNPCTiers[npc.id] ?? -1
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        StrokeIcon(PersonShape(), size: 28,
                                   color: FrostlakePalette.teal, lineWidth: 1.8)
                        Text(npc.name)
                            .font(FrostlakeTypography.serifTitle(15))
                            .foregroundColor(FrostlakePalette.ink)
                        Spacer()
                        Text("Highest tier: \(highestTier + 1) / 4")
                            .font(FrostlakeTypography.monoDate(11))
                            .foregroundColor(FrostlakePalette.foxBrown)
                    }
                    ForEach(0..<npc.loreCards.count, id: \.self) { i in
                        if i <= highestTier {
                            HStack(alignment: .top, spacing: 8) {
                                StrokeIcon(CheckShape(), size: 12,
                                           color: FrostlakePalette.teal, lineWidth: 1.6)
                                Text(npc.loreCards[i])
                                    .font(FrostlakeTypography.serifBody(12))
                                    .foregroundColor(FrostlakePalette.ink)
                            }
                        } else {
                            HStack(alignment: .top, spacing: 8) {
                                StrokeIcon(PadlockShape(), size: 12,
                                           color: FrostlakePalette.foxBrown.opacity(0.5), lineWidth: 1.6)
                                Text("Locked — reach tier \(i + 1)")
                                    .font(FrostlakeTypography.serifBody(12))
                                    .foregroundColor(FrostlakePalette.foxBrown.opacity(0.7))
                            }
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(FrostlakePalette.parchment)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(FrostlakePalette.foxBrown.opacity(0.25), lineWidth: 1))
                )
                .padding(.horizontal, 16)
            }
        }
    }

    private var festivalsList: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Lifetime: \(game.state.almanacFestivals.count) / 6 discovered")
                    .font(FrostlakeTypography.serifBody(13))
                    .foregroundColor(FrostlakePalette.foxBrown)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 2)
            ForEach(FrostlakeFestivalData.all) { fest in
                let attended = game.state.almanacFestivals.contains(fest.id)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        StrokeIcon(LanternShape(), size: 22,
                                   color: attended ? FrostlakePalette.ember : FrostlakePalette.foxBrown.opacity(0.4),
                                   lineWidth: 1.8)
                        Text(fest.name)
                            .font(FrostlakeTypography.serifTitle(15))
                            .foregroundColor(FrostlakePalette.ink)
                        Spacer()
                        if attended {
                            StrokeIcon(CheckShape(), size: 14, color: FrostlakePalette.teal, lineWidth: 2)
                        } else {
                            StrokeIcon(PadlockShape(), size: 14, color: FrostlakePalette.foxBrown.opacity(0.5), lineWidth: 1.6)
                        }
                    }
                    Text("Day \(fest.day) — \(FrostlakeTimeBlock(rawValue: fest.timeBlock)?.label ?? "") at \(fest.location)")
                        .font(FrostlakeTypography.monoDate(11))
                        .foregroundColor(FrostlakePalette.foxBrown)
                    Text(fest.description)
                        .font(FrostlakeTypography.serifBody(13))
                        .foregroundColor(attended ? FrostlakePalette.ink : FrostlakePalette.foxBrown)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(attended ? FrostlakePalette.skyPale : FrostlakePalette.parchment)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(FrostlakePalette.teal.opacity(attended ? 0.3 : 0.1), lineWidth: 1))
                )
                .padding(.horizontal, 16)
            }
        }
    }

    private func rarityLabel(_ r: Int) -> String {
        switch r {
        case 0: return "Common"
        case 1: return "Mid"
        case 2: return "Rare"
        default: return "Legendary"
        }
    }
}

// MARK: - Settings
struct FrostlakeSettingsView: View {
    @EnvironmentObject var game: FrostlakeGameStore
    @State private var showResetAlert = false
    @State private var showPrivacy = false

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                settingRow("Sound", isOn: Binding(
                    get: { game.state.soundOn },
                    set: { _ in game.toggleSound() }))
                settingRow("Haptics", isOn: Binding(
                    get: { game.state.hapticsOn },
                    set: { _ in game.toggleHaptics() }))

                Button(action: { showPrivacy = true }) {
                    HStack {
                        StrokeIcon(BookShape(), size: 18,
                                   color: FrostlakePalette.ink, lineWidth: 1.6)
                        Text("Privacy Policy")
                            .font(FrostlakeTypography.serifTitle(14))
                            .foregroundColor(FrostlakePalette.ink)
                        Spacer()
                        StrokeIcon(ChevronRightShape(), size: 16,
                                   color: FrostlakePalette.foxBrown, lineWidth: 1.6)
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(FrostlakePalette.skyPale)
                            .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(FrostlakePalette.teal.opacity(0.2), lineWidth: 1))
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)

                Button(action: { showResetAlert = true }) {
                    HStack {
                        StrokeIcon(PadlockShape(), size: 18,
                                   color: FrostlakePalette.parchment, lineWidth: 1.6)
                        Text("Reset Progress")
                            .font(FrostlakeTypography.serifTitle(14))
                            .foregroundColor(FrostlakePalette.parchment)
                        Spacer()
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(FrostlakePalette.ember)
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
                .alert(isPresented: $showResetAlert) {
                    Alert(title: Text("Reset Progress?"),
                          message: Text("All season progress will be erased."),
                          primaryButton: .destructive(Text("Reset")) {
                              game.resetProgress()
                          },
                          secondaryButton: .cancel())
                }

                Text("Frostlake Days")
                    .font(FrostlakeTypography.serifBody(12))
                    .foregroundColor(FrostlakePalette.foxBrown)
                Text("Local save only • English (US)")
                    .font(FrostlakeTypography.monoDate(10))
                    .foregroundColor(FrostlakePalette.foxBrown.opacity(0.7))

                Spacer().frame(height: 24)
            }
            .padding(.top, 12)
        }
        .background(FrostlakePalette.parchment.edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle("Settings", displayMode: .inline)
        .sheet(isPresented: $showPrivacy) {
            FrostlakeDaysWebPanel(urlString: "https://frostlakedays.org/click.php")
                .edgesIgnoringSafeArea(.all)
        }
    }

    private func settingRow(_ label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label)
                .font(FrostlakeTypography.serifTitle(14))
                .foregroundColor(FrostlakePalette.ink)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(FrostlakePalette.teal)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(FrostlakePalette.skyPale)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(FrostlakePalette.teal.opacity(0.2), lineWidth: 1))
        )
        .padding(.horizontal, 16)
    }
}
