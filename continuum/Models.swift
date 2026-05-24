import Foundation
import SwiftData

enum ActivitySource: String, Codable, CaseIterable {
    case manual
    case healthKit
    case github
    case calendar
}

enum ActivityLogSource: String, Codable, CaseIterable {
    case manual
    case timer
    case healthKitWorkout
    case healthKitQuantity
    case importSource
}

enum ActivityCategory: String, Codable, CaseIterable, Identifiable {
    case body
    case mind
    case craft
    case work
    case social
    case recovery
    case other

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}

enum StreakRuleType: String, Codable, CaseIterable {
    case dailyCompletion
    case weeklyCount
    case scheduledWeekdays
    case monthlyCount
    case targetValuePerDay
    case targetValuePerWeek
}

enum StreakPeriod: String, Codable, CaseIterable {
    case day
    case week
    case month
}

enum ActivityUnit: String, Codable, CaseIterable {
    case count
    case minutes
    case hours
    case meters
    case kilometers
    case steps
    case calories
}

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

@Model
final class ActivityLog {
    var id: UUID
    var activityId: UUID
    var startedAt: Date
    var endedAt: Date?
    var durationSeconds: Int?
    var quantity: Double?
    var unit: ActivityUnit?
    var source: ActivityLogSource
    var externalSourceId: String?
    var note: String?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        activityId: UUID,
        startedAt: Date = Date(),
        endedAt: Date? = nil,
        durationSeconds: Int? = nil,
        quantity: Double? = nil,
        unit: ActivityUnit? = nil,
        source: ActivityLogSource = .manual,
        externalSourceId: String? = nil,
        note: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.activityId = activityId
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.durationSeconds = durationSeconds
        self.quantity = quantity
        self.unit = unit
        self.source = source
        self.externalSourceId = externalSourceId
        self.note = note
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@Model
final class StreakRule {
    var id: UUID
    var activityId: UUID
    var type: StreakRuleType
    var targetCount: Int?
    var targetValue: Double?
    var targetUnit: ActivityUnit?
    var scheduledWeekdays: [Int]
    var period: StreakPeriod
    var allowGraceDays: Int
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        activityId: UUID,
        type: StreakRuleType = .dailyCompletion,
        targetCount: Int? = nil,
        targetValue: Double? = nil,
        targetUnit: ActivityUnit? = nil,
        scheduledWeekdays: [Int] = [],
        period: StreakPeriod = .day,
        allowGraceDays: Int = 0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.activityId = activityId
        self.type = type
        self.targetCount = targetCount
        self.targetValue = targetValue
        self.targetUnit = targetUnit
        self.scheduledWeekdays = scheduledWeekdays
        self.period = period
        self.allowGraceDays = allowGraceDays
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
