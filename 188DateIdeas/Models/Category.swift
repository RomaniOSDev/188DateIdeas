import Foundation

enum Category: String, CaseIterable, Codable {
    case romantic = "Romantic"
    case active = "Active"
    case cozy = "Cozy"
    case adventure = "Adventure"
    case cultural = "Cultural"
    case gastronomic = "Gastronomic"
    case spontaneous = "Spontaneous"
    case relax = "Relax"

    var icon: String {
        switch self {
        case .romantic: return "❤️"
        case .active: return "🏃"
        case .cozy: return "🛋️"
        case .adventure: return "🧗"
        case .cultural: return "🏛️"
        case .gastronomic: return "🍽️"
        case .spontaneous: return "🎲"
        case .relax: return "🧘"
        }
    }

    var color: String {
        switch self {
        case .romantic: return "#FF6B6B"
        case .active: return "#FF9F43"
        case .cozy: return "#A29BFE"
        case .adventure: return "#00B894"
        case .cultural: return "#6C5CE7"
        case .gastronomic: return "#E17055"
        case .spontaneous: return "#FDCB6E"
        case .relax: return "#74B9FF"
        }
    }
}

enum Budget: String, CaseIterable, Codable {
    case low = "Budget-friendly"
    case medium = "Moderate"
    case high = "Expensive"

    var icon: String {
        switch self {
        case .low: return "💰"
        case .medium: return "💰💰"
        case .high: return "💰💰💰"
        }
    }
}
