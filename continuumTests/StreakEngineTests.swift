import Foundation
import Testing
@testable import continuum

struct StreakEngineTests {
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calendar.firstWeekday = 2
        return calendar
    }

    @Test @MainActor func dailyCompletionCountsOneLogPerDay() {
        let now = date(2026, 5, 20)
        let activity = Activity(name: "Running", category: .body, icon: "figure.run", colorName: "orange")
        let rule = StreakRule(activityId: activity.id, type: .dailyCompletion)
        let logs = [
            ActivityLog(activityId: activity.id, startedAt: date(2026, 5, 18)),
            ActivityLog(activityId: activity.id, startedAt: date(2026, 5, 19)),
            ActivityLog(activityId: activity.id, startedAt: date(2026, 5, 20))
        ]

        let summary = StreakEngine().summarize(.init(activity: activity, logs: logs, rule: rule, calendar: calendar, now: now))

        #expect(summary.currentStreak == 3)
        #expect(summary.longestStreak == 3)
        #expect(summary.completedToday)
    }

    @Test @MainActor func weeklyCountUsesCurrentLocaleWeek() {
        let now = date(2026, 5, 21)
        let activity = Activity(name: "Running", category: .body, icon: "figure.run", colorName: "orange")
        let rule = StreakRule(activityId: activity.id, type: .weeklyCount, targetCount: 3, period: .week)
        let logs = [
            ActivityLog(activityId: activity.id, startedAt: date(2026, 5, 18)),
            ActivityLog(activityId: activity.id, startedAt: date(2026, 5, 20))
        ]

        let summary = StreakEngine().summarize(.init(activity: activity, logs: logs, rule: rule, calendar: calendar, now: now))

        #expect(summary.completedThisWeek == false)
        #expect(summary.periodProgress == 2)
        #expect(summary.remainingToCompletePeriod == 1)
    }

    @Test @MainActor func targetValuePerDaySumsQuantities() {
        let now = date(2026, 5, 20)
        let activity = Activity(name: "Walking", category: .body, icon: "figure.walk", colorName: "mint")
        let rule = StreakRule(activityId: activity.id, type: .targetValuePerDay, targetValue: 8_000, targetUnit: .steps)
        let logs = [
            ActivityLog(activityId: activity.id, startedAt: date(2026, 5, 20, 8), quantity: 3_000, unit: .steps),
            ActivityLog(activityId: activity.id, startedAt: date(2026, 5, 20, 18), quantity: 5_500, unit: .steps)
        ]

        let summary = StreakEngine().summarize(.init(activity: activity, logs: logs, rule: rule, calendar: calendar, now: now))

        #expect(summary.completedToday)
        #expect(summary.periodProgress == 8_500)
        #expect(summary.remainingToCompletePeriod == 0)
    }

    @Test @MainActor func dedupesExternalSourceIds() {
        let now = date(2026, 5, 20)
        let activity = Activity(name: "Cycling", category: .body, icon: "figure.outdoor.cycle", colorName: "green")
        let rule = StreakRule(activityId: activity.id, type: .weeklyCount, targetCount: 2, period: .week)
        let logs = [
            ActivityLog(activityId: activity.id, startedAt: date(2026, 5, 19), source: .healthKitWorkout, externalSourceId: "workout-1"),
            ActivityLog(activityId: activity.id, startedAt: date(2026, 5, 19), source: .healthKitWorkout, externalSourceId: "workout-1")
        ]

        let summary = StreakEngine().summarize(.init(activity: activity, logs: logs, rule: rule, calendar: calendar, now: now))

        #expect(summary.periodProgress == 1)
        #expect(summary.completedThisWeek == false)
    }

    private func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int = 12) -> Date {
        DateComponents(calendar: calendar, timeZone: calendar.timeZone, year: year, month: month, day: day, hour: hour).date!
    }
}
