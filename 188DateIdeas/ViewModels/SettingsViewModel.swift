import SwiftUI
import Combine
import StoreKit
import UIKit

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var showResetAlert = false

    private let storageService: StorageServiceProtocol
    private let photoStorage: PhotoStorageService
    private let coordinator: AppCoordinator

    init(storageService: StorageServiceProtocol, photoStorage: PhotoStorageService, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.photoStorage = photoStorage
        self.coordinator = coordinator
    }

    func resetAllData() {
        storageService.delete(forKey: StorageKey.ideas)
        storageService.delete(forKey: StorageKey.history)
        storageService.delete(forKey: StorageKey.datePlans)
        storageService.delete(forKey: StorageKey.streakState)
        storageService.delete(forKey: StorageKey.challengeProgress)
        storageService.delete(forKey: StorageKey.preferences)
        photoStorage.deleteAllPhotos()
        UserDefaults.standard.set(true, forKey: StorageKey.skipDemoDataSeed)
        coordinator.showIntroOnboarding = true
        coordinator.showPreferencesQuiz = false
        coordinator.popToRoot()
    }

    func retakeQuiz() {
        coordinator.showPreferencesQuiz = true
        coordinator.popToRoot()
    }

    func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }

    func openPrivacyPolicy() {
        open(link: .privacyPolicy)
    }

    func openTerms() {
        open(link: .termsOfService)
    }

    private func open(link: AppLink) {
        if let url = link.url {
            UIApplication.shared.open(url)
        }
    }

    func goBack() {
        coordinator.pop()
    }
}
