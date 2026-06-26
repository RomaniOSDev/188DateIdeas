import SwiftUI

struct ChallengeView: View {
    @ObservedObject var viewModel: ChallengeViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 14)
                        .frame(width: 180, height: 180)

                    Circle()
                        .trim(from: 0, to: viewModel.progress.progress)
                        .stroke(
                            AppDesign.accentGradient,
                            style: StrokeStyle(lineWidth: 14, lineCap: .round)
                        )
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 4) {
                        Text("\(viewModel.progress.weeksCompleted)")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundStyle(AppDesign.accentGradient)
                        Text("of \(viewModel.progress.targetWeeks) weeks")
                            .font(.caption.weight(.medium))
                            .foregroundColor(AppColor.textSecondary)
                    }
                }
                .padding(.top, 8)

                VStack(spacing: 8) {
                    Text("30-Day Challenge")
                        .font(.title2.weight(.bold))
                        .foregroundColor(AppColor.textPrimary)
                    Text("One unique date per week, explore different categories together.")
                        .font(.subheadline)
                        .foregroundColor(AppColor.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                if viewModel.progress.isActive {
                    HStack(spacing: 10) {
                        StatCell(
                            value: "\(viewModel.daysRemaining)",
                            label: "Days Left",
                            icon: "⏳",
                            color: AppColor.accentSecondary
                        )
                        StatCell(
                            value: "\(viewModel.progress.categoriesUsed.count)",
                            label: "Categories",
                            icon: "🗺️",
                            color: AppColor.accent
                        )
                    }

                    FormSectionCard(title: "Categories Explored") {
                        if viewModel.progress.categoriesUsed.isEmpty {
                            Text("Complete your first weekly date to start")
                                .font(.subheadline)
                                .foregroundColor(AppColor.textSecondary)
                        } else {
                            FlowLayout(tags: viewModel.progress.categoriesUsed.map { "\($0.icon) \($0.rawValue)" })
                        }
                    }

                    if viewModel.progress.isComplete {
                        HStack {
                            Text("🏆")
                                .font(.largeTitle)
                            Text("Challenge Complete!")
                                .font(.headline.weight(.bold))
                                .foregroundColor(AppColor.accent)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .premiumCard(accent: AppColor.accent)
                    }

                    GhostButton(title: "Reset Challenge", action: viewModel.resetChallenge)
                } else {
                    PrimaryButton(title: "Start Challenge", icon: "🏆", action: viewModel.startChallenge)
                }
            }
            .padding(20)
        }
        .appScreenBackground()
        .appNavigationBar(title: "Challenge", onBack: viewModel.goBack)
    }
}

struct FlowLayout: View {
    let tags: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption.weight(.medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(AppColor.accent.opacity(0.1))
                            .overlay(Capsule().stroke(AppColor.accent.opacity(0.18), lineWidth: 1))
                    )
                    .foregroundColor(AppColor.accent)
            }
        }
    }
}
