import SwiftUI

struct BadgesView: View {
    @ObservedObject var viewModel: BadgesViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                StreakBannerCell(
                    streak: viewModel.streakState.currentWeeklyStreak,
                    badges: viewModel.streakState.earnedBadges.count,
                    onTap: {}
                )

                HStack(spacing: 10) {
                    StatCell(
                        value: "\(viewModel.streakState.totalDatesCompleted)",
                        label: "Dates Done",
                        icon: "💑",
                        color: AppColor.accent
                    )
                    StatCell(
                        value: "\(viewModel.streakState.longestStreak)",
                        label: "Best Streak",
                        icon: "⭐",
                        color: AppColor.accentSecondary
                    )
                }

                SectionHeaderView(
                    title: "Achievements",
                    subtitle: "\(viewModel.streakState.earnedBadges.count) of \(viewModel.allBadges.count) unlocked"
                )

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.allBadges) { badge in
                        BadgeCell(badge: badge, isEarned: viewModel.isEarned(badge))
                    }
                }
            }
            .padding(20)
        }
        .appScreenBackground()
        .appNavigationBar(title: "Streaks & Badges", onBack: viewModel.goBack)
        .onAppear { viewModel.reload() }
    }
}
