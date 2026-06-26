import Foundation

enum BadgeType: String, CaseIterable, Codable, Hashable, Identifiable {
    case firstDate
    case threeWeekStreak
    case fiveWeekStreak
    case categoryExplorer
    case challengeComplete
    case jarMaster
    case microDatePro
    case journalKeeper

    var id: String { rawValue }

    var title: String {
        switch self {
        case .firstDate: return "First Date"
        case .threeWeekStreak: return "3-Week Streak"
        case .fiveWeekStreak: return "5-Week Streak"
        case .categoryExplorer: return "Category Explorer"
        case .challengeComplete: return "Challenge Champion"
        case .jarMaster: return "Jar Master"
        case .microDatePro: return "Micro Date Pro"
        case .journalKeeper: return "Journal Keeper"
        }
    }

    var description: String {
        switch self {
        case .firstDate: return "Complete your first date"
        case .threeWeekStreak: return "3 weeks of unique dates"
        case .fiveWeekStreak: return "5 weeks of unique dates"
        case .categoryExplorer: return "Try 5 different categories"
        case .challengeComplete: return "Finish the 30-day challenge"
        case .jarMaster: return "Add 5 ideas to the Date Jar"
        case .microDatePro: return "Complete 3 micro-dates"
        case .journalKeeper: return "Write 3 journal reflections"
        }
    }

    var icon: String {
        switch self {
        case .firstDate: return "💑"
        case .threeWeekStreak: return "🔥"
        case .fiveWeekStreak: return "⭐"
        case .categoryExplorer: return "🗺️"
        case .challengeComplete: return "🏆"
        case .jarMaster: return "🫙"
        case .microDatePro: return "⚡"
        case .journalKeeper: return "📔"
        }
    }
}

struct StreakState: Codable, Hashable {
    var currentWeeklyStreak: Int
    var longestStreak: Int
    var lastCompletionWeek: String?
    var earnedBadgeIds: [String]
    var totalDatesCompleted: Int
    var categoriesCompleted: [Category]
    var microDatesCompleted: Int
    var journalEntriesWritten: Int
    var jarIdeasAdded: Int

    static let empty = StreakState(
        currentWeeklyStreak: 0,
        longestStreak: 0,
        lastCompletionWeek: nil,
        earnedBadgeIds: [],
        totalDatesCompleted: 0,
        categoriesCompleted: [],
        microDatesCompleted: 0,
        journalEntriesWritten: 0,
        jarIdeasAdded: 0
    )

    var earnedBadges: [BadgeType] {
        earnedBadgeIds.compactMap { BadgeType(rawValue: $0) }
    }
}

struct ChallengeProgress: Codable, Hashable {
    var isActive: Bool
    var startDate: Date?
    var completedWeekStarts: [Date]
    var categoriesUsed: [Category]
    let targetWeeks: Int

    static let inactive = ChallengeProgress(
        isActive: false,
        startDate: nil,
        completedWeekStarts: [],
        categoriesUsed: [],
        targetWeeks: 4
    )

    var weeksCompleted: Int { completedWeekStarts.count }

    var progress: Double {
        guard targetWeeks > 0 else { return 0 }
        return min(Double(weeksCompleted) / Double(targetWeeks), 1.0)
    }

    var isComplete: Bool { weeksCompleted >= targetWeeks }
}
