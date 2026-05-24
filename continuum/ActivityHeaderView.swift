import SwiftUI

struct ActivityHeaderView: View {
    let activity: Activity
    let ruleText: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: activity.icon)
                .font(.largeTitle)
                .frame(width: 52, height: 52)
                .foregroundStyle(.tint)

            VStack(alignment: .leading, spacing: 4) {
                Text(activity.name)
                    .font(.title2.weight(.semibold))
                Text(ruleText)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
