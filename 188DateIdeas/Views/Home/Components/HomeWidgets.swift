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
                .frame(height: 168)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.55), .black.opacity(0.15), .clear],
                startPoint: .bottom,
                endPoint: .top
            )

            VStack(alignment: .leading, spacing: 6) {
                Text(greeting)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white.opacity(0.85))
                    .textCase(.uppercase)
                    .tracking(0.6)

                Text(coupleNames)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.caption2.weight(.bold))
                    Text("\(readyCount) ideas ready to explore")
                        .font(.caption.weight(.medium))
                }
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.white.opacity(0.2))
                .clipShape(Capsule())
            }
            .padding(18)
        }
        .frame(height: 168)
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

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            HomeStreakWidget(streak: streak, badges: badges, onTap: onBadges)
            HomeChallengeWidget(progress: challengeProgress, onTap: onChallenge)
            HomeTonightWidget(idea: featuredIdea, onTap: onTonight)
                .gridCellColumns(2)
            HomeJarWidget(count: jarCount, onTap: onJar)
                .gridCellColumns(2)
        }
    }
}

struct HomeStreakWidget: View {
    let streak: Int
    let badges: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "flame.fill")
                        .font(.title3)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "FF6B6B"), Color(hex: "FDCB6E")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(AppColor.textSecondary.opacity(0.4))
                }

                Text("\(streak)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(AppColor.textPrimary)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Week Streak")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(AppColor.textPrimary)
                    Text("\(badges) badges earned")
                        .font(.caption2)
                        .foregroundColor(AppColor.textSecondary)
                }
            }
            .padding(AppDesign.cardPadding)
            .frame(maxWidth: .infinity, minHeight: 130, alignment: .leading)
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
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "trophy.fill")
                        .font(.title3)
                        .foregroundColor(Color(hex: "6C5CE7"))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(AppColor.textSecondary.opacity(0.4))
                }

                ZStack {
                    Circle()
                        .stroke(Color(hex: "6C5CE7").opacity(0.15), lineWidth: 6)
                        .frame(width: 52, height: 52)
                    Circle()
                        .trim(from: 0, to: progress.isActive ? progress.progress : 0)
                        .stroke(Color(hex: "6C5CE7"), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 52, height: 52)
                        .rotationEffect(.degrees(-90))
                    Text(progress.isActive ? "\(progress.weeksCompleted)" : "—")
                        .font(.headline.weight(.bold))
                        .foregroundColor(AppColor.textPrimary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Challenge")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(AppColor.textPrimary)
                    Text(progress.isActive ? "\(progress.targetWeeks)-week goal" : "Start 30 days")
                        .font(.caption2)
                        .foregroundColor(AppColor.textSecondary)
                }
            }
            .padding(AppDesign.cardPadding)
            .frame(maxWidth: .infinity, minHeight: 130, alignment: .leading)
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
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Tonight's Pick", systemImage: "moon.stars.fill")
                        .font(.caption.weight(.bold))
                        .foregroundColor(AppColor.accent)
                        .labelStyle(.titleAndIcon)

                    if let idea {
                        Text(idea.title)
                            .font(.headline.weight(.bold))
                            .foregroundColor(AppColor.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)

                        HStack(spacing: 8) {
                            Text(idea.category.icon)
                            Text(idea.budget.icon)
                            Text("\(idea.timeRequired) min")
                                .font(.caption2.weight(.medium))
                                .foregroundColor(AppColor.textSecondary)
                        }
                        .font(.caption)
                    } else {
                        Text("Add ideas to get personalized picks")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(AppColor.textSecondary)
                            .lineLimit(2)
                    }

                    Spacer(minLength: 0)

                    Text(idea != nil ? "View details" : "Browse ideas")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(AppColor.accent)
                }
                .padding(AppDesign.cardPadding)
                .frame(maxWidth: .infinity, alignment: .leading)

                Image("HomeDateNight")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 140)
                    .clipped()
            }
            .frame(height: 140)
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
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppColor.accentSecondary.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Text("🫙")
                        .font(.title2)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Date Jar")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(AppColor.textPrimary)
                    Text(count == 0 ? "Add secret ideas" : "\(count) secrets waiting")
                        .font(.caption)
                        .foregroundColor(AppColor.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(AppColor.textSecondary.opacity(0.4))
            }
            .padding(AppDesign.cardPadding)
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

    var body: some View {
        HStack(spacing: 0) {
            statItem(value: total, label: "Total", icon: "lightbulb.fill", color: AppColor.accent)
            divider
            statItem(value: unused, label: "Ready", icon: "sparkles", color: AppColor.accentSecondary)
            divider
            statItem(value: used, label: "Done", icon: "checkmark.circle.fill", color: AppColor.textSecondary)
            divider
            statItem(value: favorites, label: "Loved", icon: "heart.fill", color: .red)
            divider
            statItem(value: micro, label: "Micro", icon: "bolt.fill", color: Color(hex: "FDCB6E"))
        }
        .padding(.vertical, 14)
        .premiumCard(elevation: .raised)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.black.opacity(0.06))
            .frame(width: 1, height: 36)
    }

    private func statItem(value: Int, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(color)
            Text("\(value)")
                .font(.subheadline.weight(.bold))
                .foregroundColor(AppColor.textPrimary)
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(AppColor.textSecondary)
        }
        .frame(maxWidth: .infinity)
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
                    .font(.system(size: 28))
                    .frame(width: 48, height: 48)
                    .background(color.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Text(category.rawValue)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(AppColor.textPrimary)

                Text(categorySubtitle)
                    .font(.caption2)
                    .foregroundColor(AppColor.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(14)
            .frame(width: 130, height: 140, alignment: .topLeading)
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
