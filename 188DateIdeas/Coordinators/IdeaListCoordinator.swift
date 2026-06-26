import SwiftUI

final class IdeaListCoordinator {
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func showIdeaDetail(idea: Idea) {
        appCoordinator.navigateToIdeaDetail(idea: idea)
    }

    func showIdeaForm(idea: Idea? = nil) {
        appCoordinator.navigateToIdeaForm(idea: idea)
    }

    func goBack() {
        appCoordinator.pop()
    }
}
