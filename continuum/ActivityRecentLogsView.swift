import SwiftUI

struct ActivityRecentLogsView: View {
    let logs: [ActivityLog]

    var body: some View {
        if logs.isEmpty {
            ContentUnavailableView("No logs yet", systemImage: "calendar.badge.plus", description: Text("Log this activity to start tracking progress."))
        } else {
            ForEach(logs.prefix(10)) { log in
                VStack(alignment: .leading, spacing: 3) {
                    Text(log.startedAt, format: .dateTime.weekday(.abbreviated).month().day().hour().minute())
                    Text(log.source.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
