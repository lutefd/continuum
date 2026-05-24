#if os(iOS)
import Foundation
import HealthKit

struct HealthKitService {
    private let healthStore = HKHealthStore()

    var isHealthDataAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestWorkoutReadAuthorization() async throws {
        guard isHealthDataAvailable else { throw HealthKitServiceError.unavailable }

        let readTypes: Set<HKObjectType> = [HKObjectType.workoutType()]

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: HealthKitServiceError.authorizationDenied)
                }
            }
        }
    }

    func fetchWorkouts(since startDate: Date) async throws -> [HKWorkout] {
        guard isHealthDataAvailable else { throw HealthKitServiceError.unavailable }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: [.strictStartDate])
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sort]) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: samples as? [HKWorkout] ?? [])
            }

            healthStore.execute(query)
        }
    }
}

enum HealthKitServiceError: LocalizedError {
    case unavailable
    case authorizationDenied

    var errorDescription: String? {
        switch self {
        case .unavailable:
            return "Health data is not available on this device."
        case .authorizationDenied:
            return "HealthKit permission was not granted."
        }
    }
}
#endif
