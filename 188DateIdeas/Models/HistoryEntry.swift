import Foundation

struct HistoryEntry: Identifiable, Codable, Hashable {
    let id: UUID
    var ideaId: UUID
    var ideaTitle: String
    var date: Date
    var rating: Int?
    var note: String?
    var photoFileNames: [String]
    var reflection: String?
    var wouldRepeat: Bool?

    init(
        id: UUID = UUID(),
        ideaId: UUID,
        ideaTitle: String,
        date: Date,
        rating: Int? = nil,
        note: String? = nil,
        photoFileNames: [String] = [],
        reflection: String? = nil,
        wouldRepeat: Bool? = nil
    ) {
        self.id = id
        self.ideaId = ideaId
        self.ideaTitle = ideaTitle
        self.date = date
        self.rating = rating
        self.note = note
        self.photoFileNames = photoFileNames
        self.reflection = reflection
        self.wouldRepeat = wouldRepeat
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        ideaId = try container.decode(UUID.self, forKey: .ideaId)
        ideaTitle = try container.decode(String.self, forKey: .ideaTitle)
        date = try container.decode(Date.self, forKey: .date)
        rating = try container.decodeIfPresent(Int.self, forKey: .rating)
        note = try container.decodeIfPresent(String.self, forKey: .note)
        photoFileNames = try container.decodeIfPresent([String].self, forKey: .photoFileNames) ?? []
        reflection = try container.decodeIfPresent(String.self, forKey: .reflection)
        wouldRepeat = try container.decodeIfPresent(Bool.self, forKey: .wouldRepeat)
    }
}
