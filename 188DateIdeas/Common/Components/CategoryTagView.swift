import SwiftUI

struct CategoryTagView: View {
    let category: Category

    var body: some View {
        Text("\(category.icon) \(category.rawValue)")
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Color(hex: category.color).opacity(0.14))
                    .overlay(Capsule().stroke(Color(hex: category.color).opacity(0.2), lineWidth: 1))
            )
            .foregroundColor(Color(hex: category.color))
    }
}
