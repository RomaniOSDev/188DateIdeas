import SwiftUI

struct IdeaDetailView: View {
    @ObservedObject var viewModel: IdeaDetailViewModel

    private var accent: Color { Color(hex: viewModel.idea.category.color) }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
                        .fill(AppDesign.heroGradient(accent))
                        .frame(height: 130)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
                                .stroke(accent.opacity(0.2), lineWidth: 1)
                        )

                    HStack {
                        IconCircle(emoji: viewModel.idea.category.icon, size: 56, tint: accent)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.idea.category.rawValue)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(accent)
                            Text(viewModel.idea.title)
                                .font(.title2.weight(.bold))
                                .foregroundColor(AppColor.textPrimary)
                        }
                        Spacer()
                        Button(action: viewModel.toggleFavorite) {
                            Image(systemName: viewModel.idea.isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(viewModel.idea.isFavorite ? .red : AppColor.textSecondary)
                                .padding(10)
                                .background(
                                    Circle()
                                        .fill(AppColor.background)
                                        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                                )
                        }
                    }
                    .padding(AppDesign.cardPadding)
                }
                .compositingGroup()
                .shadow(color: accent.opacity(0.15), radius: 10, y: 4)

                IdeaMetaRow(idea: viewModel.idea)

                if !viewModel.idea.seasonTags.isEmpty {
                    SeasonTagsRow(tags: viewModel.idea.seasonTags)
                }

                if viewModel.idea.isUsed {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(AppColor.accentSecondary)
                        Text("Completed")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(AppColor.accentSecondary)
                        if let date = viewModel.idea.usedDate {
                            Text("· \(date.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(AppColor.textSecondary)
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                            .fill(AppColor.accentSecondary.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                                    .stroke(AppColor.accentSecondary.opacity(0.2), lineWidth: 1)
                            )
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    SectionHeaderView(title: "About")
                    Text(viewModel.idea.description)
                        .font(.body)
                        .foregroundColor(AppColor.textSecondary)
                        .lineSpacing(4)
                }
                .padding(AppDesign.cardPadding)
                .premiumCard()

                VStack(spacing: 10) {
                    PrimaryButton(title: "Open Date Planner", icon: "📋", action: viewModel.goToPlanner)
                    if !viewModel.idea.isUsed {
                        PrimaryButton(title: "Mark as Used", icon: "✓", action: viewModel.markAsUsed)
                    }
                    SecondaryButton(title: "Edit Idea", action: viewModel.goToEdit)
                    GhostButton(title: "Delete Idea") {
                        viewModel.showDeleteAlert = true
                    }
                }
            }
            .padding(20)
        }
        .appScreenBackground()
        .appNavigationBar(title: "Details", onBack: viewModel.goBack)
        .alert("Delete Idea", isPresented: $viewModel.showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive, action: viewModel.deleteIdea)
        } message: {
            Text("Are you sure? This cannot be undone.")
        }
    }
}
