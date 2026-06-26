import SwiftUI

enum CardElevation {
  /// Lists & scroll rows — border + sheen, no shadow (GPU-friendly).
  case flat
  /// Standalone cards, forms, widgets.
  case raised
  /// Hero banners and featured blocks.
  case floating
}

enum AppDesign {
    static let cornerRadius: CGFloat = 16
    static let smallRadius: CGFloat = 12
    static let chipRadius: CGFloat = 20
    static let cardPadding: CGFloat = 16

    static let accentGradient = LinearGradient(
        colors: [AppColor.accent, AppColor.accentSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let softBackgroundGradient = LinearGradient(
        colors: [Color(hex: "E3F4FD"), Color(hex: "F3FAFF"), AppColor.background],
        startPoint: .top,
        endPoint: .bottom
    )

    static let cardSheen = LinearGradient(
        colors: [Color.white.opacity(0.5), Color.clear],
        startPoint: .top,
        endPoint: .center
    )

    static let warmWidget = LinearGradient(
        colors: [Color(hex: "FFF5F5"), AppColor.background],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let coolWidget = LinearGradient(
        colors: [Color(hex: "F3F0FF"), AppColor.background],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let spinSectionGradient = LinearGradient(
        colors: [AppColor.accent.opacity(0.07), AppColor.background],
        startPoint: .top,
        endPoint: .bottom
    )

    static func tintedGradient(_ color: Color) -> LinearGradient {
        LinearGradient(
            colors: [color.opacity(0.11), AppColor.background],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func heroGradient(_ color: Color) -> LinearGradient {
        LinearGradient(
            colors: [color.opacity(0.24), color.opacity(0.09), AppColor.background.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
