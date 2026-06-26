import Foundation

final class GamificationService {
    private let storage: StorageServiceProtocol

    init(storage: StorageServiceProtocol) {
        self.storage = storage
    }

    func recordDateCompletion(for idea: Idea, hasJournal: Bool) -> StreakState {
        var state = storage.loadStreakState()
        let weekKey = Self.weekKey(for: Date())

        if state.lastCompletionWeek != weekKey {
            if let lastWeek = state.lastCompletionWeek,
               Self.isConsecutiveWeek(lastWeek, weekKey) {
                state.currentWeeklyStreak += 1
            } else {
                state.currentWeeklyStreak = 1
            }
            state.lastCompletionWeek = weekKey
        }

        state.longestStreak = max(state.longestStreak, state.currentWeeklyStreak)
        state.totalDatesCompleted += 1

        if !state.categoriesCompleted.contains(idea.category) {
            state.categoriesCompleted.append(idea.category)
        }
        if idea.isMicroDate {
            state.microDatesCompleted += 1
        }
        if hasJournal {
            state.journalEntriesWritten += 1
        }

        state.earnedBadgeIds = evaluateBadges(state: state).map(\.rawValue)
        storage.saveStreakState(state)
        return state
    }

    func recordJarIdeaAdded() {
        var state = storage.loadStreakState()
        state.jarIdeasAdded += 1
        state.earnedBadgeIds = evaluateBadges(state: state).map(\.rawValue)
        storage.saveStreakState(state)
    }

    func recordJournalWritten() {
        var state = storage.loadStreakState()
        state.journalEntriesWritten += 1
        state.earnedBadgeIds = evaluateBadges(state: state).map(\.rawValue)
        storage.saveStreakState(state)
    }

    func awardChallengeBadge() {
        var state = storage.loadStreakState()
        if !state.earnedBadgeIds.contains(BadgeType.challengeComplete.rawValue) {
            state.earnedBadgeIds.append(BadgeType.challengeComplete.rawValue)
            storage.saveStreakState(state)
        }
    }

    func evaluateBadges(state: StreakState) -> [BadgeType] {
        var badges: [BadgeType] = []
        if state.totalDatesCompleted >= 1 { badges.append(.firstDate) }
        if state.currentWeeklyStreak >= 3 || state.longestStreak >= 3 { badges.append(.threeWeekStreak) }
        if state.currentWeeklyStreak >= 5 || state.longestStreak >= 5 { badges.append(.fiveWeekStreak) }
        if state.categoriesCompleted.count >= 5 { badges.append(.categoryExplorer) }
        if state.jarIdeasAdded >= 5 { badges.append(.jarMaster) }
        if state.microDatesCompleted >= 3 { badges.append(.microDatePro) }
        if state.journalEntriesWritten >= 3 { badges.append(.journalKeeper) }
        if storage.loadChallengeProgress().isComplete {
            badges.append(.challengeComplete)
        }
        return badges
    }

    static func weekKey(for date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.yearForWeekOfYear, from: date)
        let week = calendar.component(.weekOfYear, from: date)
        return "\(year)-W\(week)"
    }

    private static func isConsecutiveWeek(_ previous: String, _ current: String) -> Bool {
        guard let prevDate = date(fromWeekKey: previous),
              let currDate = date(fromWeekKey: current) else { return false }
        let days = Calendar.current.dateComponents([.day], from: prevDate, to: currDate).day ?? 0
        return days > 0 && days <= 7
    }

    private static func date(fromWeekKey key: String) -> Date? {
        let parts = key.split(separator: "-W")
        guard parts.count == 2,
              let year = Int(parts[0]),
              let week = Int(parts[1]) else { return nil }
        var components = DateComponents()
        components.yearForWeekOfYear = year
        components.weekOfYear = week
        components.weekday = 2
        return Calendar.current.date(from: components)
    }
}
