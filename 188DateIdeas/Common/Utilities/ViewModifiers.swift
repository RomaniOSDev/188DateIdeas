import SwiftUI

// MARK: - Card Surfaces

struct PremiumCardModifier: ViewModifier {
    var accent: Color = .clear
    var elevation: CardElevation = .raised

    func body(content: Content) -> some View {
        content
            .background(cardBackground)
            .overlay(cardBorder)
            .modifier(CardShadowModifier(elevation: elevation))
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
            .fill(AppColor.background)
            .overlay(
                RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
                    .fill(AppDesign.cardSheen)
            )
    }

    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
            .stroke(
                accent == .clear ? Color.black.opacity(0.05) : accent.opacity(0.28),
                lineWidth: accent == .clear ? 1 : 1.5
            )
    }
}

struct TintedCardModifier: ViewModifier {
    let gradient: LinearGradient
    var accent: Color
    var elevation: CardElevation = .raised

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
                    .fill(gradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
                    .stroke(accent.opacity(0.22), lineWidth: 1)
            )
            .modifier(CardShadowModifier(elevation: elevation))
    }
}

struct CardShadowModifier: ViewModifier {
    let elevation: CardElevation

    func body(content: Content) -> some View {
        switch elevation {
        case .flat:
            content
        case .raised:
            content
                .compositingGroup()
                .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 3)
        case .floating:
            content
                .compositingGroup()
                .shadow(color: .black.opacity(0.11), radius: 14, x: 0, y: 6)
        }
    }
}

struct GradientBannerModifier: ViewModifier {
    var gradient: LinearGradient = AppDesign.accentGradient
    var glowColor: Color = AppColor.accent

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
                    .fill(gradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous)
                            .fill(AppDesign.cardSheen.opacity(0.35))
                    )
            )
            .compositingGroup()
            .shadow(color: glowColor.opacity(0.28), radius: 10, x: 0, y: 5)
    }
}

struct InsetFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                    .fill(Color(.systemGray6).opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                            .fill(AppDesign.cardSheen.opacity(0.4))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppDesign.smallRadius, style: .continuous)
                            .stroke(Color.black.opacity(0.05), lineWidth: 1)
                    )
            )
    }
}

struct ScreenBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            AppDesign.softBackgroundGradient.ignoresSafeArea()

            Circle()
                .fill(AppColor.accent.opacity(0.055))
                .frame(width: 300, height: 300)
                .offset(x: 120, y: -220)

            Circle()
                .fill(AppColor.accentSecondary.opacity(0.04))
                .frame(width: 220, height: 220)
                .offset(x: -130, y: -80)

            content
        }
    }
}

// MARK: - View Extensions

extension View {
    func premiumCard(accent: Color = .clear, elevation: CardElevation = .raised) -> some View {
        modifier(PremiumCardModifier(accent: accent, elevation: elevation))
    }

    func tintedCard(
        gradient: LinearGradient,
        accent: Color,
        elevation: CardElevation = .raised
    ) -> some View {
        modifier(TintedCardModifier(gradient: gradient, accent: accent, elevation: elevation))
    }

    func gradientBanner(
        gradient: LinearGradient = AppDesign.accentGradient,
        glowColor: Color = AppColor.accent
    ) -> some View {
        modifier(GradientBannerModifier(gradient: gradient, glowColor: glowColor))
    }

    func insetField() -> some View {
        modifier(InsetFieldModifier())
    }

    func cardStyle() -> some View {
        premiumCard()
    }

    func appScreenBackground() -> some View {
        modifier(ScreenBackgroundModifier())
    }

    func appNavigationBar(title: String, onBack: (() -> Void)? = nil) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(onBack != nil)
            .toolbar {
                if let onBack {
                    ToolbarItem(placement: .topBarLeading) {
                        AppBackButton(action: onBack)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.headline.weight(.semibold))
                        .foregroundColor(AppColor.textPrimary)
                }
            }
    }
}
