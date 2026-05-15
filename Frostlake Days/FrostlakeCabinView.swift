import SwiftUI

struct FrostlakeCabinView: View {
    @EnvironmentObject var game: FrostlakeGameStore
    @Binding var selectedTab: Int
    @State private var showSleepConfirm = false

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // Header
                FrostlakeDayHeader()

                // Cabin illustration (parchment card)
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(FrostlakePalette.parchment)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(FrostlakePalette.foxBrown.opacity(0.35), lineWidth: 1.5)
                        )
                    VStack(spacing: 6) {
                        StrokeIcon(CabinShape(), size: 140,
                                   color: FrostlakePalette.foxBrown, lineWidth: 3)
                            .padding(.top, 16)
                        Text("Your Cabin")
                            .font(FrostlakeTypography.serifTitle(18))
                            .foregroundColor(FrostlakePalette.ink)
                        Text("Fatigue: \(String(format: "%.1f", game.state.fatigue)) / 10")
                            .font(FrostlakeTypography.serifBody(13))
                            .foregroundColor(FrostlakePalette.foxBrown)
                        if let buff = game.state.buffsActiveKey, game.state.buffsDaysRemaining > 0 {
                            Text("Active buff: \(buff) (\(game.state.buffsDaysRemaining)d)")
                                .font(FrostlakeTypography.monoDate(11))
                                .foregroundColor(FrostlakePalette.ember)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.bottom, 14)
                }
                .frame(height: 230)
                .padding(.horizontal, 16)

                // Sleep button if Evening
                if game.state.timeBlock == 5 {
                    Button(action: { showSleepConfirm = true }) {
                        HStack {
                            StrokeIcon(SnowflakeShape(), size: 18,
                                       color: FrostlakePalette.parchment, lineWidth: 1.6)
                            Text("Sleep — End Day \(game.state.day)")
                                .font(FrostlakeTypography.serifTitle(15))
                                .foregroundColor(FrostlakePalette.parchment)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 10).fill(FrostlakePalette.teal))
                    }
                    .padding(.horizontal, 16)
                    .alert(isPresented: $showSleepConfirm) {
                        Alert(title: Text("End Day?"),
                              message: Text("You will sleep and the next day will begin."),
                              primaryButton: .default(Text("Sleep")) {
                                  game.sleep()
                              },
                              secondaryButton: .cancel())
                    }
                }

                // Quick actions
                HStack(spacing: 12) {
                    quickAction("Map", AnyView(StrokeIcon(CompassShape(), size: 26,
                                                          color: FrostlakePalette.teal, lineWidth: 2))) {
                        selectedTab = 1
                    }
                    quickAction("Fish", AnyView(StrokeIcon(FishShape(), size: 26,
                                                           color: FrostlakePalette.teal, lineWidth: 2))) {
                        selectedTab = 2
                    }
                    quickAction("Almanac", AnyView(StrokeIcon(BookShape(), size: 26,
                                                              color: FrostlakePalette.teal, lineWidth: 2))) {
                        selectedTab = 3
                    }
                }
                .padding(.horizontal, 16)

                // Rooms
                VStack(alignment: .leading, spacing: 10) {
                    Text("Rooms")
                        .font(FrostlakeTypography.serifTitle(18))
                        .foregroundColor(FrostlakePalette.ink)
                        .padding(.horizontal, 16)
                    ForEach(FrostlakeRoomData.all) { room in
                        FrostlakeRoomCard(room: room)
                            .padding(.horizontal, 16)
                    }
                }

                // Inventory glance
                FrostlakeInventoryGlance()
                    .padding(.horizontal, 16)

                Spacer().frame(height: 30)
            }
            .padding(.top, 6)
        }
        .background(FrostlakePalette.parchment.edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle("Frostlake", displayMode: .inline)
    }

    private func quickAction(_ label: String, _ icon: AnyView, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                icon
                Text(label)
                    .font(FrostlakeTypography.serifBody(13))
                    .foregroundColor(FrostlakePalette.ink)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(FrostlakePalette.skyPale)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(FrostlakePalette.teal.opacity(0.25), lineWidth: 1)))
        }
        .buttonStyle(.plain)
    }
}

struct FrostlakeDayHeader: View {
    @EnvironmentObject var game: FrostlakeGameStore

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                chip(label: "Day \(game.state.day) / 30",
                     icon: AnyView(StrokeIcon(QuillShape(), size: 16,
                                              color: FrostlakePalette.ink, lineWidth: 2)))
                chip(label: FrostlakePhase(rawValue: game.state.phase)?.label ?? "Frost",
                     icon: AnyView(StrokeIcon(SnowflakeShape(), size: 16,
                                              color: FrostlakePalette.teal, lineWidth: 1.6)))
            }
            HStack(spacing: 10) {
                chip(label: (FrostlakeTimeBlock(rawValue: game.state.timeBlock)?.label ?? "Dawn")
                        + " " + (FrostlakeTimeBlock(rawValue: game.state.timeBlock)?.hourLabel ?? ""),
                     icon: AnyView(StrokeIcon(LanternShape(), size: 16,
                                              color: FrostlakePalette.ember, lineWidth: 1.8)))
                chip(label: FrostlakeWeather(rawValue: game.state.weatherToday)?.label ?? "Clear",
                     icon: AnyView(StrokeIcon(SnowflakeShape(), size: 16,
                                              color: FrostlakePalette.foxBrown, lineWidth: 1.6)))
                chip(label: "\(game.state.coins) c",
                     icon: AnyView(StrokeIcon(CoinShape(), size: 16,
                                              color: FrostlakePalette.ember, lineWidth: 1.6)))
            }
        }
        .padding(.horizontal, 16)
    }

    private func chip(label: String, icon: AnyView) -> some View {
        HStack(spacing: 6) {
            icon
            Text(label)
                .font(FrostlakeTypography.monoDate(11))
                .foregroundColor(FrostlakePalette.ink)
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(FrostlakePalette.parchment)
                .overlay(RoundedRectangle(cornerRadius: 6)
                    .stroke(FrostlakePalette.foxBrown.opacity(0.3), lineWidth: 1))
        )
    }
}

struct FrostlakeRoomCard: View {
    @EnvironmentObject var game: FrostlakeGameStore
    let room: FrostlakeRoom

    var body: some View {
        let tier = game.state.homeTiers[room.id]
        let nextCost = tier < 4 ? FrostlakeRoomData.upgradeCost(roomId: room.id, tier: tier) : 0
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(room.name)
                    .font(FrostlakeTypography.serifTitle(16))
                    .foregroundColor(FrostlakePalette.ink)
                Spacer()
                Text("Tier \(tier)/4")
                    .font(FrostlakeTypography.monoDate(11))
                    .foregroundColor(FrostlakePalette.foxBrown)
            }
            Text(room.description)
                .font(FrostlakeTypography.serifBody(13))
                .foregroundColor(FrostlakePalette.foxBrown.opacity(0.9))
            HStack(spacing: 6) {
                ForEach(0..<5) { i in
                    Rectangle()
                        .fill(i <= tier ? FrostlakePalette.ember : FrostlakePalette.foxBrown.opacity(0.15))
                        .frame(height: 6)
                        .cornerRadius(2)
                }
            }
            HStack {
                Spacer()
                if tier < 4 {
                    Button(action: {
                        _ = game.upgradeRoom(room.id)
                    }) {
                        HStack(spacing: 6) {
                            StrokeIcon(CoinShape(), size: 14, color: FrostlakePalette.parchment, lineWidth: 1.4)
                            Text("Upgrade \(nextCost) c")
                                .font(FrostlakeTypography.serifTitle(13))
                                .foregroundColor(FrostlakePalette.parchment)
                        }
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(game.state.coins >= nextCost ? FrostlakePalette.teal : FrostlakePalette.foxBrown.opacity(0.4)))
                    }
                    .disabled(game.state.coins < nextCost)
                    .buttonStyle(.plain)
                } else {
                    Text("Maxed")
                        .font(FrostlakeTypography.serifTitle(13))
                        .foregroundColor(FrostlakePalette.foxBrown)
                }
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
}

struct FrostlakeInventoryGlance: View {
    @EnvironmentObject var game: FrostlakeGameStore

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Larder")
                .font(FrostlakeTypography.serifTitle(18))
                .foregroundColor(FrostlakePalette.ink)
            // fish caught
            row("Fish caught (count)",
                value: "\(game.state.inventoryFish.values.reduce(0, +))")
            row("Foraged finds", value: "\(game.state.inventoryFinds.values.reduce(0, +))")
            row("Ingredients", value: "\(game.state.inventoryIngredients.values.reduce(0, +))")
            row("Recipes unlocked", value: "\(game.state.unlockedRecipes.count) / 18")
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(FrostlakePalette.parchment)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(FrostlakePalette.foxBrown.opacity(0.25), lineWidth: 1))
        )
    }

    private func row(_ k: String, value: String) -> some View {
        HStack {
            Text(k).font(FrostlakeTypography.serifBody(14))
                .foregroundColor(FrostlakePalette.foxBrown)
            Spacer()
            Text(value).font(FrostlakeTypography.serifTitle(14))
                .foregroundColor(FrostlakePalette.ink)
        }
        .padding(.vertical, 2)
    }
}
