import SwiftUI
import Combine

enum AppDestination: Hashable {
    case ideaList(category: Category?, showFavorites: Bool, microOnly: Bool, personalized: Bool, seasonTag: SeasonTag?)
    case ideaForm(idea: Idea?)
    case ideaDetail(idea: Idea)
    case history
    case settings
    case datePlanner(idea: Idea)
    case dateJar
    case challenge
    case badges
    case journalEntry(HistoryEntry)
}

final class AppCoordinator: ObservableObject {
    @Published var path: [AppDestination] = []
    @Published var showIntroOnboarding: Bool
    @Published var showPreferencesQuiz: Bool

    let storageService: StorageServiceProtocol
    let wheelEngine: WheelEngine
    let plannerService: PlannerService
    let gamificationService: GamificationService
    let challengeService: ChallengeService
    let photoStorage: PhotoStorageService
    let exportService: ExportService

    private(set) lazy var homeViewModel: HomeViewModel = HomeViewModel(
        storageService: storageService,
        wheelEngine: wheelEngine,
        gamificationService: gamificationService,
        challengeService: challengeService,
        coordinator: self
    )

    init(
        storageService: StorageServiceProtocol = UserDefaultsStorageService(),
        wheelEngine: WheelEngine = WheelEngine(),
        photoStorage: PhotoStorageService = PhotoStorageService(),
        exportService: ExportService = ExportService()
    ) {
        self.storageService = storageService
        self.wheelEngine = wheelEngine
        self.photoStorage = photoStorage
        self.exportService = exportService
        self.plannerService = PlannerService(storage: storageService)
        self.gamificationService = GamificationService(storage: storageService)
        self.challengeService = ChallengeService(storage: storageService, gamification: gamificationService)
        DemoDataService.seedIfNeeded(using: storageService)
        self.showIntroOnboarding = !storageService.loadPreferences().hasCompletedOnboarding
        self.showPreferencesQuiz = false
    }

    func completeIntroOnboarding() {
        showIntroOnboarding = false
    }

    func completePreferencesQuiz() {
        showPreferencesQuiz = false
    }

    func navigateToIdeaList(
        category: Category? = nil,
        showFavorites: Bool = false,
        microOnly: Bool = false,
        personalized: Bool = false,
        seasonTag: SeasonTag? = nil
    ) {
        path.append(AppDestination.ideaList(
            category: category,
            showFavorites: showFavorites,
            microOnly: microOnly,
            personalized: personalized,
            seasonTag: seasonTag
        ))
    }

    func navigateToIdeaForm(idea: Idea? = nil) {
        path.append(AppDestination.ideaForm(idea: idea))
    }

    func navigateToIdeaDetail(idea: Idea) {
        path.append(AppDestination.ideaDetail(idea: idea))
    }

    func navigateToHistory() {
        path.append(AppDestination.history)
    }

    func navigateToSettings() {
        path.append(AppDestination.settings)
    }

    func navigateToDatePlanner(idea: Idea) {
        path.append(AppDestination.datePlanner(idea: idea))
    }

    func navigateToDateJar() {
        path.append(AppDestination.dateJar)
    }

    func navigateToChallenge() {
        path.append(AppDestination.challenge)
    }

    func navigateToBadges() {
        path.append(AppDestination.badges)
    }

    func navigateToJournal(entry: HistoryEntry) {
        path.append(AppDestination.journalEntry(entry))
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    @ViewBuilder
    func view(for destination: AppDestination) -> some View {
        switch destination {
        case let .ideaList(category, showFavorites, microOnly, personalized, seasonTag):
            IdeaListView(viewModel: IdeaListViewModel(
                category: category,
                showFavorites: showFavorites,
                microOnly: microOnly,
                personalized: personalized,
                seasonTag: seasonTag,
                storageService: storageService,
                coordinator: self
            ))
        case let .ideaForm(idea):
            IdeaFormView(viewModel: IdeaFormViewModel(
                idea: idea,
                storageService: storageService,
                coordinator: self
            ))
        case let .ideaDetail(idea):
            IdeaDetailView(viewModel: IdeaDetailViewModel(
                idea: idea,
                storageService: storageService,
                gamificationService: gamificationService,
                challengeService: challengeService,
                coordinator: self
            ))
        case .history:
            HistoryView(viewModel: HistoryViewModel(
                storageService: storageService,
                photoStorage: photoStorage,
                coordinator: self
            ))
        case .settings:
            SettingsView(viewModel: SettingsViewModel(
                storageService: storageService,
                photoStorage: photoStorage,
                coordinator: self
            ))
        case let .datePlanner(idea):
            DatePlannerView(viewModel: DatePlannerViewModel(
                idea: idea,
                storageService: storageService,
                plannerService: plannerService,
                exportService: exportService,
                coordinator: self
            ))
        case .dateJar:
            DateJarView(viewModel: DateJarViewModel(
                storageService: storageService,
                gamificationService: gamificationService,
                coordinator: self
            ))
        case .challenge:
            ChallengeView(viewModel: ChallengeViewModel(
                challengeService: challengeService,
                coordinator: self
            ))
        case .badges:
            BadgesView(viewModel: BadgesViewModel(
                storageService: storageService,
                gamificationService: gamificationService,
                coordinator: self
            ))
        case let .journalEntry(entry):
            JournalEntryView(viewModel: JournalEntryViewModel(
                entry: entry,
                storageService: storageService,
                photoStorage: photoStorage,
                gamificationService: gamificationService,
                coordinator: self
            ))
        }
    }
}
