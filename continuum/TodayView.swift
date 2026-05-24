import SwiftUI

struct TodayView: View {
    let activities: [Activity]
    let logs: [ActivityLog]
    let logActivity: (Activity) -> Void

    private let summaryProvider = ActivityStreakSummaryProvider()

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(Date.now, format: .dateTime.weekday(.wide).month(.wide).day())
                        .font(.headline)
                    Text("\(completedTodayCount) of \(activities.count) activities logged today")
                        .font(.title3.weight(.semibold))
                }
                .padding(.vertical, 6)
            }

            Section("Due Today") {
                if activities.isEmpty {
                    ContentUnavailableView("No activities yet", systemImage: "square.grid.2x2", description: Text("Create an activity to start building your continuum."))
                } else {
                    ForEach(activities) { activity in
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

    private var completedTodayCount: Int {
        activities.filter(isLoggedToday).count
    }

    private func isLoggedToday(_ activity: Activity) -> Bool {
        logs.contains { log in
            log.activityId == activity.id && Calendar.current.isDateInToday(log.startedAt)
        }
    }
}
