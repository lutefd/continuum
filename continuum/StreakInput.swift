import Foundation

struct StreakInput {
    let activity: Activity
    let logs: [ActivityLog]
    let rule: StreakRule
    let calendar: Calendar
    let now: Date
}
