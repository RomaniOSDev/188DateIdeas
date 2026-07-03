import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppDesign.accentGradient)
                    .frame(width: 72, height: 72)
                    .shadow(color: AppColor.accent.opacity(0.3), radius: 10, y: 4)
                Text("💑")
                    .font(.system(size: 34))
            }

            Text("Plan Your Perfect Date")
                .font(.title2.weight(.bold))
                .foregroundColor(AppColor.textPrimary)

            Text("Spin, plan, and remember every moment")
                .font(.subheadline)
                .foregroundColor(AppColor.textSecondary)
        }
        .padding(.top, 4)
    }
}

struct StatsRowView: View {
    let total: Int
    let unused: Int
    let used: Int

    var body: some View {
        HStack(spacing: 10) {
            StatCell(value: "\(total)", label: "Total", icon: "💡", color: AppColor.accent)
            StatCell(value: "\(unused)", label: "Ready", icon: "✨", color: AppColor.accentSecondary)
            StatCell(value: "\(used)", label: "Done", icon: "✓", color: AppColor.textSecondary)
        }
    }
}

struct QuickActionsView: View {
    let onFavorites: () -> Void
    let onPersonalized: () -> Void
    let onMicro: () -> Void
    let onJar: () -> Void
    let onChallenge: () -> Void
    let onHistory: () -> Void
    let onAdd: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: "Quick Actions")

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ActionTileCell(icon: "✨", title: "For You", subtitle: "Personalized", tint: AppColor.accent, action: onPersonalized)
                ActionTileCell(icon: "⚡", title: "Micro", subtitle: "≤30 min", tint: Color(hex: "FDCB6E"), action: onMicro)
                ActionTileCell(icon: "🫙", title: "Date Jar", subtitle: "Secret ideas", tint: AppColor.accentSecondary, action: onJar)
                ActionTileCell(icon: "🏆", title: "Challenge", subtitle: "30 days", tint: Color(hex: "6C5CE7"), action: onChallenge)
                ActionTileCell(icon: "❤️", title: "Favorites", tint: .red, action: onFavorites)
                ActionTileCell(icon: "📔", title: "Journal", tint: AppColor.accent, action: onHistory)
            }

            PrimaryButton(title: "Add New Idea", icon: "➕", action: onAdd)
        }
    }
}

struct CategoryGridView: View {
    let categories: [Category]
    let onCategoryTap: (Category) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: "Categories", subtitle: "Browse by date type")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    CategoryCell(category: category) { onCategoryTap(category) }
                }
            }
        }
    }
}

struct ResultSheetView: View {
    let idea: Idea
    let onUse: () -> Void
    let onSkip: () -> Void
    let onDetail: () -> Void
    let onPlan: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 5)
                .padding(.top, 10)

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColor.accent.opacity(0.12), AppColor.accentSecondary.opacity(0.06)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .overlay(Circle().stroke(AppColor.accent.opacity(0.15), lineWidth: 1))
                    Text("🎉")
                        .font(.system(size: 44))
                }

                VStack(spacing: 6) {
                    Text("Tonight's date idea")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(AppColor.textSecondary)
                    Text(idea.title)
                        .font(.title2.weight(.bold))
                        .foregroundColor(AppColor.textPrimary)
                        .multilineTextAlignment(.center)
                }

                IdeaMetaRow(idea: idea)

                if !idea.seasonTags.isEmpty {
                    SeasonTagsRow(tags: idea.seasonTags)
                }

                VStack(spacing: 10) {
                    PrimaryButton(title: "Plan This Date", icon: "📋") {
                        onPlan()
                        dismiss()
                    }
                    PrimaryButton(title: "Use This Idea", icon: "✓") {
                        onUse()
                        dismiss()
                    }
                    SecondaryButton(title: "Skip for Now") {
                        onSkip()
                        dismiss()
                    }
                    GhostButton(title: "View Details") {
                        onDetail()
                        dismiss()
                    }
                }
            }
            .padding(24)
        }
        .background(
            LinearGradient(
                colors: [AppColor.background, Color(hex: "F5FBFF")],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
