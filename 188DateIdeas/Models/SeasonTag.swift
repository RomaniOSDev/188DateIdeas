import Foundation

enum SeasonTag: String, CaseIterable, Codable, Hashable {
    case indoor
    case outdoor
    case summer
    case winter
    case spring
    case fall
    case rainyDay

    var label: String {
        switch self {
        case .indoor: return "Indoor"
        case .outdoor: return "Outdoor"
        case .summer: return "Summer"
        case .winter: return "Winter"
        case .spring: return "Spring"
        case .fall: return "Fall"
        case .rainyDay: return "Rainy Day"
        }
    }

    var icon: String {
        switch self {
        case .indoor: return "🏠"
        case .outdoor: return "🌳"
        case .summer: return "☀️"
        case .winter: return "❄️"
        case .spring: return "🌸"
        case .fall: return "🍂"
        case .rainyDay: return "🌧️"
        }
    }
}

enum DateSetting: String, CaseIterable, Codable, Hashable {
    case indoor
    case outdoor
    case both

    var label: String {
        switch self {
        case .indoor: return "Indoor"
        case .outdoor: return "Outdoor"
        case .both: return "Indoor & Outdoor"
        }
    }
}

enum ActivityLevel: String, CaseIterable, Codable, Hashable {
    case relaxed
    case moderate
    case active

    var label: String {
        switch self {
        case .relaxed: return "Relaxed"
        case .moderate: return "Moderate"
        case .active: return "Active"
        }
    }
}

enum JarOwner: String, Codable, Hashable {
    case partner1
    case partner2

    func displayName(preferences: CouplePreferences) -> String {
        switch self {
        case .partner1: return preferences.partner1Name
        case .partner2: return preferences.partner2Name
        }
    }
}
