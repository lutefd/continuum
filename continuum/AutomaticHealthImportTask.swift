import Foundation
import SwiftData

@MainActor
struct AutomaticHealthImportTask {
    private let coordinator = HealthKitImportCoordinator()

    func runIfAvailable(activities: [Activity], logs: [ActivityLog], modelContext: ModelContext) async {
#if os(iOS)
        do {
            _ = try await coordinator.importRecentWorkouts(activities: activities, logs: logs, modelContext: modelContext)
        } catch {
            // Automatic imports should never block app launch; Settings exposes explicit errors.
        }
#endif
    }
}
