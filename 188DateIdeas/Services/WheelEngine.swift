import Foundation

final class WheelEngine {
    enum Source {
        case all
        case jarOnly
        case microOnly
        case personalized
    }

    func pickRandomIdea(
        from ideas: [Idea],
        source: Source = .all,
        preferences: CouplePreferences? = nil
    ) -> Idea? {
        let pool = filteredIdeas(from: ideas, source: source, preferences: preferences)
        guard !pool.isEmpty else { return nil }
        return pool.randomElement()
    }

    func getUnusedIdeas(
        _ ideas: [Idea],
        source: Source = .all,
        preferences: CouplePreferences? = nil
    ) -> [Idea] {
        filteredIdeas(from: ideas, source: source, preferences: preferences)
    }

    func getUsedIdeas(_ ideas: [Idea]) -> [Idea] {
        ideas.filter { $0.isUsed }
    }

    private func filteredIdeas(
        from ideas: [Idea],
        source: Source,
        preferences: CouplePreferences?
    ) -> [Idea] {
        var result = ideas.filter { !$0.isUsed }

        switch source {
        case .all:
            break
        case .jarOnly:
            result = result.filter { $0.jarOwner != nil }
        case .microOnly:
            result = result.filter(\.isMicroDate)
        case .personalized:
            guard let preferences else { break }
            result = result.filter { idea in
                idea.budget == preferences.preferredBudget ||
                idea.setting == preferences.preferredSetting ||
                idea.activityLevel == preferences.activityLevel ||
                (preferences.preferredSeasonTag.map { idea.seasonTags.contains($0) } ?? false) ||
                (preferences.prefersMicroDates && idea.isMicroDate)
            }
            if result.isEmpty {
                result = ideas.filter { !$0.isUsed }
            }
        }

        return result
    }
}
