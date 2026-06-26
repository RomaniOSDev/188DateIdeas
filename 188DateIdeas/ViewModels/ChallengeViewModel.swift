import SwiftUI
import Combine

@MainActor
final class ChallengeViewModel: ObservableObject {
    @Published var progress: ChallengeProgress

    private let challengeService: ChallengeService
    private let coordinator: AppCoordinator

    var daysRemaining: Int {
        ChallengeService.daysRemaining(from: progress)
    }

    init(challengeService: ChallengeService, coordinator: AppCoordinator) {
        self.challengeService = challengeService
        self.coordinator = coordinator
        self.progress = challengeService.loadProgress()
    }

    func startChallenge() {
        progress = challengeService.startChallenge()
    }

    func resetChallenge() {
        challengeService.resetChallenge()
        progress = .inactive
    }

    func goBack() {
        coordinator.pop()
    }
}
