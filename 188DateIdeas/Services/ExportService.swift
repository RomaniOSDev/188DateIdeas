import SwiftUI
import UIKit

final class ExportService {
    func renderDatePlanCard(idea: Idea, plan: DatePlan, preferences: CouplePreferences) -> UIImage? {
        let view = DatePlanExportView(idea: idea, plan: plan, preferences: preferences)
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}

private struct DatePlanExportView: View {
    let idea: Idea
    let plan: DatePlan
    let preferences: CouplePreferences

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Our Date Tonight")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColor.accent)

            Text(idea.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(AppColor.textPrimary)

            Text(idea.description)
                .font(.body)
                .foregroundColor(AppColor.textSecondary)

            HStack {
                CategoryTagView(category: idea.category)
                BudgetBadgeView(budget: idea.budget)
                TimeBadgeView(time: idea.timeRequired)
            }

            Divider()

            Text("Leave in \(plan.leaveInMinutes) minutes")
                .font(.headline)
                .foregroundColor(AppColor.accentSecondary)

            if !plan.whatToBring.isEmpty {
                Text("What to bring")
                    .font(.headline)
                ForEach(plan.whatToBring, id: \.self) { item in
                    Text("• \(item)")
                        .font(.subheadline)
                }
            }

            if !plan.checklist.isEmpty {
                Text("Checklist")
                    .font(.headline)
                ForEach(plan.checklist) { item in
                    Text(item.isCompleted ? "✅ \(item.title)" : "☐ \(item.title)")
                        .font(.subheadline)
                }
            }

            Spacer(minLength: 0)

            Text("\(preferences.partner1Name) & \(preferences.partner2Name)")
                .font(.caption)
                .foregroundColor(AppColor.textSecondary)
        }
        .padding(24)
        .frame(width: 360, height: 520)
        .background(AppColor.background)
    }
}
