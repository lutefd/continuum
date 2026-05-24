import SwiftUI

struct ActivityDetailView: View {
    let activity: Activity
    let logs: [ActivityLog]
    let logActivity: (Activity) -> Void

    private let ruleDescription = StreakRuleDescription()
    private let summaryProvider = ActivityStreakSummaryProvider()

    var body: some View {
        List {
            Section {
                ActivityHeaderView(activity: activity, ruleText: ruleDescription.text(for: activity.streakRule))
            }

            if let summary = summaryProvider.summary(for: activity, logs: logs) {
                Section("Streak") {
                    StreakMetricsView(summary: summary)
                }
            }

            Section("Quick Log") {
                Button {
                    logActivity(activity)
                } label: {
                    Label("Log Now", systemImage: "plus.circle.fill")
                }
            }

            Section("Recent Logs") {
                ActivityRecentLogsView(logs: activityLogs)
            }
        }
        .navigationTitle(activity.name)
    }

    private var activityLogs: [ActivityLog] {
        logs
            .filter { $0.activityId == activity.id }
            .sorted { $0.startedAt > $1.startedAt }
    }
}
