import SwiftUI

final class HistoryCoordinator {
    private let appCoordinator: AppCoordinator

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func goBack() {
        appCoordinator.pop()
    }
}
