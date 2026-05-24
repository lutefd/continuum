import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    let isLoggedToday: Bool
    let logActivity: (Activity) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: activity.icon)
                .font(.title3)
                .frame(width: 32, height: 32)
                .foregroundStyle(.tint)

            VStack(alignment: .leading) {
                Text(activity.name)
                    .font(.headline)
                Text(isLoggedToday ? "Logged today" : "Not logged today")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(isLoggedToday ? "Logged" : "Log") {
                logActivity(activity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoggedToday)
        }
        .padding(.vertical, 4)
    }
}
