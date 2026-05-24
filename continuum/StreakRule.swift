import Foundation
import SwiftData

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
