import Foundation
import SwiftData

@Observable
class TaskViewModel {
    var tasks: [ChoreTask] = []
    var errorMessage: String?

    func addTask(title: String, assignedMemberName: String, dueDate: Date, priority: Priority, context: ModelContext) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)

        guard !trimmedTitle.isEmpty else {
            errorMessage = "Task title cannot be empty"
            return
        }

        guard !assignedMemberName.isEmpty else {
            errorMessage = "Task must be assigned to a member"
            return
        }

        let task = ChoreTask(
            title: trimmedTitle,
            assignedMemberName: assignedMemberName,
            dueDate: dueDate,
            isComplete: false,
            priority: priority.rawValue
        )
        context.insert(task)
        errorMessage = nil
    }

    func toggleComplete(_ task: ChoreTask) {
        task.isComplete.toggle()
    }

    func deleteTask(_ task: ChoreTask, context: ModelContext) {
        context.delete(task)
    }

    func tasksForMember(named name: String) -> [ChoreTask] {
        tasks.filter { $0.assignedMemberName == name }
    }

    func tasksSortedByPriority() -> [ChoreTask] {
        tasks.sorted {
            let p1 = Priority(rawValue: $0.priority)?.sortOrder ?? 99
            let p2 = Priority(rawValue: $1.priority)?.sortOrder ?? 99
            return p1 < p2
        }
    }
}
