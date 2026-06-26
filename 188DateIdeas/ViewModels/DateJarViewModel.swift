import SwiftUI
import Combine

@MainActor
final class DateJarViewModel: ObservableObject {
    @Published var ideas: [Idea] = []
    @Published var selectedOwner: JarOwner = .partner1
    @Published var newTitle = ""
    @Published var newDescription = ""

    private let storageService: StorageServiceProtocol
    private let gamificationService: GamificationService
    private let coordinator: AppCoordinator

    var preferences: CouplePreferences {
        storageService.loadPreferences()
    }

    var partner1Count: Int {
        ideas.filter { $0.jarOwner == .partner1 && !$0.isUsed }.count
    }

    var partner2Count: Int {
        ideas.filter { $0.jarOwner == .partner2 && !$0.isUsed }.count
    }

    var myIdeas: [Idea] {
        ideas.filter { $0.jarOwner == selectedOwner && !$0.isUsed }
    }

    init(storageService: StorageServiceProtocol, gamificationService: GamificationService, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.gamificationService = gamificationService
        self.coordinator = coordinator
        load()
    }

    func load() {
        ideas = storageService.loadIdeas()
    }

    func addSecretIdea() {
        let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = newDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty, !description.isEmpty else { return }

        let idea = Idea(
            title: title,
            description: description,
            category: .spontaneous,
            budget: .medium,
            timeRequired: 60,
            seasonTags: [.indoor],
            setting: .both,
            activityLevel: .moderate,
            jarOwner: selectedOwner
        )
        storageService.append(idea, forKey: StorageKey.ideas)
        gamificationService.recordJarIdeaAdded()
        newTitle = ""
        newDescription = ""
        load()
    }

    func goBack() {
        coordinator.pop()
    }
}
