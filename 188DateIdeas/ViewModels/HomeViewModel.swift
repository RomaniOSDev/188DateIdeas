import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var ideas: [Idea] = []
    @Published var selectedIdea: Idea?
    @Published var isWheelSpinning = false
    @Published var alertMessage: String?
    @Published var streakState: StreakState = .empty
    @Published var challengeProgress: ChallengeProgress = .inactive
    @Published var wheelSource: WheelEngine.Source = .all

    private let storageService: StorageServiceProtocol
    private let wheelEngine: WheelEngine
    private let gamificationService: GamificationService
    private let challengeService: ChallengeService
    let coordinator: AppCoordinator

    var unusedIdeasCount: Int {
        ideas.filter { !$0.isUsed }.count
    }

    var usedIdeasCount: Int {
        ideas.filter { $0.isUsed }.count
    }

    var allIdeasCount: Int {
        ideas.count
    }

    var favoritesCount: Int {
        ideas.filter(\.isFavorite).count
    }

    var microDatesCount: Int {
        ideas.filter { !$0.isUsed && $0.isMicroDate }.count
    }

    var jarIdeasCount: Int {
        ideas.filter { $0.jarOwner != nil && !$0.isUsed }.count
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good night"
        }
    }

    var coupleNames: String {
        let prefs = preferences
        return "\(prefs.partner1Name) & \(prefs.partner2Name)"
    }

    var featuredIdea: Idea? {
        let prefs = preferences
        let personalized = wheelEngine.getUnusedIdeas(ideas, source: .personalized, preferences: prefs)
        if let pick = personalized.randomElement() { return pick }
        let favorites = ideas.filter { !$0.isUsed && $0.isFavorite }
        if let favorite = favorites.randomElement() { return favorite }
        return ideas.first { !$0.isUsed }
    }

    var preferences: CouplePreferences {
        storageService.loadPreferences()
    }

    init(
        storageService: StorageServiceProtocol,
        wheelEngine: WheelEngine,
        gamificationService: GamificationService,
        challengeService: ChallengeService,
        coordinator: AppCoordinator
    ) {
        self.storageService = storageService
        self.wheelEngine = wheelEngine
        self.gamificationService = gamificationService
        self.challengeService = challengeService
        self.coordinator = coordinator
        reload()
    }

    func reload() {
        ideas = storageService.loadIdeas()
        streakState = storageService.loadStreakState()
        challengeProgress = challengeService.loadProgress()
    }

    @discardableResult
    func spinWheel() -> Bool {
        guard !isWheelSpinning else { return false }
        reload()

        let prefs = preferences
        let unused = wheelEngine.getUnusedIdeas(ideas, source: wheelSource, preferences: prefs)
        guard !unused.isEmpty else {
            if ideas.isEmpty {
                alertMessage = "Add some date ideas first to spin the wheel."
            } else if wheelSource == .jarOnly {
                alertMessage = "The Date Jar is empty. Add secret ideas first!"
            } else if wheelSource == .microOnly {
                alertMessage = "No micro-dates available. Add ideas under 30 minutes."
            } else {
                alertMessage = "All ideas have been used. Add new ones or reset data in Settings."
            }
            return false
        }

        isWheelSpinning = true

        Task {
            try? await Task.sleep(for: .seconds(2))
            selectedIdea = wheelEngine.pickRandomIdea(from: ideas, source: wheelSource, preferences: prefs)
            isWheelSpinning = false
        }

        return true
    }

    func markIdeaAsUsed(_ idea: Idea) {
        guard let updated = storageService.markIdeaAsUsed(id: idea.id) else { return }
        let entry = storageService.addHistoryEntry(for: updated)
        streakState = gamificationService.recordDateCompletion(for: updated, hasJournal: false)
        _ = challengeService.recordCompletion(for: updated)
        reload()
        selectedIdea = nil
        coordinator.navigateToJournal(entry: entry)
    }

    func skipIdea() {
        selectedIdea = nil
    }

    func openPlanner(for idea: Idea) {
        selectedIdea = nil
        coordinator.navigateToDatePlanner(idea: idea)
    }

    func goToIdeaList(
        category: Category? = nil,
        showFavorites: Bool = false,
        microOnly: Bool = false,
        personalized: Bool = false,
        seasonTag: SeasonTag? = nil
    ) {
        coordinator.navigateToIdeaList(
            category: category,
            showFavorites: showFavorites,
            microOnly: microOnly,
            personalized: personalized,
            seasonTag: seasonTag
        )
    }

    func goToHistory() { coordinator.navigateToHistory() }
    func goToSettings() { coordinator.navigateToSettings() }
    func goToIdeaForm() { coordinator.navigateToIdeaForm(idea: nil) }
    func goToDateJar() { coordinator.navigateToDateJar() }
    func goToChallenge() { coordinator.navigateToChallenge() }
    func goToBadges() { coordinator.navigateToBadges() }

    func goToTonightPick() {
        if let idea = featuredIdea {
            goToIdeaDetail(idea)
        } else {
            goToIdeaList()
        }
    }

    func goToIdeaDetail(_ idea: Idea) {
        selectedIdea = nil
        coordinator.navigateToIdeaDetail(idea: idea)
    }
}
