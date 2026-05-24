import Foundation

struct ActivityStreakSummaryProvider {
    private let engine = StreakEngine()

    func summary(for activity: Activity, logs: [ActivityLog], calendar: Calendar = .current, now: Date = .now) -> StreakSummary? {
        guard let rule = activity.streakRule else { return nil }
        return engine.summarize(.init(activity: activity, logs: logs, rule: rule, calendar: calendar, now: now))
    }
}
