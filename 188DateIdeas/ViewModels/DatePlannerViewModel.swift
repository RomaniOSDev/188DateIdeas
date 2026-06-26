import SwiftUI
import Combine

@MainActor
final class DatePlannerViewModel: ObservableObject {
    @Published var plan: DatePlan
    @Published var newBringItem = ""
    @Published var newChecklistItem = ""
    @Published var shareImage: UIImage?
    @Published var showShareSheet = false

    let idea: Idea
    private let storageService: StorageServiceProtocol
    private let exportService: ExportService
    private let coordinator: AppCoordinator

    init(
        idea: Idea,
        storageService: StorageServiceProtocol,
        plannerService: PlannerService,
        exportService: ExportService,
        coordinator: AppCoordinator
    ) {
        self.idea = idea
        self.storageService = storageService
        self.exportService = exportService
        self.coordinator = coordinator
        self.plan = plannerService.defaultPlan(for: idea)
    }

    func toggleChecklist(_ item: ChecklistItem) {
        guard let index = plan.checklist.firstIndex(where: { $0.id == item.id }) else { return }
        plan.checklist[index].isCompleted.toggle()
        save()
    }

    func addChecklistItem() {
        let title = newChecklistItem.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        plan.checklist.append(ChecklistItem(title: title))
        newChecklistItem = ""
        save()
    }

    func addBringItem() {
        let title = newBringItem.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        plan.whatToBring.append(title)
        newBringItem = ""
        save()
    }

    func removeBringItem(at offsets: IndexSet) {
        plan.whatToBring.remove(atOffsets: offsets)
        save()
    }

    func save() {
        storageService.saveDatePlan(plan)
    }

    func exportPlan() {
        let preferences = storageService.loadPreferences()
        shareImage = exportService.renderDatePlanCard(idea: idea, plan: plan, preferences: preferences)
        showShareSheet = shareImage != nil
    }

    func goBack() {
        coordinator.pop()
    }
}
