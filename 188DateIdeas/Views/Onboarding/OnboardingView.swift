import SwiftUI

struct PreferencesQuizView: View {
    @ObservedObject var viewModel: PreferencesQuizViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                HStack {
                    ForEach(0..<viewModel.totalSteps, id: \.self) { step in
                        Capsule()
                            .fill(step <= viewModel.step ? AnyShapeStyle(AppDesign.accentGradient) : AnyShapeStyle(Color(.systemGray5)))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Text("Step \(viewModel.step + 1) of \(viewModel.totalSteps)")
                    .font(.caption.weight(.medium))
                    .foregroundColor(AppColor.textSecondary)
            }

            VStack(spacing: 8) {
                Text(viewModel.stepTitle)
                    .font(.title2.weight(.bold))
                    .foregroundColor(AppColor.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                Text(stepSubtitle)
                    .font(.subheadline)
                    .foregroundColor(AppColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            ScrollView {
                Group {
                    switch viewModel.step {
                    case 0: budgetStep
                    case 1: settingStep
                    case 2: activityStep
                    case 3: seasonStep
                    case 4: namesStep
                    default: EmptyView()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }

            HStack(spacing: 12) {
                if viewModel.step > 0 {
                    SecondaryButton(title: "Back", action: viewModel.back)
                        .frame(width: 100)
                }
                PrimaryButton(
                    title: viewModel.step == viewModel.totalSteps - 1 ? "Get Started" : "Continue",
                    action: viewModel.next
                )
            }
            .padding(20)
        }
        .appScreenBackground()
    }

    private var stepSubtitle: String {
        switch viewModel.step {
        case 0: return "We'll suggest ideas that match your spending comfort"
        case 1: return "Home dates, outdoor adventures, or both"
        case 2: return "How much energy do you usually have?"
        case 3: return "Pick a vibe — or skip for any season"
        case 4: return "Used on shared plans and the Date Jar"
        default: return ""
        }
    }

    private var budgetStep: some View {
        VStack(spacing: 10) {
            ForEach(Budget.allCases, id: \.self) { budget in
                SelectOptionCell(
                    title: budget.rawValue,
                    icon: budget.icon,
                    isSelected: viewModel.preferredBudget == budget
                ) { viewModel.preferredBudget = budget }
            }
        }
    }

    private var settingStep: some View {
        VStack(spacing: 10) {
            ForEach(DateSetting.allCases, id: \.self) { setting in
                SelectOptionCell(
                    title: setting.label,
                    icon: setting == .indoor ? "🏠" : setting == .outdoor ? "🌳" : "🌍",
                    isSelected: viewModel.preferredSetting == setting
                ) { viewModel.preferredSetting = setting }
            }
        }
    }

    private var activityStep: some View {
        VStack(spacing: 10) {
            ForEach(ActivityLevel.allCases, id: \.self) { level in
                SelectOptionCell(
                    title: level.label,
                    isSelected: viewModel.activityLevel == level
                ) { viewModel.activityLevel = level }
            }
            SelectOptionCell(
                title: "Prefer micro-dates",
                subtitle: "Quick dates under 30 minutes",
                icon: "⚡",
                isSelected: viewModel.prefersMicroDates
            ) { viewModel.prefersMicroDates.toggle() }
        }
    }

    private var seasonStep: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            SelectOptionCell(title: "Any season", icon: "🌍", isSelected: viewModel.preferredSeasonTag == nil) {
                viewModel.preferredSeasonTag = nil
            }
            ForEach(SeasonTag.allCases, id: \.self) { tag in
                SelectOptionCell(
                    title: tag.label,
                    icon: tag.icon,
                    isSelected: viewModel.preferredSeasonTag == tag
                ) { viewModel.preferredSeasonTag = tag }
            }
        }
    }

    private var namesStep: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Partner 1")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(AppColor.textSecondary)
                TextField("Name", text: $viewModel.partner1Name)
                    .insetField()
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Partner 2")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(AppColor.textSecondary)
                TextField("Name", text: $viewModel.partner2Name)
                    .insetField()
            }
        }
        .padding(.top, 8)
    }
}
