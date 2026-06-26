import SwiftUI

struct IntroOnboardingView: View {
    @ObservedObject var viewModel: IntroOnboardingViewModel

    private let pages: [IntroPage] = [
        IntroPage(
            imageName: "HomeHero",
            icon: "💑",
            title: "Date Nights Made Easy",
            subtitle: "Your shared space for discovering ideas, planning evenings together, and building memories as a couple."
        ),
        IntroPage(
            imageName: "HomeSpinWheel",
            icon: "🎡",
            title: "Let Fate Decide",
            subtitle: "Spin the wheel for a surprise, filter by mood and season, or reveal a secret from the Date Jar."
        ),
        IntroPage(
            imageName: "HomeDateNight",
            icon: "📔",
            title: "Plan & Remember",
            subtitle: "Build checklists, export your plan, and capture every date in your couple journal."
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            headerBar

            TabView(selection: $viewModel.page) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    IntroPageView(
                        page: page,
                        showsNames: index == viewModel.totalPages - 1,
                        partner1Name: $viewModel.partner1Name,
                        partner2Name: $viewModel.partner2Name
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: viewModel.page)

            bottomBar
        }
        .appScreenBackground()
    }

    private var headerBar: some View {
        HStack {
            if viewModel.page > 0 {
                Button(action: viewModel.back) {
                    Image(systemName: "chevron.left")
                        .font(.body.weight(.semibold))
                        .foregroundColor(AppColor.accent)
                        .padding(10)
                        .background(AppColor.accent.opacity(0.1))
                        .clipShape(Circle())
                }
            } else {
                Color.clear.frame(width: 38, height: 38)
            }

            Spacer()

            HStack(spacing: 6) {
                ForEach(0..<viewModel.totalPages, id: \.self) { index in
                    Capsule()
                        .fill(index == viewModel.page ? AnyShapeStyle(AppDesign.accentGradient) : AnyShapeStyle(Color(.systemGray4)))
                        .frame(width: index == viewModel.page ? 22 : 8, height: 8)
                        .animation(.easeInOut(duration: 0.25), value: viewModel.page)
                }
            }

            Spacer()

            if viewModel.page < viewModel.totalPages - 1 {
                Button("Skip", action: viewModel.skip)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(AppColor.textSecondary)
            } else {
                Color.clear.frame(width: 38, height: 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private var bottomBar: some View {
        PrimaryButton(
            title: viewModel.page == viewModel.totalPages - 1 ? "Get Started" : "Continue",
            icon: viewModel.page == viewModel.totalPages - 1 ? "✨" : nil,
            action: viewModel.next
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
        .padding(.top, 8)
    }
}

// MARK: - Page Model

private struct IntroPage {
    let imageName: String
    let icon: String
    let title: String
    let subtitle: String
}

// MARK: - Page View

private struct IntroPageView: View {
    let page: IntroPage
    let showsNames: Bool
    @Binding var partner1Name: String
    @Binding var partner2Name: String

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                ZStack(alignment: .bottomLeading) {
                    Image(page.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipped()

                    LinearGradient(
                        colors: [.clear, .black.opacity(0.35)],
                        startPoint: .center,
                        endPoint: .bottom
                    )

                    HStack(spacing: 10) {
                        Text(page.icon)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                            .background(.white.opacity(0.9))
                            .clipShape(Circle())
                        Text(page.title)
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                    }
                    .padding(16)
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous))
                .compositingGroup()
                .shadow(color: AppColor.accent.opacity(0.2), radius: 12, y: 5)

                VStack(spacing: 10) {
                    Text(page.title)
                        .font(.title2.weight(.bold))
                        .foregroundColor(AppColor.textPrimary)
                        .multilineTextAlignment(.center)

                    Text(page.subtitle)
                        .font(.body)
                        .foregroundColor(AppColor.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 8)
                }

                if showsNames {
                    namesSection
                }

                featureHighlights(for: page.icon)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }

    private var namesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Who's planning together?")
                .font(.subheadline.weight(.bold))
                .foregroundColor(AppColor.textPrimary)

            VStack(spacing: 12) {
                nameField(label: "Partner 1", text: $partner1Name)
                nameField(label: "Partner 2", text: $partner2Name)
            }
        }
        .padding(AppDesign.cardPadding)
        .premiumCard(accent: AppColor.accent.opacity(0.2), elevation: .raised)
    }

    private func nameField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColor.textSecondary)
            TextField("Name", text: text)
                .insetField()
        }
    }

    @ViewBuilder
    private func featureHighlights(for icon: String) -> some View {
        let items = highlights(for: icon)
        if !items.isEmpty {
            VStack(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppColor.accent)
                        Text(item)
                            .font(.subheadline)
                            .foregroundColor(AppColor.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                            .fill(AppColor.accent.opacity(0.06))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                                    .stroke(AppColor.accent.opacity(0.1), lineWidth: 1)
                            )
                    )
                }
            }
        }
    }

    private func highlights(for icon: String) -> [String] {
        switch icon {
        case "💑":
            return ["Browse 8 date categories", "Track streaks and earn badges", "Personalized picks for you"]
        case "🎡":
            return ["Fortune wheel with filters", "Secret Date Jar for surprises", "Micro-dates under 30 minutes"]
        case "📔":
            return ["Date planner with checklist", "Export plan as an image", "Journal with photos and ratings"]
        default:
            return []
        }
    }
}
