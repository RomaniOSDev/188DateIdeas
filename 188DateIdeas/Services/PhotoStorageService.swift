import Foundation
import UIKit

final class PhotoStorageService {
    private let folderName = "JournalPhotos"

    private var photosDirectory: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = documents.appendingPathComponent(folderName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    func savePhoto(_ image: UIImage) -> String? {
        let fileName = "\(UUID().uuidString).jpg"
        let url = photosDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        do {
            try data.write(to: url)
            return fileName
        } catch {
            return nil
        }
    }

    func loadPhoto(named fileName: String) -> UIImage? {
        let url = photosDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    func deletePhoto(named fileName: String) {
        let url = photosDirectory.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: url)
    }

    func deleteAllPhotos() {
        try? FileManager.default.removeItem(at: photosDirectory)
    }
}
