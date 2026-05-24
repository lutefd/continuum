#if os(iOS)
import Foundation
import HealthKit

struct HealthKitWorkoutMapper {
    func map(_ workout: HKWorkout) -> ImportedActivityLog? {
        guard let metadata = metadata(for: workout.workoutActivityType) else { return nil }

        return ImportedActivityLog(
            activityName: metadata.name,
            category: metadata.category,
            icon: metadata.icon,
            colorName: metadata.colorName,
            startedAt: workout.startDate,
            endedAt: workout.endDate,
            durationSeconds: Int(workout.duration.rounded()),
            quantity: workout.duration / 60,
            unit: .minutes,
            source: .healthKitWorkout,
            externalSourceId: workout.uuid.uuidString
        )
    }

    private func metadata(for type: HKWorkoutActivityType) -> WorkoutMetadata? {
        switch type {
        case .running:
            return .init(name: "Running", category: .body, icon: "figure.run", colorName: "orange")
        case .walking:
            return .init(name: "Walking", category: .body, icon: "figure.walk", colorName: "mint")
        case .cycling:
            return .init(name: "Cycling", category: .body, icon: "figure.outdoor.cycle", colorName: "green")
        case .swimming:
            return .init(name: "Swimming", category: .body, icon: "figure.pool.swim", colorName: "blue")
        case .traditionalStrengthTraining, .functionalStrengthTraining:
            return .init(name: "Gym", category: .body, icon: "dumbbell", colorName: "red")
        case .tennis:
            return .init(name: "Tennis", category: .body, icon: "tennis.racket", colorName: "yellow")
        case .yoga:
            return .init(name: "Yoga", category: .recovery, icon: "figure.yoga", colorName: "purple")
        default:
            return nil
        }
    }
}

private struct WorkoutMetadata {
    let name: String
    let category: ActivityCategory
    let icon: String
    let colorName: String
}
#endif
