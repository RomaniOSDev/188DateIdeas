import SwiftUI
import Combine

@MainActor
final class IdeaDetailViewModel: ObservableObject {
    @Published var idea: Idea
    @Published var showDeleteAlert = false

    private let storageService: StorageServiceProtocol
    private let gamificationService: GamificationService
    private let challengeService: ChallengeService
    private let coordinator: AppCoordinator

    init(
        idea: Idea,
        storageService: StorageServiceProtocol,
        gamificationService: GamificationService,
        challengeService: ChallengeService,
        coordinator: AppCoordinator
    ) {
        self.idea = idea
        self.storageService = storageService
        self.gamificationService = gamificationService
        self.challengeService = challengeService
        self.coordinator = coordinator
    }

    func toggleFavorite() {
        var updated = idea
        updated.isFavorite.toggle()
        idea = updated
        storageService.update(updated, forKey: StorageKey.ideas)
    }

    func markAsUsed() {
        guard let updated = storageService.markIdeaAsUsed(id: idea.id) else { return }
        idea = updated
        let entry = storageService.addHistoryEntry(for: updated)
        _ = gamificationService.recordDateCompletion(for: updated, hasJournal: false)
        _ = challengeService.recordCompletion(for: updated)
        coordinator.navigateToJournal(entry: entry)
    }

    func deleteIdea() {
        var allIdeas = storageService.loadIdeas()
        allIdeas.removeAll { $0.id == idea.id }
        storageService.saveIdeas(allIdeas)
        coordinator.pop()
    }

    func goBack() {
        coordinator.pop()
    }

    func goToEdit() {
        coordinator.navigateToIdeaForm(idea: idea)
    }

    func goToPlanner() {
        coordinator.navigateToDatePlanner(idea: idea)
    }
}
