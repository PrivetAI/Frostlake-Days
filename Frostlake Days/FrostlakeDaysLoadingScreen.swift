import SwiftUI

struct FrostlakeDaysLoadingScreen: View {
    @State private var pulse: Bool = false
    @State private var arcRotation: Double = 0
    // Guard against re-entry of withAnimation on re-appear (e.g. scene-phase flips).
    @State private var animationStarted: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [FrostlakePalette.parchment, FrostlakePalette.skyPale],
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 28) {
                ZStack {
                    Circle()
                        .stroke(FrostlakePalette.teal.opacity(0.18), lineWidth: 6)
                        .frame(width: 132, height: 132)

                    HexagonShape()
                        .stroke(FrostlakePalette.teal, lineWidth: 4)
                        .frame(width: 92, height: 92)
                        .scaleEffect(pulse ? 1.04 : 0.94)

                    HexagonShape()
                        .fill(FrostlakePalette.ember.opacity(0.12))
                        .frame(width: 92, height: 92)

                    Circle()
                        .fill(FrostlakePalette.ember)
                        .frame(width: 16, height: 16)
                }
                .rotationEffect(.degrees(arcRotation))

                Text("Frostlake Days")
                    .font(FrostlakeTypography.serifTitle(22))
                    .foregroundColor(FrostlakePalette.ink)

                Text("Tending the winter cove...")
                    .font(FrostlakeTypography.serifBody(13))
                    .foregroundColor(FrostlakePalette.foxBrown.opacity(0.8))
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            guard !animationStarted else { return }
            animationStarted = true
            withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse = true
            }
            withAnimation(Animation.linear(duration: 12).repeatForever(autoreverses: false)) {
                arcRotation = 360
            }
        }
    }
}
