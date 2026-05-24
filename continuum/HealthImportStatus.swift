import Foundation

enum HealthImportStatus: Equatable {
    case idle
    case importing
    case imported(Int)
    case upToDate
    case unavailable
    case failed(String)

    var displayText: String {
        switch self {
        case .idle:
            return "Not imported"
        case .importing:
            return "Importing..."
        case .imported(let count):
            return "Imported \(count) logs"
        case .upToDate:
            return "Already up to date"
        case .unavailable:
            return "Unavailable"
        case .failed(let message):
            return message
        }
    }
}
