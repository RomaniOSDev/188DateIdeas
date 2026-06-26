import Foundation

final class ChallengeService {
    private let storage: StorageServiceProtocol
    private let gamification: GamificationService

    init(storage: StorageServiceProtocol, gamification: GamificationService) {
        self.storage = storage
        self.gamification = gamification
    }

    func loadProgress() -> ChallengeProgress {
        storage.loadChallengeProgress()
    }

    func startChallenge() -> ChallengeProgress {
        var progress = ChallengeProgress(
            isActive: true,
            startDate: Date(),
            completedWeekStarts: [],
            categoriesUsed: [],
            targetWeeks: 4
        )
        storage.saveChallengeProgress(progress)
        return progress
    }

    func recordCompletion(for idea: Idea) -> ChallengeProgress {
        var progress = storage.loadChallengeProgress()
        guard progress.isActive else { return progress }

        let weekStart = Self.startOfWeek(for: Date())
        if !progress.completedWeekStarts.contains(where: { Calendar.current.isDate($0, inSameDayAs: weekStart) }) {
            progress.completedWeekStarts.append(weekStart)
        }
        if !progress.categoriesUsed.contains(idea.category) {
            progress.categoriesUsed.append(idea.category)
        }

        if progress.isComplete {
            gamification.awardChallengeBadge()
        }

        storage.saveChallengeProgress(progress)
        return progress
    }

    func resetChallenge() {
        storage.saveChallengeProgress(.inactive)
    }

    static func startOfWeek(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components) ?? date
    }

    static func daysRemaining(from progress: ChallengeProgress) -> Int {
        guard let start = progress.startDate else { return 30 }
        let end = Calendar.current.date(byAdding: .day, value: 30, to: start) ?? start
        return max(Calendar.current.dateComponents([.day], from: Date(), to: end).day ?? 0, 0)
    }
}
