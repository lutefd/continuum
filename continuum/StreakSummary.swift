import Foundation

struct StreakSummary: Equatable {
    let currentStreak: Int
    let longestStreak: Int
    let completedToday: Bool
    let completedThisWeek: Bool
    let periodProgress: Double
    let remainingToCompletePeriod: Double
    let lastCompletedDate: Date?
}
