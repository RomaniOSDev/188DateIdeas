import SwiftUI
import Combine

@MainActor
final class PreferencesQuizViewModel: ObservableObject {
    @Published var step = 0
    @Published var preferredBudget: Budget = .medium
    @Published var preferredSetting: DateSetting = .both
    @Published var activityLevel: ActivityLevel = .moderate
    @Published var preferredSeasonTag: SeasonTag?
    @Published var prefersMicroDates = false
    @Published var partner1Name = "Alex"
    @Published var partner2Name = "Sam"

    private let storageService: StorageServiceProtocol
    private let onComplete: () -> Void

    let totalSteps = 5

    init(storageService: StorageServiceProtocol, onComplete: @escaping () -> Void) {
        self.storageService = storageService
        self.onComplete = onComplete
    }

    func next() {
        if step < totalSteps - 1 {
            step += 1
        } else {
            complete()
        }
    }

    func back() {
        guard step > 0 else { return }
        step -= 1
    }

    func complete() {
        var preferences = storageService.loadPreferences()
        preferences.preferredBudget = preferredBudget
        preferences.preferredSetting = preferredSetting
        preferences.activityLevel = activityLevel
        preferences.preferredSeasonTag = preferredSeasonTag
        preferences.prefersMicroDates = prefersMicroDates
        preferences.partner1Name = partner1Name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Partner 1" : partner1Name
        preferences.partner2Name = partner2Name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Partner 2" : partner2Name
        preferences.hasCompletedOnboarding = true
        storageService.savePreferences(preferences)
        onComplete()
    }

    var stepTitle: String {
        switch step {
        case 0: return "What's your usual budget?"
        case 1: return "Indoor or outdoor?"
        case 2: return "How active are you?"
        case 3: return "Favorite season vibe?"
        case 4: return "Your names"
        default: return ""
        }
    }
}
