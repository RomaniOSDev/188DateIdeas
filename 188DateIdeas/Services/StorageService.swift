import Foundation

protocol StorageServiceProtocol {
    func save<T: Codable>(_ items: [T], forKey key: String)
    func load<T: Codable>(forKey key: String) -> [T]
    func delete(forKey key: String)
    func append<T: Codable>(_ item: T, forKey key: String)
    func update<T: Codable & Identifiable>(_ item: T, forKey key: String)
}

enum StorageKey {
    static let ideas = "ideas"
    static let history = "history"
    static let skipDemoDataSeed = "skipDemoDataSeed"
    static let preferences = "preferences"
    static let streakState = "streakState"
    static let challengeProgress = "challengeProgress"
    static let datePlans = "datePlans"
}

extension StorageServiceProtocol {
    func loadIdeas() -> [Idea] { load(forKey: StorageKey.ideas) }
    func saveIdeas(_ ideas: [Idea]) { save(ideas, forKey: StorageKey.ideas) }
    func loadHistory() -> [HistoryEntry] { load(forKey: StorageKey.history) }
    func saveHistory(_ entries: [HistoryEntry]) { save(entries, forKey: StorageKey.history) }

    func loadPreferences() -> CouplePreferences {
        guard let data = UserDefaults.standard.data(forKey: StorageKey.preferences),
              let prefs = try? JSONDecoder().decode(CouplePreferences.self, from: data) else {
            return .default
        }
        return prefs
    }

    func savePreferences(_ preferences: CouplePreferences) {
        guard let data = try? JSONEncoder().encode(preferences) else { return }
        UserDefaults.standard.set(data, forKey: StorageKey.preferences)
    }

    func loadStreakState() -> StreakState {
        guard let data = UserDefaults.standard.data(forKey: StorageKey.streakState),
              let state = try? JSONDecoder().decode(StreakState.self, from: data) else {
            return .empty
        }
        return state
    }

    func saveStreakState(_ state: StreakState) {
        guard let data = try? JSONEncoder().encode(state) else { return }
        UserDefaults.standard.set(data, forKey: StorageKey.streakState)
    }

    func loadChallengeProgress() -> ChallengeProgress {
        guard let data = UserDefaults.standard.data(forKey: StorageKey.challengeProgress),
              let progress = try? JSONDecoder().decode(ChallengeProgress.self, from: data) else {
            return .inactive
        }
        return progress
    }

    func saveChallengeProgress(_ progress: ChallengeProgress) {
        guard let data = try? JSONEncoder().encode(progress) else { return }
        UserDefaults.standard.set(data, forKey: StorageKey.challengeProgress)
    }

    func loadDatePlans() -> [DatePlan] { load(forKey: StorageKey.datePlans) }
    func saveDatePlans(_ plans: [DatePlan]) { save(plans, forKey: StorageKey.datePlans) }

    func datePlan(for ideaId: UUID) -> DatePlan? {
        loadDatePlans().first { $0.ideaId == ideaId }
    }

    func saveDatePlan(_ plan: DatePlan) {
        var plans = loadDatePlans()
        if let index = plans.firstIndex(where: { $0.ideaId == plan.ideaId }) {
            plans[index] = plan
        } else {
            plans.append(plan)
        }
        saveDatePlans(plans)
    }

    @discardableResult
    func markIdeaAsUsed(id ideaId: UUID) -> Idea? {
        var ideas = loadIdeas()
        guard let index = ideas.firstIndex(where: { $0.id == ideaId }) else { return nil }
        ideas[index].isUsed = true
        ideas[index].usedDate = Date()
        saveIdeas(ideas)
        return ideas[index]
    }

    @discardableResult
    func addHistoryEntry(for idea: Idea, rating: Int? = nil, note: String? = nil) -> HistoryEntry {
        let entry = HistoryEntry(
            id: UUID(),
            ideaId: idea.id,
            ideaTitle: idea.title,
            date: Date(),
            rating: rating,
            note: note
        )
        append(entry, forKey: StorageKey.history)
        return entry
    }

    func updateHistoryEntry(_ entry: HistoryEntry) {
        update(entry, forKey: StorageKey.history)
    }

    func jarIdeas() -> [Idea] {
        loadIdeas().filter { $0.jarOwner != nil && !$0.isUsed }
    }

    func personalizedIdeas(preferences: CouplePreferences) -> [Idea] {
        let ideas = loadIdeas().filter { !$0.isUsed }
        return ideas.sorted { score(for: $0, preferences: preferences) > score(for: $1, preferences: preferences) }
    }

    private func score(for idea: Idea, preferences: CouplePreferences) -> Int {
        var value = 0
        if idea.budget == preferences.preferredBudget { value += 2 }
        if idea.setting == preferences.preferredSetting || idea.setting == .both || preferences.preferredSetting == .both {
            value += 2
        }
        if idea.activityLevel == preferences.activityLevel { value += 2 }
        if let tag = preferences.preferredSeasonTag, idea.seasonTags.contains(tag) { value += 3 }
        if preferences.prefersMicroDates && idea.isMicroDate { value += 3 }
        if idea.isFavorite { value += 1 }
        return value
    }
}

final class UserDefaultsStorageService: StorageServiceProtocol {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func save<T: Codable>(_ items: [T], forKey key: String) {
        guard let data = try? encoder.encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    func load<T: Codable>(forKey key: String) -> [T] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? decoder.decode([T].self, from: data) else {
            return []
        }
        return items
    }

    func delete(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    func append<T: Codable>(_ item: T, forKey key: String) {
        var items: [T] = load(forKey: key)
        items.append(item)
        save(items, forKey: key)
    }

    func update<T: Codable & Identifiable>(_ item: T, forKey key: String) {
        var items: [T] = load(forKey: key)
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            save(items, forKey: key)
        }
    }
}
