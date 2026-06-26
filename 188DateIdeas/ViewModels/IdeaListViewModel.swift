import SwiftUI
import Combine

@MainActor
final class IdeaListViewModel: ObservableObject {
    @Published var ideas: [Idea] = []
    @Published var searchText = ""
    @Published var selectedCategory: Category?
    @Published var showFavoritesOnly: Bool
    @Published var microOnly: Bool
    @Published var personalizedOnly: Bool
    @Published var seasonTag: SeasonTag?

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator

    var filteredIdeas: [Idea] {
        var result = ideas

        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }

        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        if microOnly {
            result = result.filter(\.isMicroDate)
        }

        if let seasonTag {
            result = result.filter { $0.seasonTags.contains(seasonTag) }
        }

        if personalizedOnly {
            let prefs = storageService.loadPreferences()
            result = storageService.personalizedIdeas(preferences: prefs).filter { idea in
                result.contains(where: { $0.id == idea.id })
            }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result
    }

    init(
        category: Category? = nil,
        showFavorites: Bool = false,
        microOnly: Bool = false,
        personalized: Bool = false,
        seasonTag: SeasonTag? = nil,
        storageService: StorageServiceProtocol,
        coordinator: AppCoordinator
    ) {
        self.selectedCategory = category
        self.showFavoritesOnly = showFavorites
        self.microOnly = microOnly
        self.personalizedOnly = personalized
        self.seasonTag = seasonTag
        self.storageService = storageService
        self.coordinator = coordinator
        loadIdeas()
    }

    func loadIdeas() {
        ideas = storageService.loadIdeas()
    }

    func deleteIdea(at offsets: IndexSet) {
        let ids = offsets.map { filteredIdeas[$0].id }
        for id in ids {
            ideas.removeAll { $0.id == id }
        }
        storageService.saveIdeas(ideas)
        loadIdeas()
    }

    func toggleFavorite(_ idea: Idea) {
        guard let index = ideas.firstIndex(where: { $0.id == idea.id }) else { return }
        var updated = ideas[index]
        updated.isFavorite.toggle()
        ideas[index] = updated
        storageService.update(updated, forKey: StorageKey.ideas)
        loadIdeas()
    }

    func goToIdeaDetail(_ idea: Idea) {
        coordinator.navigateToIdeaDetail(idea: idea)
    }

    func goToIdeaForm() {
        coordinator.navigateToIdeaForm(idea: nil)
    }

    func goBack() {
        coordinator.pop()
    }
}
