import Foundation

struct ImportedActivityLog {
    let activityName: String
    let category: ActivityCategory
    let icon: String
    let colorName: String
    let startedAt: Date
    let endedAt: Date?
    let durationSeconds: Int?
    let quantity: Double?
    let unit: ActivityUnit?
    let source: ActivityLogSource
    let externalSourceId: String
}
