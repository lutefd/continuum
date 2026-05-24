import Foundation

struct StreakEngine {
    func summarize(_ input: StreakInput) -> StreakSummary {
        let logs = deduped(input.logs.filter { $0.activityId == input.activity.id })
        let completedDates = completedDayStarts(logs: logs, rule: input.rule, calendar: input.calendar)
        let today = input.calendar.startOfDay(for: input.now)
        let periodProgress = progress(logs: logs, rule: input.rule, calendar: input.calendar, now: input.now)
        let target = targetForCurrentPeriod(rule: input.rule)

        return StreakSummary(
            currentStreak: currentDailyStreak(completedDates: completedDates, calendar: input.calendar, today: today),
            longestStreak: longestDailyStreak(completedDates: completedDates, calendar: input.calendar),
            completedToday: completedDates.contains(today),
            completedThisWeek: isCompletedThisWeek(logs: logs, rule: input.rule, calendar: input.calendar, now: input.now),
            periodProgress: periodProgress,
            remainingToCompletePeriod: max(0, target - periodProgress),
            lastCompletedDate: completedDates.max()
        )
    }

    private func deduped(_ logs: [ActivityLog]) -> [ActivityLog] {
        var externalIds = Set<String>()

        return logs.filter { log in
            guard let externalSourceId = log.externalSourceId else { return true }
            return externalIds.insert(externalSourceId).inserted
        }
    }

    private func completedDayStarts(logs: [ActivityLog], rule: StreakRule, calendar: Calendar) -> Set<Date> {
        switch rule.type {
        case .targetValuePerDay:
            let grouped = Dictionary(grouping: logs) { calendar.startOfDay(for: $0.startedAt) }
            return Set(grouped.compactMap { day, logs in
                totalValue(logs) >= (rule.targetValue ?? 1) ? day : nil
            })
        default:
            return Set(logs.map { calendar.startOfDay(for: $0.startedAt) })
        }
    }

    private func currentDailyStreak(completedDates: Set<Date>, calendar: Calendar, today: Date) -> Int {
        var date = completedDates.contains(today) ? today : calendar.date(byAdding: .day, value: -1, to: today) ?? today
        var count = 0

        while completedDates.contains(date) {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: date) else { break }
            date = previous
        }

        return count
    }

    private func longestDailyStreak(completedDates: Set<Date>, calendar: Calendar) -> Int {
        var longest = 0
        var current = 0
        var previous: Date?

        for date in completedDates.sorted() {
            if let previous, calendar.dateComponents([.day], from: previous, to: date).day == 1 {
                current += 1
            } else {
                current = 1
            }

            longest = max(longest, current)
            previous = date
        }

        return longest
    }

    private func isCompletedThisWeek(logs: [ActivityLog], rule: StreakRule, calendar: Calendar, now: Date) -> Bool {
        let weekLogs = logsInCurrentWeek(logs, calendar: calendar, now: now)

        switch rule.type {
        case .weeklyCount:
            return weekLogs.count >= (rule.targetCount ?? 1)
        case .scheduledWeekdays:
            let todayWeekday = calendar.component(.weekday, from: now)
            let dueWeekdays = rule.scheduledWeekdays.filter { $0 <= todayWeekday }
            let completedWeekdays = Set(weekLogs.map { calendar.component(.weekday, from: $0.startedAt) })
            return !dueWeekdays.isEmpty && Set(dueWeekdays).isSubset(of: completedWeekdays)
        case .targetValuePerWeek:
            return totalValue(weekLogs) >= (rule.targetValue ?? 1)
        default:
            return !weekLogs.isEmpty
        }
    }

    private func progress(logs: [ActivityLog], rule: StreakRule, calendar: Calendar, now: Date) -> Double {
        switch rule.type {
        case .weeklyCount:
            return Double(logsInCurrentWeek(logs, calendar: calendar, now: now).count)
        case .targetValuePerDay:
            return totalValue(logs.filter { calendar.isDate($0.startedAt, inSameDayAs: now) })
        case .targetValuePerWeek:
            return totalValue(logsInCurrentWeek(logs, calendar: calendar, now: now))
        default:
            return logs.contains { calendar.isDate($0.startedAt, inSameDayAs: now) } ? 1 : 0
        }
    }

    private func targetForCurrentPeriod(rule: StreakRule) -> Double {
        switch rule.type {
        case .weeklyCount, .monthlyCount:
            return Double(rule.targetCount ?? 1)
        case .targetValuePerDay, .targetValuePerWeek:
            return rule.targetValue ?? 1
        case .scheduledWeekdays:
            return Double(max(rule.scheduledWeekdays.count, 1))
        case .dailyCompletion:
            return 1
        }
    }

    private func logsInCurrentWeek(_ logs: [ActivityLog], calendar: Calendar, now: Date) -> [ActivityLog] {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: now) else { return [] }
        return logs.filter { week.contains($0.startedAt) }
    }

    private func totalValue(_ logs: [ActivityLog]) -> Double {
        logs.reduce(0) { total, log in
            total + (log.quantity ?? Double(log.durationSeconds ?? 0) / 60)
        }
    }
}
