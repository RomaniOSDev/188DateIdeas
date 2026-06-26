import Foundation

enum DemoDataService {
    static func seedIfNeeded(using storage: StorageServiceProtocol) {
        guard !UserDefaults.standard.bool(forKey: StorageKey.skipDemoDataSeed) else { return }
        guard storage.loadIdeas().isEmpty else { return }

        let ideas = makeDemoIdeas()
        storage.saveIdeas(ideas)

        if storage.loadHistory().isEmpty {
            storage.save(makeDemoHistory(for: ideas), forKey: StorageKey.history)
        }
    }

    private static func makeDemoIdeas() -> [Idea] {
        let now = Date()
        let calendar = Calendar.current

        return [
            Idea(
                title: "Sunset Picnic in the Park",
                description: "Pack a blanket, snacks, and your favorite drinks. Find a quiet spot and watch the sunset together.",
                category: .romantic,
                budget: .low,
                timeRequired: 90,
                isFavorite: true,
                seasonTags: [.outdoor, .summer],
                setting: .outdoor,
                activityLevel: .relaxed
            ),
            Idea(
                title: "Cook a New Recipe Together",
                description: "Pick a cuisine you've never tried, shop for ingredients together, and cook side by side.",
                category: .cozy,
                budget: .medium,
                timeRequired: 120,
                isFavorite: true,
                seasonTags: [.indoor, .rainyDay],
                setting: .indoor,
                activityLevel: .moderate
            ),
            Idea(
                title: "Coffee Walk",
                description: "Grab coffee to-go and stroll through a scenic neighborhood for 20 minutes.",
                category: .spontaneous,
                budget: .low,
                timeRequired: 20,
                isFavorite: false,
                seasonTags: [.outdoor, .spring],
                setting: .outdoor,
                activityLevel: .relaxed,
                jarOwner: .partner1
            ),
            Idea(
                title: "Morning Hike & Coffee",
                description: "Start early with a scenic trail hike, then reward yourselves at a cozy café.",
                category: .active,
                budget: .low,
                timeRequired: 150,
                seasonTags: [.outdoor, .spring],
                setting: .outdoor,
                activityLevel: .active
            ),
            Idea(
                title: "Museum & Gallery Hop",
                description: "Visit a local museum, then discuss your favorite pieces over lunch.",
                category: .cultural,
                budget: .medium,
                timeRequired: 180,
                seasonTags: [.indoor, .rainyDay],
                setting: .indoor,
                activityLevel: .moderate
            ),
            Idea(
                title: "Food Truck Tour",
                description: "Try a small dish at each food truck stop and compare favorites.",
                category: .gastronomic,
                budget: .medium,
                timeRequired: 120,
                isFavorite: true,
                seasonTags: [.outdoor, .summer],
                setting: .outdoor,
                activityLevel: .moderate,
                jarOwner: .partner2
            ),
            Idea(
                title: "Spontaneous Road Trip",
                description: "Pick a direction, drive for an hour, and explore a new town.",
                category: .spontaneous,
                budget: .medium,
                timeRequired: 240,
                seasonTags: [.outdoor, .fall],
                setting: .outdoor,
                activityLevel: .active
            ),
            Idea(
                title: "Stargazing Night",
                description: "Drive away from city lights and identify constellations together.",
                category: .romantic,
                budget: .low,
                timeRequired: 120,
                seasonTags: [.outdoor, .summer],
                setting: .outdoor,
                activityLevel: .relaxed,
                jarOwner: .partner1
            ),
            Idea(
                title: "Home Spa Evening",
                description: "Face masks, candles, relaxing music, and herbal tea at home.",
                category: .relax,
                budget: .low,
                timeRequired: 90,
                seasonTags: [.indoor, .rainyDay, .winter],
                setting: .indoor,
                activityLevel: .relaxed
            ),
            Idea(
                title: "Kayaking Adventure",
                description: "Rent kayaks and paddle along a calm lake or river.",
                category: .adventure,
                budget: .high,
                timeRequired: 180,
                seasonTags: [.outdoor, .summer],
                setting: .outdoor,
                activityLevel: .active
            ),
            Idea(
                title: "Board Game Marathon",
                description: "Pick three board games, order takeout, and compete for champion.",
                category: .cozy,
                budget: .low,
                timeRequired: 180,
                isUsed: true,
                createdAt: calendar.date(byAdding: .day, value: -14, to: now) ?? now,
                usedDate: calendar.date(byAdding: .day, value: -7, to: now),
                seasonTags: [.indoor, .rainyDay],
                setting: .indoor,
                activityLevel: .relaxed
            ),
            Idea(
                title: "Jazz Club Night",
                description: "Enjoy live music at a local jazz club and share dessert between sets.",
                category: .cultural,
                budget: .high,
                timeRequired: 150,
                isFavorite: true,
                isUsed: true,
                createdAt: calendar.date(byAdding: .day, value: -21, to: now) ?? now,
                usedDate: calendar.date(byAdding: .day, value: -3, to: now),
                seasonTags: [.indoor, .fall],
                setting: .indoor,
                activityLevel: .moderate
            ),
            Idea(
                title: "Farmers Market Brunch",
                description: "Browse fresh produce, then cook brunch with your finds.",
                category: .gastronomic,
                budget: .medium,
                timeRequired: 120,
                seasonTags: [.outdoor, .spring],
                setting: .both,
                activityLevel: .moderate
            ),
            Idea(
                title: "Bookstore Browse",
                description: "Pick a book for each other in 15 minutes, then read the first chapter at a café.",
                category: .cozy,
                budget: .low,
                timeRequired: 30,
                seasonTags: [.indoor, .rainyDay],
                setting: .both,
                activityLevel: .relaxed,
                jarOwner: .partner2
            ),
            Idea(
                title: "Ice Cream Sunset",
                description: "Grab ice cream and watch the sky change colors from a rooftop or hill.",
                category: .romantic,
                budget: .low,
                timeRequired: 25,
                seasonTags: [.outdoor, .summer],
                setting: .outdoor,
                activityLevel: .relaxed
            )
        ]
    }

    private static func makeDemoHistory(for ideas: [Idea]) -> [HistoryEntry] {
        ideas.filter(\.isUsed).compactMap { idea in
            guard let usedDate = idea.usedDate else { return nil }
            return HistoryEntry(
                ideaId: idea.id,
                ideaTitle: idea.title,
                date: usedDate,
                rating: idea.title == "Jazz Club Night" ? 5 : 4,
                reflection: idea.title == "Jazz Club Night"
                    ? "Amazing atmosphere and live music. We danced!"
                    : "Fun evening, would do again.",
                wouldRepeat: true
            )
        }
    }
}
