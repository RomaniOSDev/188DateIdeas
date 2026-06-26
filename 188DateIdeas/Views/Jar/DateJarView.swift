import SwiftUI

struct DateJarView: View {
    @ObservedObject var viewModel: DateJarViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                SectionHeaderView(
                    title: "Date Jar",
                    subtitle: "Secret ideas from both partners — revealed only when the wheel spins"
                )

                HStack(spacing: 12) {
                    PartnerJarCell(
                        name: viewModel.preferences.partner1Name,
                        count: viewModel.partner1Count,
                        isSelected: viewModel.selectedOwner == .partner1
                    ) { viewModel.selectedOwner = .partner1 }

                    PartnerJarCell(
                        name: viewModel.preferences.partner2Name,
                        count: viewModel.partner2Count,
                        isSelected: viewModel.selectedOwner == .partner2
                    ) { viewModel.selectedOwner = .partner2 }
                }

                FormSectionCard(title: "Add Secret Idea") {
                    VStack(spacing: 12) {
                        Text("Adding as \(viewModel.selectedOwner.displayName(preferences: viewModel.preferences))")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(AppColor.accent)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        FormTextField(placeholder: "Idea title", text: $viewModel.newTitle)
                        FormTextField(placeholder: "Short description", text: $viewModel.newDescription, axis: .vertical)
                            .lineLimit(2...4)

                        PrimaryButton(title: "Drop into Jar", icon: "🫙", action: viewModel.addSecretIdea)
                    }
                }

                SectionHeaderView(
                    title: "Your Secrets",
                    subtitle: "\(viewModel.myIdeas.count) idea\(viewModel.myIdeas.count == 1 ? "" : "s")"
                )

                if viewModel.myIdeas.isEmpty {
                    VStack(spacing: 12) {
                        Text("🫙")
                            .font(.system(size: 48))
                        Text("No secret ideas yet")
                            .font(.subheadline)
                            .foregroundColor(AppColor.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(32)
                    .premiumCard(elevation: .raised)
                } else {
                    ForEach(viewModel.myIdeas) { idea in
                        HStack(spacing: 12) {
                            IconCircle(emoji: "🤫", tint: AppColor.accentSecondary)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(idea.title)
                                    .font(.headline.weight(.semibold))
                                    .foregroundColor(AppColor.textPrimary)
                                Text(idea.description)
                                    .font(.caption)
                                    .foregroundColor(AppColor.textSecondary)
                                    .lineLimit(2)
                            }
                            Spacer()
                        }
                        .padding(AppDesign.cardPadding)
                        .premiumCard(accent: AppColor.accentSecondary.opacity(0.3), elevation: .flat)
                    }
                }
            }
            .padding(20)
        }
        .appScreenBackground()
        .appNavigationBar(title: "Date Jar", onBack: viewModel.goBack)
        .onAppear { viewModel.load() }
    }
}
