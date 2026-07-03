import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                HomeHeroBannerView(
                    greeting: viewModel.greeting,
                    coupleNames: viewModel.coupleNames,
                    readyCount: viewModel.unusedIdeasCount
                )

                HomeWidgetGridView(
                    streak: viewModel.streakState.currentWeeklyStreak,
                    badges: viewModel.streakState.earnedBadges.count,
                    challengeProgress: viewModel.challengeProgress,
                    featuredIdea: viewModel.featuredIdea,
                    jarCount: viewModel.jarIdeasCount,
                    onBadges: viewModel.goToBadges,
                    onChallenge: viewModel.goToChallenge,
                    onTonight: viewModel.goToTonightPick,
                    onJar: viewModel.goToDateJar
                )

                HomeStatsBarView(
                    total: viewModel.allIdeasCount,
                    unused: viewModel.unusedIdeasCount,
                    used: viewModel.usedIdeasCount,
                    favorites: viewModel.favoritesCount,
                    micro: viewModel.microDatesCount
                )

                HomeSpinSectionView(
                    isSpinning: $viewModel.isWheelSpinning,
                    selectedIdea: $viewModel.selectedIdea,
                    wheelSource: $viewModel.wheelSource,
                    onSpin: viewModel.spinWheel,
                    onUse: viewModel.markIdeaAsUsed,
                    onSkip: viewModel.skipIdea,
                    onDetail: viewModel.goToIdeaDetail,
                    onPlan: viewModel.openPlanner
                )

                QuickActionsView(
                    onFavorites: { viewModel.goToIdeaList(showFavorites: true) },
                    onPersonalized: { viewModel.goToIdeaList(personalized: true) },
                    onMicro: { viewModel.goToIdeaList(microOnly: true) },
                    onJar: viewModel.goToDateJar,
                    onChallenge: viewModel.goToChallenge,
                    onHistory: viewModel.goToHistory,
                    onAdd: viewModel.goToIdeaForm
                )

                SeasonFilterRow { tag in
                    viewModel.goToIdeaList(seasonTag: tag)
                }

                HomeCategoryCarouselView(
                    categories: Category.allCases,
                    onCategoryTap: { viewModel.goToIdeaList(category: $0) }
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .appScreenBackground()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Home")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(AppColor.accent)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.goToSettings()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(AppColor.accent)
                        .padding(8)
                        .background(AppColor.accent.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
        .onAppear { viewModel.reload() }
        .alert("Cannot Spin", isPresented: Binding(
            get: { viewModel.alertMessage != nil },
            set: { if !$0 { viewModel.alertMessage = nil } }
        )) {
            Button("OK", role: .cancel) { viewModel.alertMessage = nil }
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
    }
}

struct WheelSourcePicker: View {
    @Binding var selected: WheelEngine.Source

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                PillChipView(title: "All Ideas", isSelected: selected == .all) { selected = .all }
                PillChipView(title: "🫙 Date Jar", isSelected: selected == .jarOnly) { selected = .jarOnly }
                PillChipView(title: "⚡ Micro", isSelected: selected == .microOnly) { selected = .microOnly }
                PillChipView(title: "✨ For You", isSelected: selected == .personalized) { selected = .personalized }
            }
        }
    }
}

struct SeasonFilterRow: View {
    let onTagTap: (SeasonTag) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: "Season & Weather", subtitle: "Filter by mood and conditions")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(SeasonTag.allCases, id: \.self) { tag in
                        Button { onTagTap(tag) } label: {
                            Text("\(tag.icon) \(tag.label)")
                                .font(.footnote.weight(.medium))
                                .lineLimit(1)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(AppColor.accentSecondary.opacity(0.1))
                                .foregroundColor(AppColor.accentSecondary)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
    }
}
