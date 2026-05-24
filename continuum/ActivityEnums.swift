import Foundation

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
