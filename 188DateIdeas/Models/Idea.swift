import Foundation

struct Idea: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var category: Category
    var budget: Budget
    var timeRequired: Int
    var isFavorite: Bool
    var isUsed: Bool
    var createdAt: Date
    var usedDate: Date?
    var seasonTags: [SeasonTag]
    var setting: DateSetting
    var activityLevel: ActivityLevel
    var jarOwner: JarOwner?

    var isMicroDate: Bool { timeRequired <= 30 }

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        category: Category,
        budget: Budget,
        timeRequired: Int,
        isFavorite: Bool = false,
        isUsed: Bool = false,
        createdAt: Date = Date(),
        usedDate: Date? = nil,
        seasonTags: [SeasonTag] = [],
        setting: DateSetting = .both,
        activityLevel: ActivityLevel = .moderate,
        jarOwner: JarOwner? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.budget = budget
        self.timeRequired = timeRequired
        self.isFavorite = isFavorite
        self.isUsed = isUsed
        self.createdAt = createdAt
        self.usedDate = usedDate
        self.seasonTags = seasonTags
        self.setting = setting
        self.activityLevel = activityLevel
        self.jarOwner = jarOwner
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(Category.self, forKey: .category)
        budget = try container.decode(Budget.self, forKey: .budget)
        timeRequired = try container.decode(Int.self, forKey: .timeRequired)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        isUsed = try container.decode(Bool.self, forKey: .isUsed)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        usedDate = try container.decodeIfPresent(Date.self, forKey: .usedDate)
        seasonTags = try container.decodeIfPresent([SeasonTag].self, forKey: .seasonTags) ?? []
        setting = try container.decodeIfPresent(DateSetting.self, forKey: .setting) ?? .both
        activityLevel = try container.decodeIfPresent(ActivityLevel.self, forKey: .activityLevel) ?? .moderate
        jarOwner = try container.decodeIfPresent(JarOwner.self, forKey: .jarOwner)
    }
}
