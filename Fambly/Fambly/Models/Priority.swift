import Foundation

enum Priority: String, CaseIterable, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"

    var label: String {
        rawValue.capitalized
    }

    var sortOrder: Int {
        switch self {
        case .high: return 0
        case .medium: return 1
        case .low: return 2
        }
    }
}
