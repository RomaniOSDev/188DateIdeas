import SwiftUI

struct BadgeCell: View {
    let badge: BadgeType
    let isEarned: Bool

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        isEarned
                            ? AnyShapeStyle(AppDesign.accentGradient)
                            : AnyShapeStyle(LinearGradient(
                                colors: [Color(.systemGray5), Color(.systemGray6)],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                    )
                    .frame(width: 56, height: 56)
                    .overlay(Circle().stroke(Color.white.opacity(isEarned ? 0.35 : 0), lineWidth: 2))

                Text(badge.icon)
                    .font(.title2)
                    .opacity(isEarned ? 1 : 0.35)
            }

            Text(badge.title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(isEarned ? AppColor.textPrimary : AppColor.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text(badge.description)
                .font(.caption2)
                .foregroundColor(AppColor.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 150)
        .premiumCard(accent: isEarned ? AppColor.accent : .clear, elevation: isEarned ? .raised : .flat)
        .opacity(isEarned ? 1 : 0.75)
    }
}

struct StatCell: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            IconCircle(emoji: icon, size: 40, tint: color)
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundColor(color)
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundColor(AppColor.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .tintedCard(gradient: AppDesign.tintedGradient(color), accent: color, elevation: .raised)
    }
}

struct StreakBannerCell: View {
    let streak: Int
    let badges: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.22))
                        .frame(width: 52, height: 52)
                        .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                    Text("🔥")
                        .font(.title)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(streak)-week streak")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                    Text("Keep the momentum going!")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.88))
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("🏅")
                    Text("\(badges)")
                        .font(.title3.weight(.bold))
                        .foregroundColor(.white)
                    Text("badges")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.85))
                }
            }
            .padding(AppDesign.cardPadding)
            .gradientBanner()
        }
        .buttonStyle(.plain)
    }
}
