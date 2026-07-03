import SwiftUI

struct ActionTileCell: View {
    let icon: String
    let title: String
    let subtitle: String?
    let tint: Color
    let action: () -> Void

    init(icon: String, title: String, subtitle: String? = nil, tint: Color = AppColor.accent, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.tint = tint
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    IconCircle(emoji: icon, tint: tint)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(AppColor.textSecondary.opacity(0.5))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppDesign.Typography.widgetTitle)
                        .foregroundColor(AppColor.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    if let subtitle {
                        Text(subtitle)
                            .font(AppDesign.Typography.widgetMeta)
                            .foregroundColor(AppColor.textSecondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
            .padding(AppDesign.cardPadding)
            .premiumCard(accent: tint.opacity(0.15), elevation: .raised)
        }
        .buttonStyle(.plain)
    }
}

struct CategoryCell: View {
    let category: Category
    let action: () -> Void

    private var color: Color { Color(hex: category.color) }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Text(category.icon)
                        .font(.title2)
                }

                Text(category.rawValue)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(AppColor.textPrimary)

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(color)
                    .padding(8)
                    .background(color.opacity(0.12))
                    .clipShape(Circle())
            }
            .padding(12)
            .premiumCard(accent: color.opacity(0.25), elevation: .raised)
        }
        .buttonStyle(.plain)
    }
}

struct SelectOptionCell: View {
    let title: String
    var subtitle: String? = nil
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                if let icon {
                    Text(icon)
                        .font(.title2)
                        .frame(width: 36)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline.weight(.medium))
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(AppColor.textSecondary)
                    }
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? AppColor.accent : AppColor.textSecondary.opacity(0.4))
            }
            .foregroundColor(isSelected ? AppColor.textPrimary : AppColor.textPrimary)
            .padding(AppDesign.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
                    .fill(isSelected ? AnyShapeStyle(AppColor.accent.opacity(0.08)) : AnyShapeStyle(AppColor.background))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
                            .fill(AppDesign.cardSheen.opacity(isSelected ? 0.3 : 0.5))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
                    .stroke(isSelected ? AppColor.accent.opacity(0.45) : Color.black.opacity(0.05), lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct PartnerJarCell: View {
    let name: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Text("🫙")
                    .font(.system(size: 36))
                Text(name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(isSelected ? AppColor.accent : AppColor.textPrimary)
                Text("\(count) secret\(count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(AppColor.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .premiumCard(accent: isSelected ? AppColor.accent : .clear, elevation: .raised)
        }
        .buttonStyle(.plain)
    }
}

struct ChecklistCell: View {
    let item: ChecklistItem
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(item.isCompleted ? AppColor.accent : AppColor.textSecondary.opacity(0.3), lineWidth: 2)
                        .frame(width: 26, height: 26)
                    if item.isCompleted {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(AppDesign.accentGradient)
                            .frame(width: 26, height: 26)
                        Image(systemName: "checkmark")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.white)
                    }
                }

                Text(item.title)
                    .font(.body)
                    .foregroundColor(item.isCompleted ? AppColor.textSecondary : AppColor.textPrimary)
                    .strikethrough(item.isCompleted, color: AppColor.textSecondary)

                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                    .fill(item.isCompleted ? Color(.systemGray6).opacity(0.45) : AppColor.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                            .stroke(
                                item.isCompleted ? Color.clear : AppColor.accent.opacity(0.1),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

struct SettingsRowCell: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    var isDestructive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                IconCircle(emoji: icon, size: 40, tint: isDestructive ? .red : AppColor.accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundColor(isDestructive ? .red : AppColor.textPrimary)
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(AppColor.textSecondary)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(AppColor.textSecondary.opacity(0.4))
            }
            .padding(AppDesign.cardPadding)
            .premiumCard(elevation: .flat)
        }
        .buttonStyle(.plain)
    }
}

struct BringItemCell: View {
    let title: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "bag.fill")
                .font(.caption)
                .foregroundColor(AppColor.accentSecondary)
            Text(title)
                .font(.subheadline)
                .foregroundColor(AppColor.textPrimary)
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "F0F8FF"), AppColor.background],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                        .stroke(AppColor.accentSecondary.opacity(0.15), lineWidth: 1)
                )
        )
    }
}
