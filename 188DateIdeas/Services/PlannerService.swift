import Foundation

final class PlannerService {
    private let storage: StorageServiceProtocol

    init(storage: StorageServiceProtocol) {
        self.storage = storage
    }

    func defaultPlan(for idea: Idea) -> DatePlan {
        if let existing = storage.datePlan(for: idea.id) {
            return existing
        }

        return DatePlan(
            ideaId: idea.id,
            checklist: defaultChecklist(for: idea),
            leaveInMinutes: max(15, idea.timeRequired / 4),
            whatToBring: defaultBringItems(for: idea)
        )
    }

    private func defaultChecklist(for idea: Idea) -> [ChecklistItem] {
        var items = [
            ChecklistItem(title: "Confirm reservation or tickets"),
            ChecklistItem(title: "Check the weather"),
            ChecklistItem(title: "Charge your phone")
        ]

        if idea.setting == .outdoor || idea.setting == .both {
            items.append(ChecklistItem(title: "Pack comfortable shoes"))
        }
        if idea.budget != .low {
            items.append(ChecklistItem(title: "Bring wallet / card"))
        }
        if idea.seasonTags.contains(.rainyDay) {
            items.append(ChecklistItem(title: "Bring an umbrella"))
        }
        if idea.isMicroDate {
            items.append(ChecklistItem(title: "Set a quick 30-min timer"))
        }

        switch idea.category {
        case .romantic:
            items.append(ChecklistItem(title: "Pick a small surprise gift"))
        case .gastronomic:
            items.append(ChecklistItem(title: "Check dietary preferences"))
        case .adventure:
            items.append(ChecklistItem(title: "Pack water and snacks"))
        case .cultural:
            items.append(ChecklistItem(title: "Read exhibit info beforehand"))
        default:
            break
        }

        return items
    }

    private func defaultBringItems(for idea: Idea) -> [String] {
        var items = ["Phone", "Keys"]
        if idea.setting == .outdoor || idea.setting == .both {
            items.append("Jacket")
        }
        if idea.category == .romantic {
            items.append("Small gift or flowers")
        }
        if idea.category == .gastronomic {
            items.append("Appetite")
        }
        return items
    }
}
