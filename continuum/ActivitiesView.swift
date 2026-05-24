import SwiftUI

struct ActivitiesView: View {
    let activities: [Activity]
    let logs: [ActivityLog]
    let logActivity: (Activity) -> Void

    private let summaryProvider = ActivityStreakSummaryProvider()

    var body: some View {
        List {
            ForEach(ActivityCategory.allCases) { category in
                let categoryActivities = activities.filter { $0.category == category }
                if !categoryActivities.isEmpty {
                    Section(category.displayName) {
                        ForEach(categoryActivities) { activity in
                            ActivityRow(
                                activity: activity,
                                isLoggedToday: isLoggedToday(activity),
                                streakSummary: summaryProvider.summary(for: activity, logs: logs),
                                logActivity: logActivity
                            )
                        }
                    }
                }
            }
        }
    }

    private func isLoggedToday(_ activity: Activity) -> Bool {
        logs.contains { log in
            log.activityId == activity.id && Calendar.current.isDateInToday(log.startedAt)
        }
    }
}
