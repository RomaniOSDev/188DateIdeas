import SwiftUI

struct FormSectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundColor(AppColor.textSecondary)
                .textCase(.uppercase)

            content
        }
        .padding(AppDesign.cardPadding)
        .premiumCard(elevation: .raised)
    }
}

struct FormTextField: View {
    let placeholder: String
    @Binding var text: String
    var axis: Axis = .horizontal

    var body: some View {
        TextField(placeholder, text: $text, axis: axis)
            .insetField()
            .autocorrectionDisabled()
    }
}

struct IdeaFormView: View {
    @ObservedObject var viewModel: IdeaFormViewModel
    @FocusState private var focusedField: Field?

    enum Field { case title, description }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                FormSectionCard(title: "Basic Information") {
                    VStack(spacing: 12) {
                        FormTextField(placeholder: "Idea title", text: $viewModel.title)
                            .focused($focusedField, equals: .title)
                        FormTextField(placeholder: "Description", text: $viewModel.description, axis: .vertical)
                            .focused($focusedField, equals: .description)
                            .lineLimit(3...6)
                    }
                }

                FormSectionCard(title: "Details") {
                    VStack(spacing: 14) {
                        pickerRow("Category", selection: $viewModel.selectedCategory) {
                            ForEach(Category.allCases, id: \.self) { c in
                                Text("\(c.icon) \(c.rawValue)").tag(c)
                            }
                        }
                        pickerRow("Budget", selection: $viewModel.selectedBudget) {
                            ForEach(Budget.allCases, id: \.self) { b in
                                Text(b.rawValue).tag(b)
                            }
                        }
                        pickerRow("Setting", selection: $viewModel.selectedSetting) {
                            ForEach(DateSetting.allCases, id: \.self) { s in
                                Text(s.label).tag(s)
                            }
                        }
                        pickerRow("Activity", selection: $viewModel.selectedActivity) {
                            ForEach(ActivityLevel.allCases, id: \.self) { a in
                                Text(a.label).tag(a)
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Duration: \(viewModel.timeRequired) min")
                                    .font(.subheadline.weight(.medium))
                                if viewModel.timeRequired <= 30 {
                                    MetaPill(text: "⚡ Micro-date", color: Color(hex: "FDCB6E"))
                                }
                            }
                            Slider(
                                value: Binding(
                                    get: { Double(viewModel.timeRequired) },
                                    set: { viewModel.timeRequired = Int($0) }
                                ),
                                in: 15...180,
                                step: 15
                            )
                            .tint(AppColor.accent)
                        }

                        Toggle("Add to favorites", isOn: $viewModel.isFavorite)
                            .tint(AppColor.accent)
                    }
                }

                FormSectionCard(title: "Season & Weather") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(SeasonTag.allCases, id: \.self) { tag in
                            Button { viewModel.toggleSeasonTag(tag) } label: {
                                Text("\(tag.icon) \(tag.label)")
                                    .font(.caption.weight(.medium))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        viewModel.selectedSeasonTags.contains(tag)
                                            ? AnyShapeStyle(AppDesign.accentGradient)
                                            : AnyShapeStyle(Color(.systemGray6))
                                    )
                                    .foregroundColor(viewModel.selectedSeasonTags.contains(tag) ? .white : AppColor.textPrimary)
                                    .clipShape(RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous))
                            }
                        }
                    }
                }

                FormSectionCard(title: "Date Jar") {
                    VStack(spacing: 12) {
                        Toggle("Add to Date Jar", isOn: $viewModel.addToJar).tint(AppColor.accent)
                        if viewModel.addToJar {
                            Picker("Added by", selection: $viewModel.jarOwner) {
                                Text("Partner 1").tag(JarOwner.partner1)
                                Text("Partner 2").tag(JarOwner.partner2)
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                }

                PrimaryButton(
                    title: viewModel.isEditing ? "Save Changes" : "Add Idea",
                    icon: "✓",
                    isEnabled: viewModel.isFormValid,
                    action: viewModel.saveIdea
                )
            }
            .padding(20)
        }
        .appScreenBackground()
        .appNavigationBar(title: viewModel.isEditing ? "Edit Idea" : "New Idea", onBack: viewModel.cancel)
    }

    private func pickerRow<Selection: Hashable, Content: View>(
        _ label: String,
        selection: Binding<Selection>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColor.textSecondary)
            Picker(label, selection: selection, content: content)
                .pickerStyle(.menu)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6).opacity(0.55))
                .clipShape(RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous))
        }
    }
}
