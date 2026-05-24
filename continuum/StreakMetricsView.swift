import SwiftUI

struct StreakMetricsView: View {
    let summary: StreakSummary

    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
            GridRow {
                metric("Current", value: summary.currentStreak.formatted())
                metric("Longest", value: summary.longestStreak.formatted())
            }

            GridRow {
                metric("Progress", value: summary.periodProgress.formatted(.number.precision(.fractionLength(0...1))))
                metric("Remaining", value: summary.remainingToCompletePeriod.formatted(.number.precision(.fractionLength(0...1))))
            }
        }
        .padding(.vertical, 6)
    }

    private func metric(_ title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.title3.weight(.semibold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
