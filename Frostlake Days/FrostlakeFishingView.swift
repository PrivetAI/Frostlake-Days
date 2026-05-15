import SwiftUI

// MARK: - Fishing hub (lists spots)
struct FrostlakeFishingHubView: View {
    @EnvironmentObject var game: FrostlakeGameStore

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                FrostlakeDayHeader()

                Text("Choose a Spot")
                    .font(FrostlakeTypography.serifTitle(20))
                    .foregroundColor(FrostlakePalette.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)

                ForEach(FrostlakeLakeSpotData.all) { spot in
                    let unlocked = game.state.unlockedSpots.contains(spot.id)
                    let dayReady = spot.unlockDay <= game.state.day
                    NavigationLink(destination: FrostlakeFishingSpotView(spot: spot)) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(spot.name)
                                    .font(FrostlakeTypography.serifTitle(16))
                                    .foregroundColor(FrostlakePalette.ink)
                                Spacer()
                                if !unlocked || !dayReady {
                                    StrokeIcon(PadlockShape(), size: 18,
                                               color: FrostlakePalette.foxBrown.opacity(0.6),
                                               lineWidth: 1.6)
                                } else {
                                    StrokeIcon(FishShape(), size: 22,
                                               color: FrostlakePalette.teal, lineWidth: 1.6)
                                }
                            }
                            Text(spot.description)
                                .font(FrostlakeTypography.serifBody(13))
                                .foregroundColor(FrostlakePalette.foxBrown)
                            if !unlocked || !dayReady {
                                Text("Unlocks Day \(spot.unlockDay)")
                                    .font(FrostlakeTypography.monoDate(10))
                                    .foregroundColor(FrostlakePalette.foxBrown.opacity(0.7))
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(unlocked && dayReady ? FrostlakePalette.skyPale : FrostlakePalette.parchment)
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(FrostlakePalette.teal.opacity(unlocked && dayReady ? 0.3 : 0.1), lineWidth: 1))
                        )
                        .padding(.horizontal, 16)
                    }
                    .disabled(!unlocked || !dayReady)
                    .buttonStyle(.plain)
                }
                Spacer().frame(height: 24)
            }
            .padding(.top, 4)
        }
        .background(FrostlakePalette.parchment.edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle("Fishing", displayMode: .inline)
    }
}

// MARK: - Bite mini-game state
enum FrostlakeBitePhase: Equatable {
    case idle
    case casting
    case biting(window: ClosedRange<Double>, indicator: Double, duration: Double, attempt: Int, fishId: Int)
    case result(success: Bool, fishId: Int?)
}

// MARK: - Spot detail (cast + mini-game)
struct FrostlakeFishingSpotView: View {
    @EnvironmentObject var game: FrostlakeGameStore
    let spot: FrostlakeLakeSpot

    @State private var phase: FrostlakeBitePhase = .idle
    @State private var indicator: Double = 0
    @State private var timerStart: Date = Date()
    @State private var ticker: Timer? = nil
    @State private var lastCaught: FrostlakeFish? = nil
    @State private var attempt: Int = 0
    @State private var hookFired: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            FrostlakeDayHeader()

            // Scene illustration
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(FrostlakePalette.skyPale)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(FrostlakePalette.teal.opacity(0.25), lineWidth: 1)
                    )
                VStack(spacing: 8) {
                    StrokeIcon(LakeHoleShape(), size: 90,
                               color: FrostlakePalette.teal, lineWidth: 2)
                    Text(spot.name)
                        .font(FrostlakeTypography.serifTitle(18))
                        .foregroundColor(FrostlakePalette.ink)
                    Text("Phase: \(FrostlakePhase(rawValue: game.state.phase)?.label ?? "")  •  Weather: \(FrostlakeWeather(rawValue: game.state.weatherToday)?.label ?? "")")
                        .font(FrostlakeTypography.monoDate(11))
                        .foregroundColor(FrostlakePalette.foxBrown)
                }
            }
            .frame(height: 170)
            .padding(.horizontal, 16)

            // Bite indicator UI
            FrostlakeBiteMeter(phase: phase, indicator: indicator)
                .frame(height: 56)
                .padding(.horizontal, 16)

            // Action panel
            actionPanel
                .padding(.horizontal, 16)

            // Recent catch
            if let last = lastCaught {
                VStack(spacing: 6) {
                    HStack(spacing: 8) {
                        StrokeIcon(FishShape(), size: 22,
                                   color: FrostlakePalette.ember, lineWidth: 1.8)
                        Text("Last catch: \(last.name)")
                            .font(FrostlakeTypography.serifTitle(15))
                            .foregroundColor(FrostlakePalette.ink)
                    }
                    Text(last.lore)
                        .font(FrostlakeTypography.serifBody(12))
                        .foregroundColor(FrostlakePalette.foxBrown)
                        .multilineTextAlignment(.center)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(FrostlakePalette.parchment)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(FrostlakePalette.foxBrown.opacity(0.2), lineWidth: 1))
                )
                .padding(.horizontal, 16)
            }

            Spacer()
        }
        .background(FrostlakePalette.parchment.edgesIgnoringSafeArea(.all))
        .navigationBarTitle(spot.name, displayMode: .inline)
        .onDisappear { stopTimer() }
    }

    @ViewBuilder
    private var actionPanel: some View {
        switch phase {
        case .idle:
            VStack(spacing: 10) {
                let isEvening = game.state.timeBlock >= 5
                let noBites = game.candidatesAt(spotId: spot.id).isEmpty
                let castDisabled = isEvening || noBites
                if isEvening {
                    Text("Time to rest. Head home and sleep to start a new day.")
                        .font(FrostlakeTypography.serifBody(13))
                        .foregroundColor(FrostlakePalette.foxBrown)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                } else if noBites {
                    Text("No fish biting here right now. Try a different time, weather, or spot.")
                        .font(FrostlakeTypography.serifBody(13))
                        .foregroundColor(FrostlakePalette.foxBrown)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                Button(action: { cast() }) {
                    HStack {
                        StrokeIcon(PathArrowShape(), size: 20,
                                   color: FrostlakePalette.parchment, lineWidth: 2)
                        Text("Cast Line")
                            .font(FrostlakeTypography.serifTitle(16))
                            .foregroundColor(FrostlakePalette.parchment)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(castDisabled
                                  ? FrostlakePalette.foxBrown.opacity(0.5)
                                  : FrostlakePalette.teal)
                    )
                }
                .disabled(castDisabled)
                .buttonStyle(.plain)
            }
        case .casting:
            Text("Casting...")
                .font(FrostlakeTypography.serifBody(14))
                .foregroundColor(FrostlakePalette.foxBrown)
        case .biting(_, _, _, let attemptIdx, _):
            VStack(spacing: 8) {
                Text("Bite!  Tap Hook when the marker enters the band.")
                    .font(FrostlakeTypography.serifBody(13))
                    .foregroundColor(FrostlakePalette.ink)
                Text("Attempt \(attemptIdx + 1) of 3")
                    .font(FrostlakeTypography.monoDate(11))
                    .foregroundColor(FrostlakePalette.foxBrown)
                Button(action: { hook() }) {
                    Text("Hook")
                        .font(FrostlakeTypography.serifTitle(16))
                        .foregroundColor(FrostlakePalette.parchment)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 10).fill(FrostlakePalette.ember))
                }
                .buttonStyle(.plain)
            }
        case .result(let success, let fishId):
            VStack(spacing: 10) {
                if success, let id = fishId, let fish = FrostlakeFishData.all.first(where: { $0.id == id }) {
                    Text("Caught: \(fish.name)")
                        .font(FrostlakeTypography.serifTitle(18))
                        .foregroundColor(FrostlakePalette.teal)
                } else {
                    Text("It got away.")
                        .font(FrostlakeTypography.serifTitle(16))
                        .foregroundColor(FrostlakePalette.foxBrown)
                }
                Button(action: {
                    phase = .idle
                    indicator = 0
                    hookFired = false
                }) {
                    Text("Continue")
                        .font(FrostlakeTypography.serifTitle(15))
                        .foregroundColor(FrostlakePalette.parchment)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 10).fill(FrostlakePalette.teal))
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Bite logic
    private func cast() {
        guard let candidate = game.rollCandidate(spotId: spot.id) else {
            phase = .result(success: false, fishId: nil)
            game.advanceTimeBlock()
            return
        }
        attempt = 0
        startBite(for: candidate.id)
    }

    private func startBite(for fishId: Int) {
        guard let fish = FrostlakeFishData.all.first(where: { $0.id == fishId }) else { return }
        let duration = game.biteDuration(for: fish)
        let windowSize = game.biteWindowFraction(for: fish)
        let centerMin = 0.30
        let centerMax = max(centerMin + windowSize, 0.95 - windowSize)
        let center = Double.random(in: centerMin...centerMax)
        let lo = max(0.05, center - windowSize / 2)
        let hi = min(0.97, center + windowSize / 2)
        phase = .biting(window: lo...hi, indicator: 0, duration: duration, attempt: attempt, fishId: fishId)
        indicator = 0
        hookFired = false
        timerStart = Date()
        startTimer(duration: duration)
    }

    private func startTimer(duration: Double) {
        stopTimer()
        // Register on the .common run-loop mode so the indicator continues to tick during
        // ScrollView tracking / sheet interactions, preventing the bite from "freezing".
        let t = Timer(timeInterval: 1.0 / 30.0, repeats: true) { _ in
            let elapsed = Date().timeIntervalSince(timerStart)
            let frac = min(1.0, elapsed / duration)
            indicator = frac
            if frac >= 1.0 && !hookFired {
                // ran out of time → miss for this attempt
                missAttempt()
            }
        }
        RunLoop.main.add(t, forMode: .common)
        ticker = t
    }

    private func stopTimer() {
        ticker?.invalidate()
        ticker = nil
    }

    private func hook() {
        guard case .biting(let window, _, _, _, let fishId) = phase else { return }
        hookFired = true
        stopTimer()
        if window.contains(indicator) {
            // success
            if let fish = FrostlakeFishData.all.first(where: { $0.id == fishId }) {
                game.recordCatch(fish)
                lastCaught = fish
                phase = .result(success: true, fishId: fish.id)
            }
            game.advanceTimeBlock()
        } else {
            missAttempt()
        }
    }

    private func missAttempt() {
        stopTimer()
        attempt += 1
        if case .biting(_, _, _, _, let fishId) = phase {
            if attempt >= 3 {
                game.failedCatch()
                phase = .result(success: false, fishId: fishId)
                game.advanceTimeBlock()
            } else {
                // retry
                hookFired = false
                startBite(for: fishId)
            }
        }
    }
}

// MARK: - Bite meter view (Shape-based, no physics)
struct FrostlakeBiteMeter: View {
    let phase: FrostlakeBitePhase
    let indicator: Double

    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height

                // Track background
                RoundedRectangle(cornerRadius: 8)
                    .fill(FrostlakePalette.parchment)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(FrostlakePalette.foxBrown.opacity(0.3), lineWidth: 1)
                    )

                // Bite window
                if case .biting(let window, _, _, _, _) = phase {
                    let lo = window.lowerBound
                    let hi = window.upperBound
                    Rectangle()
                        .fill(FrostlakePalette.ember.opacity(0.45))
                        .frame(width: max(2, CGFloat(hi - lo) * w), height: h - 8)
                        .position(x: CGFloat((lo + hi) / 2) * w, y: h / 2)
                }

                // Indicator marker
                if case .biting = phase {
                    let x = CGFloat(min(1.0, max(0.0, indicator))) * w
                    Capsule()
                        .fill(FrostlakePalette.teal)
                        .frame(width: 6, height: h - 6)
                        .position(x: x, y: h / 2)
                }
            }
        }
    }
}
