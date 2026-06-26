import SwiftUI
import PhotosUI

struct JournalEntryView: View {
    @ObservedObject var viewModel: JournalEntryViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        IconCircle(emoji: "📔", tint: AppColor.accent)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.entry.ideaTitle)
                                .font(.title3.weight(.bold))
                                .foregroundColor(AppColor.textPrimary)
                            Text(viewModel.entry.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(AppColor.textSecondary)
                        }
                    }
                }
                .padding(AppDesign.cardPadding)
                .premiumCard(elevation: .raised)

                FormSectionCard(title: "Rating") {
                    StarRatingView(rating: viewModel.rating) { viewModel.rating = $0 }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }

                FormSectionCard(title: "Reflection") {
                    FormTextField(
                        placeholder: "What did you enjoy most? Any special moments?",
                        text: $viewModel.reflection,
                        axis: .vertical
                    )
                    .lineLimit(4...8)
                }

                FormSectionCard(title: "Would you do it again?") {
                    HStack(spacing: 12) {
                        repeatButton(title: "Yes ❤️", selected: viewModel.wouldRepeat) {
                            viewModel.wouldRepeat = true
                        }
                        repeatButton(title: "Maybe not", selected: !viewModel.wouldRepeat) {
                            viewModel.wouldRepeat = false
                        }
                    }
                }

                FormSectionCard(title: "Photos") {
                    if viewModel.loadedImages.isEmpty {
                        Text("Add photos to remember this date")
                            .font(.caption)
                            .foregroundColor(AppColor.textSecondary)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(Array(viewModel.loadedImages.enumerated()), id: \.offset) { _, image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 88, height: 88)
                                        .clipShape(RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                }
                            }
                        }
                    }

                    PhotosPicker(selection: $viewModel.selectedPhotoItem, matching: .images) {
                        HStack {
                            Image(systemName: "photo.badge.plus")
                            Text("Add Photo")
                                .font(.subheadline.weight(.semibold))
                        }
                        .foregroundColor(AppColor.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppColor.accent.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous))
                    }
                    .onChange(of: viewModel.selectedPhotoItem) { _, _ in
                        Task { await viewModel.addPhoto() }
                    }
                }

                PrimaryButton(title: "Save Journal", icon: "✓", action: viewModel.save)
            }
            .padding(20)
        }
        .appScreenBackground()
        .appNavigationBar(title: "Journal Entry", onBack: viewModel.goBack)
    }

    private func repeatButton(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(selected ? AnyShapeStyle(AppDesign.accentGradient) : AnyShapeStyle(Color(.systemGray6)))
                .foregroundColor(selected ? .white : AppColor.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
