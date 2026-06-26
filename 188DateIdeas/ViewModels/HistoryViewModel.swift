import SwiftUI
import Combine
import UIKit

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var historyEntries: [HistoryEntry] = []
    @Published var ratingFilter: Int?

    private let storageService: StorageServiceProtocol
    private let photoStorage: PhotoStorageService
    private let coordinator: AppCoordinator

    var filteredHistory: [HistoryEntry] {
        if let rating = ratingFilter {
            return historyEntries.filter { $0.rating == rating }
        }
        return historyEntries
    }

    init(storageService: StorageServiceProtocol, photoStorage: PhotoStorageService, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.photoStorage = photoStorage
        self.coordinator = coordinator
        loadHistory()
    }

    func loadHistory() {
        historyEntries = storageService.loadHistory()
            .sorted { $0.date > $1.date }
    }

    func updateRating(for entry: HistoryEntry, rating: Int) {
        var entries = storageService.loadHistory()
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            var updated = entries[index]
            updated.rating = rating
            entries[index] = updated
            storageService.saveHistory(entries)
            loadHistory()
        }
    }

    func deleteHistory(at offsets: IndexSet) {
        let ids = offsets.map { filteredHistory[$0].id }
        var allEntries = storageService.loadHistory()
        for id in ids {
            allEntries.removeAll { $0.id == id }
        }
        storageService.saveHistory(allEntries)
        loadHistory()
    }

    func thumbnail(for entry: HistoryEntry) -> UIImage? {
        guard let name = entry.photoFileNames.first else { return nil }
        return photoStorage.loadPhoto(named: name)
    }

    func openJournal(_ entry: HistoryEntry) {
        coordinator.navigateToJournal(entry: entry)
    }

    func goBack() {
        coordinator.pop()
    }
}
