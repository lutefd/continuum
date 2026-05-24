import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    let isLoggedToday: Bool
    let streakSummary: StreakSummary?
    let logActivity: (Activity) -> Void

    private let ruleDescription = StreakRuleDescription()

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: activity.icon)
                .font(.title3)
                .frame(width: 32, height: 32)
                .foregroundStyle(.tint)

            VStack(alignment: .leading) {
                Text(activity.name)
                    .font(.headline)
                Text(ruleDescription.text(for: activity.streakRule))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(statusText)
                    .font(.caption)
                    .foregroundStyle(isLoggedToday ? .green : .secondary)
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

    private var statusText: String {
        guard let streakSummary else {
            return isLoggedToday ? "Logged today" : "Not logged today"
        }

        let progress = streakSummary.periodProgress.formatted(.number.precision(.fractionLength(0...1)))
        let remaining = streakSummary.remainingToCompletePeriod.formatted(.number.precision(.fractionLength(0...1)))
        return "Streak: \(streakSummary.currentStreak) · Progress: \(progress) · Remaining: \(remaining)"
    }
}
