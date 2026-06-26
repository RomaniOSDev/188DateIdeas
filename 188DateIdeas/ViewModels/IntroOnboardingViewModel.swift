import SwiftUI
import Combine

@MainActor
final class IntroOnboardingViewModel: ObservableObject {
    @Published var page = 0
    @Published var partner1Name = "Alex"
    @Published var partner2Name = "Sam"

    let totalPages = 3

    private let storageService: StorageServiceProtocol
    private let onComplete: () -> Void

    init(storageService: StorageServiceProtocol, onComplete: @escaping () -> Void) {
        self.storageService = storageService
        self.onComplete = onComplete
    }

    func next() {
        if page < totalPages - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                page += 1
            }
        } else {
            complete()
        }
    }

    func back() {
        guard page > 0 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            page -= 1
        }
    }

    func skip() {
        complete()
    }

    func complete() {
        var preferences = storageService.loadPreferences()
        preferences.partner1Name = sanitized(partner1Name, fallback: "Partner 1")
        preferences.partner2Name = sanitized(partner2Name, fallback: "Partner 2")
        preferences.hasCompletedOnboarding = true
        storageService.savePreferences(preferences)
        onComplete()
    }

    private func sanitized(_ value: String, fallback: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? fallback : trimmed
    }
}
