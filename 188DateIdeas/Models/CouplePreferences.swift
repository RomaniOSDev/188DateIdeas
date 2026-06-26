import Foundation

struct CouplePreferences: Codable, Hashable {
    var preferredBudget: Budget
    var preferredSetting: DateSetting
    var activityLevel: ActivityLevel
    var preferredSeasonTag: SeasonTag?
    var prefersMicroDates: Bool
    var partner1Name: String
    var partner2Name: String
    var hasCompletedOnboarding: Bool

    static let `default` = CouplePreferences(
        preferredBudget: .medium,
        preferredSetting: .both,
        activityLevel: .moderate,
        preferredSeasonTag: nil,
        prefersMicroDates: false,
        partner1Name: "Partner 1",
        partner2Name: "Partner 2",
        hasCompletedOnboarding: false
    )
}
