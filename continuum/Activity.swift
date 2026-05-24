import Foundation
import SwiftData

@Model
final class Activity {
    var id: UUID
    var name: String
    var category: ActivityCategory
    var icon: String
    var colorName: String
    var source: ActivitySource
    var createdAt: Date
    var updatedAt: Date
    var archivedAt: Date?

    @Relationship(deleteRule: .cascade)
    var logs: [ActivityLog]

    @Relationship(deleteRule: .cascade)
    var streakRule: StreakRule?

    init(
        id: UUID = UUID(),
        name: String,
        category: ActivityCategory,
        icon: String,
        colorName: String,
        source: ActivitySource = .manual,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        archivedAt: Date? = nil,
        logs: [ActivityLog] = [],
        streakRule: StreakRule? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.icon = icon
        self.colorName = colorName
        self.source = source
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.archivedAt = archivedAt
        self.logs = logs
        self.streakRule = streakRule
    }
}
