import SwiftUI

struct SeasonTagView: View {
    let tag: SeasonTag

    var body: some View {
        Text("\(tag.icon) \(tag.label)")
            .font(.caption2.weight(.medium))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(AppColor.accentSecondary.opacity(0.1))
            .foregroundColor(AppColor.accentSecondary)
            .clipShape(Capsule())
    }
}

struct SeasonTagsRow: View {
    let tags: [SeasonTag]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(tags, id: \.self) { tag in
                    SeasonTagView(tag: tag)
                }
            }
        }
    }
}
