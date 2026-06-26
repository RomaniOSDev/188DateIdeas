import SwiftUI

struct DatePlannerView: View {
    @ObservedObject var viewModel: DatePlannerViewModel

    private var accent: Color { Color(hex: viewModel.idea.category.color) }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 14) {
                    IconCircle(emoji: viewModel.idea.category.icon, size: 52, tint: accent)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.idea.title)
                            .font(.title3.weight(.bold))
                            .foregroundColor(AppColor.textPrimary)
                        IdeaMetaRow(idea: viewModel.idea)
                    }
                }
                .padding(AppDesign.cardPadding)
                .premiumCard(accent: accent.opacity(0.3), elevation: .raised)

                FormSectionCard(title: "Departure Time") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(AppColor.accent)
                            Text("Leave in \(viewModel.plan.leaveInMinutes) minutes")
                                .font(.headline.weight(.semibold))
                        }
                        Slider(
                            value: Binding(
                                get: { Double(viewModel.plan.leaveInMinutes) },
                                set: {
                                    viewModel.plan.leaveInMinutes = Int($0)
                                    viewModel.save()
                                }
                            ),
                            in: 5...120,
                            step: 5
                        )
                        .tint(AppColor.accent)
                    }
                }

                FormSectionCard(title: "What to Bring") {
                    VStack(spacing: 8) {
                        ForEach(viewModel.plan.whatToBring, id: \.self) { item in
                            BringItemCell(title: item)
                        }
                        HStack(spacing: 8) {
                            FormTextField(placeholder: "Add item...", text: $viewModel.newBringItem)
                            Button("Add") { viewModel.addBringItem() }
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(AppColor.accent)
                        }
                    }
                }

                FormSectionCard(title: "Checklist") {
                    VStack(spacing: 6) {
                        ForEach(viewModel.plan.checklist) { item in
                            ChecklistCell(item: item) {
                                viewModel.toggleChecklist(item)
                            }
                        }
                        HStack(spacing: 8) {
                            FormTextField(placeholder: "Add task...", text: $viewModel.newChecklistItem)
                            Button("Add") { viewModel.addChecklistItem() }
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(AppColor.accent)
                        }
                    }
                }

                PrimaryButton(title: "Export Date Plan", icon: "📤", action: viewModel.exportPlan)
            }
            .padding(20)
        }
        .appScreenBackground()
        .appNavigationBar(title: "Date Planner", onBack: viewModel.goBack)
        .sheet(isPresented: $viewModel.showShareSheet) {
            if let image = viewModel.shareImage {
                ShareSheet(items: [image])
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
