import Foundation
import SwiftData

@Model
class ChoreTask {
    var title: String
    var assignedMemberName: String
    var dueDate: Date
    var isComplete: Bool
    var priority: String

    init(title: String, assignedMemberName: String, dueDate: Date, isComplete: Bool = false, priority: String = "medium") {
        self.title = title
        self.assignedMemberName = assignedMemberName
        self.dueDate = dueDate
        self.isComplete = isComplete
        self.priority = priority
    }
}
