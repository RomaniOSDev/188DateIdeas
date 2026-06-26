import Foundation

struct ChecklistItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

struct DatePlan: Identifiable, Codable, Hashable {
    let id: UUID
    let ideaId: UUID
    var checklist: [ChecklistItem]
    var leaveInMinutes: Int
    var whatToBring: [String]

    init(
        id: UUID = UUID(),
        ideaId: UUID,
        checklist: [ChecklistItem] = [],
        leaveInMinutes: Int = 30,
        whatToBring: [String] = []
    ) {
        self.id = id
        self.ideaId = ideaId
        self.checklist = checklist
        self.leaveInMinutes = leaveInMinutes
        self.whatToBring = whatToBring
    }
}
