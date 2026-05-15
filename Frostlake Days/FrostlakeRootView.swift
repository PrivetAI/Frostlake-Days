import SwiftUI

struct FrostlakeRootView: View {
    @EnvironmentObject var game: FrostlakeGameStore
    @State private var selectedTab: Int = 0
    @State private var showOnboarding: Bool = false
    @State private var showSeasonSummary: Bool = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack(alignment: .bottom) {
            FrostlakePalette.parchment.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0:
                        NavigationView { FrostlakeCabinView(selectedTab: $selectedTab) }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 1:
                        NavigationView { FrostlakeMapView(selectedTab: $selectedTab) }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 2:
                        NavigationView { FrostlakeFishingHubView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 3:
                        NavigationView { FrostlakeAlmanacView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    default:
                        NavigationView { FrostlakeMoreHubView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                FrostlakeTabBar(selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.light)
        .sheet(isPresented: $showOnboarding) {
            FrostlakeOnboardingView(onDone: {
                showOnboarding = false
                game.markOnboardingSeen()
            })
            // Block swipe-to-dismiss so the user must finish or Skip the flow.
            .interactiveDismissDisabled(true)
        }
        .sheet(isPresented: $showSeasonSummary) {
            FrostlakeSeasonSummaryView(grade: game.seasonGrade) {
                showSeasonSummary = false
                game.seasonClosed = false
            }
        }
        .onAppear {
            if !game.state.onboardingSeen {
                showOnboarding = true
            }
            if game.seasonClosed {
                showSeasonSummary = true
            }
        }
        .onChange(of: game.seasonClosed) { closed in
            if closed { showSeasonSummary = true }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background || phase == .inactive {
                // autosave triggers via state didSet; nothing else needed
            }
        }
    }
}

struct FrostlakeTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 0) {
            tabButton(0, "Cabin", AnyView(StrokeIcon(CabinShape(), size: 22,
                                                    color: tint(0), lineWidth: 2)))
            tabButton(1, "Map", AnyView(StrokeIcon(CompassShape(), size: 22,
                                                   color: tint(1), lineWidth: 2)))
            tabButton(2, "Fish", AnyView(StrokeIcon(FishShape(), size: 24,
                                                    color: tint(2), lineWidth: 2)))
            tabButton(3, "Almanac", AnyView(StrokeIcon(BookShape(), size: 22,
                                                        color: tint(3), lineWidth: 2)))
            tabButton(4, "More", AnyView(StrokeIcon(ChevronRightShape(), size: 22,
                                                     color: tint(4), lineWidth: 2.4)))
        }
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(
            FrostlakePalette.mint.opacity(0.55)
                .overlay(
                    Rectangle()
                        .fill(FrostlakePalette.teal.opacity(0.2))
                        .frame(height: 1),
                    alignment: .top
                )
                .edgesIgnoringSafeArea(.bottom)
        )
    }

    private func tint(_ i: Int) -> Color {
        return selectedTab == i ? FrostlakePalette.teal : FrostlakePalette.ink.opacity(0.45)
    }

    private func tabButton(_ index: Int, _ label: String, _ icon: AnyView) -> some View {
        Button(action: { selectedTab = index }) {
            VStack(spacing: 4) {
                icon
                Text(label)
                    .font(FrostlakeTypography.serifBody(11))
                    .foregroundColor(tint(index))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Onboarding
struct FrostlakeOnboardingView: View {
    let onDone: () -> Void
    @State private var step: Int = 0
    private let steps: [(String, String)] = [
        ("Welcome to Frostlake", "A 30-day winter season in a small, watchful village. Fish, cook, and fill the Almanac."),
        ("Choose Each Time Block", "The day has six time blocks. Pick one activity per block; sleep ends the day."),
        ("Talk to Villagers Daily", "Eight neighbours move through the cove on their own schedules. Visit, gift, listen."),
        ("Complete the Almanac", "Twenty-two fish, twelve foraged finds, eight portraits, six festivals — fill them all.")
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [FrostlakePalette.parchment, FrostlakePalette.skyPale],
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 22) {
                Spacer()
                StrokeIcon(HexagonShape(), size: 64, color: FrostlakePalette.teal, lineWidth: 3)
                Text(steps[step].0)
                    .font(FrostlakeTypography.serifTitle(24))
                    .foregroundColor(FrostlakePalette.ink)
                    .multilineTextAlignment(.center)
                Text(steps[step].1)
                    .font(FrostlakeTypography.serifBody(15))
                    .foregroundColor(FrostlakePalette.foxBrown)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                HStack(spacing: 6) {
                    ForEach(0..<steps.count, id: \.self) { i in
                        Circle()
                            .fill(i == step ? FrostlakePalette.ember : FrostlakePalette.foxBrown.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }

                Spacer()

                HStack(spacing: 14) {
                    Button(action: onDone) {
                        Text("Skip")
                            .font(FrostlakeTypography.serifBody(14))
                            .foregroundColor(FrostlakePalette.foxBrown)
                            .padding(.horizontal, 22).padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(FrostlakePalette.foxBrown.opacity(0.4), lineWidth: 1.2)
                            )
                    }
                    Button(action: {
                        if step < steps.count - 1 { step += 1 } else { onDone() }
                    }) {
                        Text(step < steps.count - 1 ? "Next" : "Begin")
                            .font(FrostlakeTypography.serifTitle(15))
                            .foregroundColor(FrostlakePalette.parchment)
                            .padding(.horizontal, 28).padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(FrostlakePalette.teal)
                            )
                    }
                }
                .padding(.bottom, 36)
            }
        }
    }
}

// MARK: - Season summary
struct FrostlakeSeasonSummaryView: View {
    @EnvironmentObject var game: FrostlakeGameStore
    let grade: Int
    let onClose: () -> Void

    var body: some View {
        ZStack {
            FrostlakePalette.parchment.edgesIgnoringSafeArea(.all)
            VStack(spacing: 22) {
                Spacer()
                Text("Season Complete")
                    .font(FrostlakeTypography.serifTitle(26))
                    .foregroundColor(FrostlakePalette.ink)
                Text("Grade: \(game.gradeLabel(grade))")
                    .font(FrostlakeTypography.serifTitle(48))
                    .foregroundColor(FrostlakePalette.ember)
                summaryRow("Species recorded", "\(game.state.almanacSpecies.count) / 22")
                summaryRow("Foraged finds", "\(game.state.almanacFinds.count) / 12")
                summaryRow("Festivals attended (this season)", "\(game.state.festivalsAttended.count) / 6")
                summaryRow("Seasons completed", "\(game.state.seasonsCompleted)")
                summaryRow("Best grade", game.gradeLabel(game.state.bestSeasonGrade))
                Spacer()
                Button(action: onClose) {
                    Text("Begin Again")
                        .font(FrostlakeTypography.serifTitle(15))
                        .foregroundColor(FrostlakePalette.parchment)
                        .padding(.horizontal, 32).padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 10).fill(FrostlakePalette.teal))
                }
                .padding(.bottom, 36)
            }
            .padding(.horizontal, 28)
        }
    }

    private func summaryRow(_ key: String, _ val: String) -> some View {
        HStack {
            Text(key).font(FrostlakeTypography.serifBody(15))
                .foregroundColor(FrostlakePalette.foxBrown)
            Spacer()
            Text(val).font(FrostlakeTypography.serifTitle(15))
                .foregroundColor(FrostlakePalette.ink)
        }
        .padding(.vertical, 4)
    }
}
