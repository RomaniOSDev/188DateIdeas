import SwiftUI
import Combine
import PhotosUI

@MainActor
final class JournalEntryViewModel: ObservableObject {
    @Published var entry: HistoryEntry
    @Published var reflection = ""
    @Published var wouldRepeat = true
    @Published var rating = 0
    @Published var selectedPhotoItem: PhotosPickerItem?
    @Published var loadedImages: [UIImage] = []

    private let storageService: StorageServiceProtocol
    private let photoStorage: PhotoStorageService
    private let gamificationService: GamificationService
    private let coordinator: AppCoordinator

    init(
        entry: HistoryEntry,
        storageService: StorageServiceProtocol,
        photoStorage: PhotoStorageService,
        gamificationService: GamificationService,
        coordinator: AppCoordinator
    ) {
        self.entry = entry
        self.storageService = storageService
        self.photoStorage = photoStorage
        self.gamificationService = gamificationService
        self.coordinator = coordinator
        self.reflection = entry.reflection ?? entry.note ?? ""
        self.wouldRepeat = entry.wouldRepeat ?? true
        self.rating = entry.rating ?? 0
        loadPhotos()
    }

    func loadPhotos() {
        loadedImages = entry.photoFileNames.compactMap { photoStorage.loadPhoto(named: $0) }
    }

    func addPhoto() async {
        guard let selectedPhotoItem,
              let data = try? await selectedPhotoItem.loadTransferable(type: Data.self),
              let image = UIImage(data: data),
              let fileName = photoStorage.savePhoto(image) else { return }
        entry.photoFileNames.append(fileName)
        loadedImages.append(image)
        self.selectedPhotoItem = nil
    }

    func save() {
        entry.reflection = reflection.trimmingCharacters(in: .whitespacesAndNewlines)
        entry.wouldRepeat = wouldRepeat
        entry.rating = rating > 0 ? rating : nil
        entry.note = entry.reflection
        storageService.updateHistoryEntry(entry)
        if !reflection.isEmpty {
            gamificationService.recordJournalWritten()
        }
        coordinator.pop()
    }

    func goBack() {
        coordinator.pop()
    }
}
