import Foundation

struct StreakRuleDescription {
    func text(for rule: StreakRule?) -> String {
        guard let rule else { return "No streak rule" }

        switch rule.type {
        case .dailyCompletion:
            return "Daily completion"
        case .weeklyCount:
            return "\(rule.targetCount ?? 1)x per week"
        case .scheduledWeekdays:
            return scheduledWeekdaysText(rule.scheduledWeekdays)
        case .monthlyCount:
            return "\(rule.targetCount ?? 1)x per month"
        case .targetValuePerDay:
            return "\(format(rule.targetValue ?? 1)) \(unitText(rule.targetUnit)) per day"
        case .targetValuePerWeek:
            return "\(format(rule.targetValue ?? 1)) \(unitText(rule.targetUnit)) per week"
        }
    }

    private func scheduledWeekdaysText(_ weekdays: [Int]) -> String {
        guard !weekdays.isEmpty else { return "Scheduled days" }

        let symbols = Calendar.current.shortWeekdaySymbols
        let names = weekdays.sorted().compactMap { weekday -> String? in
            guard symbols.indices.contains(weekday - 1) else { return nil }
            return symbols[weekday - 1]
        }

        return names.joined(separator: ", ")
    }

    private func unitText(_ unit: ActivityUnit?) -> String {
        unit?.rawValue ?? ActivityUnit.count.rawValue
    }

    private func format(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...1)))
    }
}
