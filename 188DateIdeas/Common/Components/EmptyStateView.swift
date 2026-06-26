import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColor.accent.opacity(0.14), AppColor.accentSecondary.opacity(0.06)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(Circle().stroke(AppColor.accent.opacity(0.15), lineWidth: 1))
                Text(icon)
                    .font(.system(size: 48))
            }

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundColor(AppColor.textPrimary)

                Text(message)
                    .font(.subheadline)
                    .foregroundColor(AppColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            PrimaryButton(title: buttonTitle, action: action)
                .padding(.horizontal, 24)
        }
        .padding(32)
    }
}
