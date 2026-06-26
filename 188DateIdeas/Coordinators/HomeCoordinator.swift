import SwiftUI

final class HomeCoordinator {
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func showIdeaList(category: Category? = nil, showFavorites: Bool = false) {
        appCoordinator.navigateToIdeaList(category: category, showFavorites: showFavorites)
    }

    func showIdeaForm(idea: Idea? = nil) {
        appCoordinator.navigateToIdeaForm(idea: idea)
    }

    func showHistory() {
        appCoordinator.navigateToHistory()
    }

    func showSettings() {
        appCoordinator.navigateToSettings()
    }

    func showIdeaDetail(idea: Idea) {
        appCoordinator.navigateToIdeaDetail(idea: idea)
    }
}
