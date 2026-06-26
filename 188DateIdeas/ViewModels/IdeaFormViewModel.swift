import SwiftUI
import Combine

@MainActor
final class IdeaFormViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var selectedCategory: Category = .romantic
    @Published var selectedBudget: Budget = .medium
    @Published var timeRequired = 60
    @Published var isFavorite = false
    @Published var selectedSetting: DateSetting = .both
    @Published var selectedActivity: ActivityLevel = .moderate
    @Published var selectedSeasonTags: Set<SeasonTag> = []
    @Published var addToJar = false
    @Published var jarOwner: JarOwner = .partner1

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private let editingIdea: Idea?

    var isEditing: Bool { editingIdea != nil }

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(idea: Idea? = nil, storageService: StorageServiceProtocol, coordinator: AppCoordinator) {
        self.editingIdea = idea
        self.storageService = storageService
        self.coordinator = coordinator

        if let idea {
            self.title = idea.title
            self.description = idea.description
            self.selectedCategory = idea.category
            self.selectedBudget = idea.budget
            self.timeRequired = idea.timeRequired
            self.isFavorite = idea.isFavorite
            self.selectedSetting = idea.setting
            self.selectedActivity = idea.activityLevel
            self.selectedSeasonTags = Set(idea.seasonTags)
            self.addToJar = idea.jarOwner != nil
            self.jarOwner = idea.jarOwner ?? .partner1
        }
    }

    func toggleSeasonTag(_ tag: SeasonTag) {
        if selectedSeasonTags.contains(tag) {
            selectedSeasonTags.remove(tag)
        } else {
            selectedSeasonTags.insert(tag)
        }
    }

    func saveIdea() {
        guard isFormValid else { return }

        if isEditing, let idea = editingIdea {
            var updated = idea
            updated.title = title
            updated.description = description
            updated.category = selectedCategory
            updated.budget = selectedBudget
            updated.timeRequired = timeRequired
            updated.isFavorite = isFavorite
            updated.setting = selectedSetting
            updated.activityLevel = selectedActivity
            updated.seasonTags = Array(selectedSeasonTags)
            updated.jarOwner = addToJar ? jarOwner : nil
            storageService.update(updated, forKey: StorageKey.ideas)
        } else {
            let newIdea = Idea(
                title: title,
                description: description,
                category: selectedCategory,
                budget: selectedBudget,
                timeRequired: timeRequired,
                isFavorite: isFavorite,
                seasonTags: Array(selectedSeasonTags),
                setting: selectedSetting,
                activityLevel: selectedActivity,
                jarOwner: addToJar ? jarOwner : nil
            )
            storageService.append(newIdea, forKey: StorageKey.ideas)
        }

        coordinator.pop()
    }

    func cancel() {
        coordinator.pop()
    }
}
