import SwiftUI

struct FrostlakeMapView: View {
    @EnvironmentObject var game: FrostlakeGameStore
    @Binding var selectedTab: Int
    @State private var attendedFestivalName: String? = nil
    @State private var showAttendedToast: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                FrostlakeDayHeader()

                // Attend Festival: visible only when current day+time matches an unattended festival.
                if let fest = game.currentFestivalIfAny() {
                    Button(action: {
                        if let attended = game.attendCurrentFestival() {
                            attendedFestivalName = attended.name
                            showAttendedToast = true
                        }
                    }) {
                        HStack(spacing: 10) {
                            StrokeIcon(LanternShape(), size: 18,
                                       color: FrostlakePalette.parchment, lineWidth: 1.8)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Attend Festival: \(fest.name)")
                                    .font(FrostlakeTypography.serifTitle(14))
                                    .foregroundColor(FrostlakePalette.parchment)
                                Text(fest.location)
                                    .font(FrostlakeTypography.monoDate(11))
                                    .foregroundColor(FrostlakePalette.parchment.opacity(0.85))
                            }
                            Spacer()
                            StrokeIcon(ChevronRightShape(), size: 14,
                                       color: FrostlakePalette.parchment, lineWidth: 1.6)
                        }
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 10).fill(FrostlakePalette.ember))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 16)
                }

                // Parchment map illustration
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(FrostlakePalette.parchment)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(FrostlakePalette.foxBrown.opacity(0.4), lineWidth: 1.5)
                        )
                    GeometryReader { geo in
                        let w = geo.size.width
                        let h = geo.size.height
                        ZStack {
                            // shore curve
                            Path { p in
                                p.move(to: CGPoint(x: w * 0.05, y: h * 0.30))
                                p.addQuadCurve(to: CGPoint(x: w * 0.95, y: h * 0.30),
                                               control: CGPoint(x: w * 0.5, y: h * 0.05))
                                p.addQuadCurve(to: CGPoint(x: w * 0.05, y: h * 0.30),
                                               control: CGPoint(x: w * 0.5, y: h * 0.80))
                            }
                            .stroke(FrostlakePalette.teal.opacity(0.6), style: StrokeStyle(lineWidth: 2, dash: [4, 3]))
                            // lake fill
                            Path { p in
                                p.move(to: CGPoint(x: w * 0.18, y: h * 0.40))
                                p.addQuadCurve(to: CGPoint(x: w * 0.82, y: h * 0.40),
                                               control: CGPoint(x: w * 0.5, y: h * 0.20))
                                p.addQuadCurve(to: CGPoint(x: w * 0.18, y: h * 0.40),
                                               control: CGPoint(x: w * 0.5, y: h * 0.70))
                            }
                            .fill(FrostlakePalette.skyPale)

                            // Inn icon
                            placeIcon(AnyView(StrokeIcon(CabinShape(), size: 22,
                                                         color: FrostlakePalette.foxBrown, lineWidth: 1.6)),
                                      label: "Inn", at: CGPoint(x: w * 0.10, y: h * 0.85))
                            // Market icon
                            placeIcon(AnyView(StrokeIcon(MugShape(), size: 22,
                                                         color: FrostlakePalette.foxBrown, lineWidth: 1.6)),
                                      label: "Market", at: CGPoint(x: w * 0.32, y: h * 0.92))
                            // Forge
                            placeIcon(AnyView(StrokeIcon(BonfireShape(), size: 22,
                                                         color: FrostlakePalette.ember, lineWidth: 1.6)),
                                      label: "Forge", at: CGPoint(x: w * 0.56, y: h * 0.92))
                            // Forest
                            placeIcon(AnyView(StrokeIcon(QuillShape(), size: 22,
                                                         color: FrostlakePalette.foxBrown, lineWidth: 1.6)),
                                      label: "Forest", at: CGPoint(x: w * 0.85, y: h * 0.85))

                            // Lake spots
                            placeIcon(AnyView(StrokeIcon(LakeHoleShape(), size: 24,
                                                         color: FrostlakePalette.teal, lineWidth: 1.6)),
                                      label: "Old Hole", at: CGPoint(x: w * 0.20, y: h * 0.30))
                            placeIcon(AnyView(StrokeIcon(PierShape(), size: 24,
                                                         color: FrostlakePalette.teal, lineWidth: 1.6)),
                                      label: "Stone Pier", at: CGPoint(x: w * 0.42, y: h * 0.20))
                            placeIcon(AnyView(StrokeIcon(SnowflakeShape(), size: 22,
                                                         color: FrostlakePalette.teal, lineWidth: 1.6)),
                                      label: "Mid-Lake", at: CGPoint(x: w * 0.62, y: h * 0.18))
                            placeIcon(AnyView(StrokeIcon(LanternShape(), size: 22,
                                                         color: FrostlakePalette.ember, lineWidth: 1.6)),
                                      label: "Cape", at: CGPoint(x: w * 0.82, y: h * 0.32))
                        }
                    }
                }
                .frame(height: 240)
                .padding(.horizontal, 16)

                // Lake spot list (tappable)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Lake Spots")
                        .font(FrostlakeTypography.serifTitle(18))
                        .foregroundColor(FrostlakePalette.ink)
                        .padding(.horizontal, 16)
                    ForEach(FrostlakeLakeSpotData.all) { spot in
                        let unlocked = game.state.unlockedSpots.contains(spot.id)
                        let day = game.state.day
                        let dayReady = spot.unlockDay <= day
                        NavigationLink(destination: FrostlakeFishingSpotView(spot: spot)) {
                            FrostlakeLakeSpotRow(spot: spot,
                                                unlocked: unlocked,
                                                dayReady: dayReady)
                                .padding(.horizontal, 16)
                        }
                        .disabled(!unlocked || !dayReady)
                        .buttonStyle(.plain)
                    }
                }

                // Village places (NPC list shortcuts)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Village Places")
                        .font(FrostlakeTypography.serifTitle(18))
                        .foregroundColor(FrostlakePalette.ink)
                        .padding(.horizontal, 16)

                    villagePlaceLink("Inn", icon: AnyView(StrokeIcon(CabinShape(), size: 22,
                                                                     color: FrostlakePalette.foxBrown, lineWidth: 1.6)))
                    villagePlaceLink("Market", icon: AnyView(StrokeIcon(MugShape(), size: 22,
                                                                        color: FrostlakePalette.foxBrown, lineWidth: 1.6)))
                    villagePlaceLink("Forge", icon: AnyView(StrokeIcon(BonfireShape(), size: 22,
                                                                       color: FrostlakePalette.ember, lineWidth: 1.6)))
                    villagePlaceLink("Forest Edge", icon: AnyView(StrokeIcon(QuillShape(), size: 22,
                                                                             color: FrostlakePalette.foxBrown, lineWidth: 1.6)))
                }

                Spacer().frame(height: 28)
            }
            .padding(.top, 4)
        }
        .background(FrostlakePalette.parchment.edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle("Cove Map", displayMode: .inline)
        .alert(isPresented: $showAttendedToast) {
            Alert(title: Text("Festival Attended"),
                  message: Text(attendedFestivalName.map { "You joined the \($0). Diary updated." }
                                ?? "Festival recorded in your almanac."),
                  dismissButton: .default(Text("OK")))
        }
    }

    private func placeIcon(_ icon: AnyView, label: String, at point: CGPoint) -> some View {
        VStack(spacing: 2) {
            icon
            Text(label)
                .font(FrostlakeTypography.monoDate(9))
                .foregroundColor(FrostlakePalette.ink)
        }
        .position(point)
    }

    @ViewBuilder
    private func villagePlaceLink(_ name: String, icon: AnyView) -> some View {
        let npcs = FrostlakeNPCData.all.filter { npc in
            npc.schedule[game.state.timeBlock].contains(name)
        }
        // Tapping a village place now opens the Talk list (where the listed villagers can be visited).
        NavigationLink(destination: FrostlakeTalkListView()) {
            HStack(spacing: 12) {
                icon
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(FrostlakeTypography.serifTitle(15))
                        .foregroundColor(FrostlakePalette.ink)
                    Text(npcs.isEmpty ? "Quiet right now" : npcs.map { $0.name }.joined(separator: ", "))
                        .font(FrostlakeTypography.serifBody(12))
                        .foregroundColor(FrostlakePalette.foxBrown)
                }
                Spacer()
                StrokeIcon(ChevronRightShape(), size: 18, color: FrostlakePalette.foxBrown, lineWidth: 1.6)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(FrostlakePalette.skyPale)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(FrostlakePalette.teal.opacity(0.2), lineWidth: 1))
            )
            .padding(.horizontal, 16)
        }
        .buttonStyle(.plain)
    }
}

struct FrostlakeLakeSpotRow: View {
    @EnvironmentObject var game: FrostlakeGameStore
    let spot: FrostlakeLakeSpot
    let unlocked: Bool
    let dayReady: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            StrokeIcon(LakeHoleShape(), size: 26,
                       color: FrostlakePalette.teal, lineWidth: 1.8)
            VStack(alignment: .leading, spacing: 4) {
                Text(spot.name)
                    .font(FrostlakeTypography.serifTitle(15))
                    .foregroundColor(FrostlakePalette.ink)
                Text(spot.description)
                    .font(FrostlakeTypography.serifBody(12))
                    .foregroundColor(FrostlakePalette.foxBrown)
                if !dayReady || !unlocked {
                    Text("Unlocks Day \(spot.unlockDay)")
                        .font(FrostlakeTypography.monoDate(10))
                        .foregroundColor(FrostlakePalette.foxBrown.opacity(0.7))
                }
            }
            Spacer()
            if !dayReady || !unlocked {
                StrokeIcon(PadlockShape(), size: 18,
                           color: FrostlakePalette.foxBrown.opacity(0.6), lineWidth: 1.6)
            } else {
                StrokeIcon(ChevronRightShape(), size: 18,
                           color: FrostlakePalette.foxBrown, lineWidth: 1.6)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(unlocked && dayReady ? FrostlakePalette.skyPale : FrostlakePalette.parchment)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(FrostlakePalette.teal.opacity(unlocked && dayReady ? 0.3 : 0.1), lineWidth: 1))
        )
    }
}
