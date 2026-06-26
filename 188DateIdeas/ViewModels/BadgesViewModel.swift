import SwiftUI
import Combine

@MainActor
final class BadgesViewModel: ObservableObject {
    @Published var streakState: StreakState

    private let storageService: StorageServiceProtocol
    private let gamificationService: GamificationService
    private let coordinator: AppCoordinator

    var allBadges: [BadgeType] { BadgeType.allCases }

    init(storageService: StorageServiceProtocol, gamificationService: GamificationService, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.gamificationService = gamificationService
        self.coordinator = coordinator
        self.streakState = storageService.loadStreakState()
    }

    func isEarned(_ badge: BadgeType) -> Bool {
        streakState.earnedBadges.contains(badge)
    }

    func reload() {
        streakState = storageService.loadStreakState()
    }

    func goBack() {
        coordinator.pop()
    }
}
