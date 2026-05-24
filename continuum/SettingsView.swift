import SwiftUI

struct SettingsView: View {
    let activityCount: Int
    let logCount: Int

    var body: some View {
        List {
            Section("Data") {
                LabeledContent("Activities", value: activityCount.formatted())
                LabeledContent("Logs", value: logCount.formatted())
                LabeledContent("iCloud Sync", value: "Not configured")
                LabeledContent("HealthKit", value: "Not configured")
            }
        }
    }
}
