import SwiftUI

struct IdeaCell: View {
    let idea: Idea
    let onTap: () -> Void
    let onFavorite: () -> Void

    private var accentColor: Color {
        Color(hex: idea.category.color)
    }

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 0) {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(accentColor)
                    .frame(width: 4)
                    .padding(.vertical, 4)

                HStack(alignment: .top, spacing: 12) {
                    IconCircle(emoji: idea.category.icon, size: 48, tint: accentColor)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(idea.title)
                                    .font(.headline.weight(.semibold))
                                    .foregroundColor(AppColor.textPrimary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)

                                Text(idea.description)
                                    .font(.subheadline)
                                    .foregroundColor(AppColor.textSecondary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }

                            Spacer(minLength: 8)

                            Button(action: onFavorite) {
                                Image(systemName: idea.isFavorite ? "heart.fill" : "heart")
                                    .font(.title3)
                                    .foregroundColor(idea.isFavorite ? .red : AppColor.textSecondary.opacity(0.5))
                                    .padding(4)
                            }
                            .buttonStyle(.plain)
                        }

                        IdeaMetaRow(idea: idea)

                        if !idea.seasonTags.isEmpty {
                            SeasonTagsRow(tags: idea.seasonTags)
                        }
                    }
                }
                .padding(.leading, 12)
                .padding(.vertical, AppDesign.cardPadding)
                .padding(.trailing, AppDesign.cardPadding)
            }
            .premiumCard(accent: accentColor.opacity(0.3), elevation: .flat)
        }
        .buttonStyle(.plain)
    }
}

struct IdeaMetaRow: View {
    let idea: Idea

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                CategoryTagView(category: idea.category)
                BudgetBadgeView(budget: idea.budget)
                TimeBadgeView(time: idea.timeRequired)

                if idea.isMicroDate {
                    MetaPill(text: "⚡ Micro", color: Color(hex: "FDCB6E"))
                }
                if idea.jarOwner != nil {
                    MetaPill(text: "🫙 Jar", color: AppColor.accentSecondary)
                }
                if idea.isUsed {
                    MetaPill(text: "✓ Done", color: AppColor.textSecondary)
                }
            }
        }
    }
}

struct MetaPill: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(color.opacity(0.12))
                    .overlay(Capsule().stroke(color.opacity(0.18), lineWidth: 1))
            )
    }
}

// Backward compatibility
typealias IdeaCardView = IdeaCell

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        PillChipView(title: title, isSelected: isSelected, action: action)
    }
}
