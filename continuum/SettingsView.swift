import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    let activities: [Activity]
    let logs: [ActivityLog]
    @State private var healthImportStatus: HealthImportStatus = .idle

    private let importCoordinator = HealthKitImportCoordinator()

    var body: some View {
        List {
            Section("Data") {
                LabeledContent("Activities", value: activities.count.formatted())
                LabeledContent("Logs", value: logs.count.formatted())
                LabeledContent("iCloud Sync", value: "Not configured")
            }

            Section("HealthKit") {
                LabeledContent("Status", value: healthImportStatus.displayText)

#if os(iOS)
                Button {
                    Task { await importHealthWorkouts() }
                } label: {
                    Label("Import Last 90 Days", systemImage: "heart.text.square")
                }
                .disabled(healthImportStatus == .importing)
#else
                Text("HealthKit imports run on iPhone. Synced logs will appear here through iCloud later.")
                    .foregroundStyle(.secondary)
#endif
            }
        }
    }

#if os(iOS)
    private func importHealthWorkouts() async {
        healthImportStatus = .importing

        do {
            let insertedCount = try await importCoordinator.importRecentWorkouts(
                activities: activities,
                logs: logs,
                modelContext: modelContext
            )
            healthImportStatus = .imported(insertedCount)
        } catch {
            healthImportStatus = .failed(error.localizedDescription)
        }
    }
#endif
}
