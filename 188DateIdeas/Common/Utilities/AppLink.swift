import Foundation

enum AppLink {
    case privacyPolicy
    case termsOfService

    var urlString: String {
        switch self {
        case .privacyPolicy:
            return "https://www.termsfeed.com/live/382f51ee-a951-4023-923a-f7e121c34019"
        case .termsOfService:
            return "https://www.termsfeed.com/live/d2ef09a6-2021-4be3-9b1f-623384bd3adc"
        }
    }

    var url: URL? {
        URL(string: urlString)
    }
}
