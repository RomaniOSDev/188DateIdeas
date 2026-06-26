import SwiftUI

struct BudgetBadgeView: View {
    let budget: Budget

    var body: some View {
        Text(budget.icon)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
    }
}

struct TimeBadgeView: View {
    let time: Int

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "clock")
                .font(.caption2)
            Text("\(time)m")
                .font(.caption.weight(.semibold))
        }
        .foregroundColor(AppColor.textSecondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color(.systemGray6))
        .clipShape(Capsule())
    }
}
