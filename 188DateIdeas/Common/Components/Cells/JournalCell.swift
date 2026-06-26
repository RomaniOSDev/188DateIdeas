import SwiftUI

struct JournalCell: View {
    let entry: HistoryEntry
    let photo: UIImage?
    let onTap: () -> Void
    let onRating: (Int) -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 14) {
                if let photo {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous))
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                            .fill(AppColor.accent.opacity(0.1))
                            .frame(width: 64, height: 64)
                        Text("📔")
                            .font(.title2)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(entry.ideaTitle)
                            .font(.headline.weight(.semibold))
                            .foregroundColor(AppColor.textPrimary)
                            .lineLimit(1)
                        Spacer()
                        if !entry.photoFileNames.isEmpty {
                            Label("\(entry.photoFileNames.count)", systemImage: "photo")
                                .font(.caption2)
                                .foregroundColor(AppColor.accentSecondary)
                        }
                    }

                    Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(AppColor.textSecondary)

                    if let reflection = entry.reflection, !reflection.isEmpty {
                        Text(reflection)
                            .font(.subheadline)
                            .foregroundColor(AppColor.textSecondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    HStack {
                        StarRatingView(rating: entry.rating ?? 0, onRatingChanged: onRating)
                        Spacer()
                        if let repeatFlag = entry.wouldRepeat {
                            Text(repeatFlag ? "Repeat ❤️" : "Skip next time")
                                .font(.caption2.weight(.medium))
                                .foregroundColor(repeatFlag ? .red.opacity(0.8) : AppColor.textSecondary)
                        }
                    }
                }
            }
            .padding(AppDesign.cardPadding)
            .premiumCard(elevation: .flat)
        }
        .buttonStyle(.plain)
    }
}
