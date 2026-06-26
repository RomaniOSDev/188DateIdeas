import SwiftUI

struct AppBackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.body.weight(.semibold))
                Text("Back")
                    .font(.subheadline.weight(.medium))
            }
            .foregroundColor(AppColor.accent)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(AppColor.accent.opacity(0.1))
                    .overlay(Capsule().stroke(AppColor.accent.opacity(0.15), lineWidth: 1))
            )
        }
    }
}

struct SectionHeaderView: View {
    let title: String
    var subtitle: String? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(AppDesign.accentGradient)
                .frame(width: 3, height: 22)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundColor(AppColor.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(AppColor.textSecondary)
                }
            }

            Spacer()

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(AppColor.accent)
            }
        }
    }
}

struct AppSearchField: View {
    @Binding var text: String
    var placeholder: String = "Search..."

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColor.accent.opacity(0.7))
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColor.textSecondary.opacity(0.6))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                .fill(AppColor.background)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                        .fill(AppDesign.cardSheen.opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                        .stroke(AppColor.accent.opacity(0.12), lineWidth: 1)
                )
        )
        .compositingGroup()
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }
}

struct PillChipView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(chipBackground)
                .foregroundColor(isSelected ? .white : AppColor.textPrimary)
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.black.opacity(0.05), lineWidth: 1)
                )
                .compositingGroup()
                .shadow(color: isSelected ? AppColor.accent.opacity(0.22) : .clear, radius: 6, y: 2)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var chipBackground: some View {
        if isSelected {
            Capsule().fill(AppDesign.accentGradient)
        } else {
            Capsule()
                .fill(AppColor.background)
                .overlay(Capsule().fill(AppDesign.cardSheen.opacity(0.6)))
        }
    }
}

struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Text(icon) }
                Text(title)
                    .font(.headline.weight(.semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(buttonBackground)
            .compositingGroup()
            .shadow(color: isEnabled ? AppColor.accent.opacity(0.28) : .clear, radius: 8, y: 4)
        }
        .disabled(!isEnabled)
    }

    @ViewBuilder
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
            .fill(isEnabled ? AnyShapeStyle(AppDesign.accentGradient) : AnyShapeStyle(Color.gray.opacity(0.4)))
            .overlay(
                RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                    .fill(AppDesign.cardSheen.opacity(isEnabled ? 0.25 : 0))
            )
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundColor(AppColor.accentSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                        .fill(Color(hex: "F0F8FF"))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                                .stroke(AppColor.accentSecondary.opacity(0.25), lineWidth: 1)
                        )
                )
        }
    }
}

struct GhostButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundColor(AppColor.textSecondary)
        }
    }
}

struct IconCircle: View {
    let emoji: String
    var size: CGFloat = 44
    var tint: Color = AppColor.accent

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [tint.opacity(0.18), tint.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay(
                    Circle().stroke(tint.opacity(0.2), lineWidth: 1)
                )
            Text(emoji)
                .font(.system(size: size * 0.45))
        }
    }
}
