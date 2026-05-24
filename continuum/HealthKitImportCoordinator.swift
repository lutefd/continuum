import Foundation
import SwiftData

@MainActor
struct HealthKitImportCoordinator {
#if os(iOS)
    private let service = HealthKitService()
    private let mapper = HealthKitWorkoutMapper()
#endif

    func importRecentWorkouts(activities: [Activity], logs: [ActivityLog], modelContext: ModelContext) async throws -> Int {
#if os(iOS)
        guard service.isHealthDataAvailable else { throw HealthKitServiceError.unavailable }

        try await service.requestWorkoutReadAuthorization()

        let startDate = Calendar.current.date(byAdding: .day, value: -90, to: .now) ?? .now
        let importedLogs = try await service.fetchWorkouts(since: startDate).compactMap(mapper.map)
        let existingExternalIds = Set(logs.compactMap(\.externalSourceId))
        var activitiesByName = Dictionary(uniqueKeysWithValues: activities.map { ($0.name, $0) })
        var insertedCount = 0

        for importedLog in importedLogs where !existingExternalIds.contains(importedLog.externalSourceId) {
            let activity = activitiesByName[importedLog.activityName] ?? createActivity(from: importedLog, modelContext: modelContext)
            activitiesByName[activity.name] = activity
            activity.logs.append(makeActivityLog(from: importedLog, activityId: activity.id))
            activity.updatedAt = .now
            insertedCount += 1
        }

        return insertedCount
#else
        return 0
#endif
    }

#if os(iOS)
    private func createActivity(from importedLog: ImportedActivityLog, modelContext: ModelContext) -> Activity {
        let activity = Activity(
            name: importedLog.activityName,
            category: importedLog.category,
            icon: importedLog.icon,
            colorName: importedLog.colorName,
            source: .healthKit
        )
        activity.streakRule = StreakRule(activityId: activity.id, type: .weeklyCount, targetCount: 1, period: .week)
        modelContext.insert(activity)
        return activity
    }

    private func makeActivityLog(from importedLog: ImportedActivityLog, activityId: UUID) -> ActivityLog {
        ActivityLog(
            activityId: activityId,
            startedAt: importedLog.startedAt,
            endedAt: importedLog.endedAt,
            durationSeconds: importedLog.durationSeconds,
            quantity: importedLog.quantity,
            unit: importedLog.unit,
            source: importedLog.source,
            externalSourceId: importedLog.externalSourceId
        )
    }
#endif
}
