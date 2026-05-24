import Foundation
import SwiftData

@Model
final class ActivityLog {
    var id: UUID
    var activityId: UUID
    var startedAt: Date
    var endedAt: Date?
    var durationSeconds: Int?
    var quantity: Double?
    var unit: ActivityUnit?
    var source: ActivityLogSource
    var externalSourceId: String?
    var note: String?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        activityId: UUID,
        startedAt: Date = Date(),
        endedAt: Date? = nil,
        durationSeconds: Int? = nil,
        quantity: Double? = nil,
        unit: ActivityUnit? = nil,
        source: ActivityLogSource = .manual,
        externalSourceId: String? = nil,
        note: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.activityId = activityId
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.durationSeconds = durationSeconds
        self.quantity = quantity
        self.unit = unit
        self.source = source
        self.externalSourceId = externalSourceId
        self.note = note
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
