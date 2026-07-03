import SwiftUI

// MARK: - Hero Banner

struct HomeHeroBannerView: View {
    let greeting: String
    let coupleNames: String
    let readyCount: Int

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image("HomeHero")
                .resizable()
                .scaledToFill()
                .frame(minHeight: 176)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.62), .black.opacity(0.2), .clear],
                startPoint: .bottom,
                endPoint: .top
            )

            VStack(alignment: .leading, spacing: 8) {
                Text(greeting)
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.white.opacity(0.92))
                    .textCase(.uppercase)

                Text(coupleNames)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.footnote.weight(.semibold))
                    Text("\(readyCount) ideas ready")
                        .font(.footnote.weight(.medium))
                        .lineLimit(1)
                }
                .foregroundColor(.white.opacity(0.95))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(.white.opacity(0.22))
                .clipShape(Capsule())
            }
            .padding(18)
        }
        .frame(minHeight: 176)
        .clipShape(RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous))
        .compositingGroup()
        .shadow(color: AppColor.accent.opacity(0.22), radius: 12, y: 5)
    }
}

// MARK: - Widget Grid

struct HomeWidgetGridView: View {
    let streak: Int
    let badges: Int
    let challengeProgress: ChallengeProgress
    let featuredIdea: Idea?
    let jarCount: Int
    let onBadges: () -> Void
    let onChallenge: () -> Void
    let onTonight: () -> Void
    let onJar: () -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var columns: [GridItem] {
        if horizontalSizeClass == .regular {
            return [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
        }
        return [GridItem(.flexible(), spacing: 12)]
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            HomeStreakWidget(streak: streak, badges: badges, onTap: onBadges)
            HomeChallengeWidget(progress: challengeProgress, onTap: onChallenge)
            HomeTonightWidget(idea: featuredIdea, onTap: onTonight)
                .gridCellColumns(horizontalSizeClass == .regular ? 2 : 1)
            HomeJarWidget(count: jarCount, onTap: onJar)
                .gridCellColumns(horizontalSizeClass == .regular ? 2 : 1)
        }
    }
}

struct HomeStreakWidget: View {
    let streak: Int
    let badges: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "FF6B6B"), Color(hex: "FDCB6E")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(AppColor.textSecondary.opacity(0.5))
                }

                Text("\(streak)")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundColor(AppColor.textPrimary)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Week Streak")
                        .font(AppDesign.Typography.widgetTitle)
                        .foregroundColor(AppColor.textPrimary)
                    Text("\(badges) badges earned")
                        .font(AppDesign.Typography.widgetMeta)
                        .foregroundColor(AppColor.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(AppDesign.cardPadding)
            .frame(maxWidth: .infinity, minHeight: 148, alignment: .leading)
            .tintedCard(gradient: AppDesign.warmWidget, accent: Color(hex: "FF6B6B"), elevation: .raised)
        }
        .buttonStyle(.plain)
    }
}

struct HomeChallengeWidget: View {
    let progress: ChallengeProgress
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "trophy.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "6C5CE7"))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(AppColor.textSecondary.opacity(0.5))
                }

                ZStack {
                    Circle()
                        .stroke(Color(hex: "6C5CE7").opacity(0.15), lineWidth: 6)
                        .frame(width: 56, height: 56)
                    Circle()
                        .trim(from: 0, to: progress.isActive ? progress.progress : 0)
                        .stroke(Color(hex: "6C5CE7"), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 56, height: 56)
                        .rotationEffect(.degrees(-90))
                    Text(progress.isActive ? "\(progress.weeksCompleted)" : "—")
                        .font(.title3.weight(.bold))
                        .foregroundColor(AppColor.textPrimary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Challenge")
                        .font(AppDesign.Typography.widgetTitle)
                        .foregroundColor(AppColor.textPrimary)
                    Text(progress.isActive ? "\(progress.targetWeeks)-week goal" : "Start 30 days")
                        .font(AppDesign.Typography.widgetMeta)
                        .foregroundColor(AppColor.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(AppDesign.cardPadding)
            .frame(maxWidth: .infinity, minHeight: 148, alignment: .leading)
            .tintedCard(gradient: AppDesign.coolWidget, accent: Color(hex: "6C5CE7"), elevation: .raised)
        }
        .buttonStyle(.plain)
    }
}

struct HomeTonightWidget: View {
    let idea: Idea?
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 14) {
                Label("Tonight's Pick", systemImage: "moon.stars.fill")
                    .font(AppDesign.Typography.widgetTitle)
                    .foregroundColor(AppColor.accent)
                    .labelStyle(.titleAndIcon)

                if let idea {
                    Text(idea.title)
                        .font(.headline.weight(.bold))
                        .foregroundColor(AppColor.textPrimary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 10) {
                        Text(idea.category.icon)
                        Text(idea.budget.icon)
                        Text("\(idea.timeRequired) min")
                            .font(AppDesign.Typography.widgetMeta)
                            .foregroundColor(AppColor.textSecondary)
                    }
                    .font(.footnote)
                } else {
                    Text("Add ideas to get personalized picks")
                        .font(AppDesign.Typography.widgetBody)
                        .foregroundColor(AppColor.textSecondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Image("HomeDateNight")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous))

                Text(idea != nil ? "View details" : "Browse ideas")
                    .font(AppDesign.Typography.widgetMeta.weight(.semibold))
                    .foregroundColor(AppColor.accent)
            }
            .padding(AppDesign.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .premiumCard(accent: AppColor.accent.opacity(0.25), elevation: .floating)
        }
        .buttonStyle(.plain)
    }
}

struct HomeJarWidget: View {
    let count: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(AppColor.accentSecondary.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Text("🫙")
                        .font(.title2)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Date Jar")
                        .font(AppDesign.Typography.widgetTitle)
                        .foregroundColor(AppColor.textPrimary)
                    Text(count == 0 ? "Add secret ideas" : "\(count) secrets waiting")
                        .font(AppDesign.Typography.widgetMeta)
                        .foregroundColor(AppColor.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 8)

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(AppColor.textSecondary.opacity(0.5))
            }
            .padding(AppDesign.cardPadding)
            .frame(maxWidth: .infinity, minHeight: 76, alignment: .leading)
            .tintedCard(
                gradient: AppDesign.tintedGradient(AppColor.accentSecondary),
                accent: AppColor.accentSecondary,
                elevation: .raised
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Stats Bar

struct HomeStatsBarView: View {
    let total: Int
    let unused: Int
    let used: Int
    let favorites: Int
    let micro: Int

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            statItem(value: total, label: "Total", icon: "lightbulb.fill", color: AppColor.accent)
            statItem(value: unused, label: "Ready", icon: "sparkles", color: AppColor.accentSecondary)
            statItem(value: used, label: "Done", icon: "checkmark.circle.fill", color: AppColor.textSecondary)
            statItem(value: favorites, label: "Loved", icon: "heart.fill", color: .red)
            statItem(value: micro, label: "Micro", icon: "bolt.fill", color: Color(hex: "FDCB6E"))
        }
        .padding(12)
        .premiumCard(elevation: .raised)
    }

    private func statItem(value: Int, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.footnote)
                .foregroundColor(color)
            Text("\(value)")
                .font(AppDesign.Typography.statValue)
                .foregroundColor(AppColor.textPrimary)
            Text(label)
                .font(AppDesign.Typography.statLabel)
                .foregroundColor(AppColor.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                .fill(color.opacity(0.06))
        )
    }
}

// MARK: - Spin Section

struct HomeSpinSectionView: View {
    @Binding var isSpinning: Bool
    @Binding var selectedIdea: Idea?
    @Binding var wheelSource: WheelEngine.Source
    let onSpin: () -> Bool
    let onUse: (Idea) -> Void
    let onSkip: () -> Void
    let onDetail: (Idea) -> Void
    let onPlan: (Idea) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(title: "Spin the Wheel", subtitle: "Let fate pick your next date")

            WheelSourcePicker(selected: $wheelSource)

            ZStack {
                Image("HomeSpinWheel")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .opacity(0.14)

                WheelOfFortuneView(
                    isSpinning: $isSpinning,
                    selectedIdea: $selectedIdea,
                    onSpin: onSpin,
                    onUse: onUse,
                    onSkip: onSkip,
                    onDetail: onDetail,
                    onPlan: onPlan
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
                    .fill(AppDesign.spinSectionGradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
                    .stroke(AppColor.accent.opacity(0.12), lineWidth: 1)
            )
        }
    }
}

// MARK: - Category Carousel

struct HomeCategoryCarouselView: View {
    let categories: [Category]
    let onCategoryTap: (Category) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: "Browse Categories", subtitle: "Find the perfect vibe")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        HomeCategoryCard(category: category) {
                            onCategoryTap(category)
                        }
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 4)
            }
        }
    }
}

struct HomeCategoryCard: View {
    let category: Category
    let action: () -> Void

    private var color: Color { Color(hex: category.color) }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Text(category.icon)
                    .font(.system(size: 30))
                    .frame(width: 52, height: 52)
                    .background(color.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Text(category.rawValue)
                    .font(AppDesign.Typography.widgetTitle)
                    .foregroundColor(AppColor.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Text(categorySubtitle)
                    .font(AppDesign.Typography.widgetMeta)
                    .foregroundColor(AppColor.textSecondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .frame(width: 156, alignment: .topLeading)
            .tintedCard(gradient: AppDesign.tintedGradient(color), accent: color, elevation: .flat)
        }
        .buttonStyle(.plain)
    }

    private var categorySubtitle: String {
        switch category {
        case .romantic: return "Candlelit & sweet"
        case .active: return "Move together"
        case .cozy: return "Stay in comfort"
        case .adventure: return "Try something new"
        case .cultural: return "Museums & shows"
        case .gastronomic: return "Food adventures"
        case .spontaneous: return "No plan needed"
        case .relax: return "Unwind & recharge"
        }
    }
}
