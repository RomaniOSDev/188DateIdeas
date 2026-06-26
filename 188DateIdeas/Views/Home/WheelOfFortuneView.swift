import SwiftUI

struct WheelOfFortuneView: View {
    @Binding var isSpinning: Bool
    @Binding var selectedIdea: Idea?
    let onSpin: () -> Bool
    let onUse: (Idea) -> Void
    let onSkip: () -> Void
    let onDetail: (Idea) -> Void
    let onPlan: (Idea) -> Void

    @State private var rotationAngle: Double = 0

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(AppColor.accent.opacity(0.08))
                    .frame(width: 300, height: 300)
                    .shadow(color: AppColor.accent.opacity(0.22), radius: 12, y: 6)

                Circle()
                    .fill(AppDesign.accentGradient)
                    .frame(width: 260, height: 260)
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(.easeInOut(duration: 2.0), value: rotationAngle)

                ForEach(0..<8, id: \.self) { index in
                    Triangle()
                        .fill(Color.white.opacity(0.55))
                        .frame(width: 10, height: 22)
                        .offset(y: -118)
                        .rotationEffect(.degrees(Double(index) * 45))
                }

                Circle()
                    .fill(.white)
                    .frame(width: 68, height: 68)
                    .overlay(Circle().stroke(AppColor.accent.opacity(0.1), lineWidth: 1))

                Image(systemName: "heart.fill")
                    .font(.title)
                    .foregroundStyle(AppDesign.accentGradient)

                VStack {
                    Triangle()
                        .fill(AppColor.accent)
                        .frame(width: 16, height: 20)
                        .rotationEffect(.degrees(180))
                        .offset(y: -158)
                    Spacer()
                }
                .frame(width: 260, height: 260)
            }

            Button {
                guard !isSpinning else { return }
                let started = onSpin()
                if started {
                    withAnimation { rotationAngle += 720 + Double.random(in: 0...360) }
                }
            } label: {
                HStack(spacing: 8) {
                    if isSpinning {
                        ProgressView().tint(.white)
                    }
                    Text(isSpinning ? "Spinning..." : "Spin the Wheel")
                        .font(.headline.weight(.bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 44)
                .padding(.vertical, 16)
                .background(
                    Capsule()
                        .fill(isSpinning ? AnyShapeStyle(Color.gray) : AnyShapeStyle(AppDesign.accentGradient))
                )
                .shadow(color: isSpinning ? .clear : AppColor.accent.opacity(0.35), radius: 10, y: 5)
            }
            .disabled(isSpinning)
        }
        .sheet(item: $selectedIdea) { idea in
            ResultSheetView(
                idea: idea,
                onUse: { onUse(idea) },
                onSkip: onSkip,
                onDetail: { onDetail(idea) },
                onPlan: { onPlan(idea) }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(24)
        }
    }
}
