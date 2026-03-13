import SwiftUI

struct TaskRowView: View {
    let task: ChoreTask

    var priorityColor: Color {
        switch Priority(rawValue: task.priority) {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        case .none: return .gray
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 3)
                .fill(priorityColor)
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isComplete)
                    .foregroundStyle(task.isComplete ? .secondary : .primary)

                HStack(spacing: 8) {
                    Text(task.assignedMemberName)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("·")
                        .foregroundStyle(.secondary)

                    Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("·")
                        .foregroundStyle(.secondary)

                    Text(Priority(rawValue: task.priority)?.label ?? "")
                        .font(.caption)
                        .foregroundStyle(priorityColor)
                }
            }

            Spacer()

            Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isComplete ? .green : .secondary)
                .font(.title2)
        }
        .padding(.vertical, 4)
        .opacity(task.isComplete ? 0.6 : 1.0)
    }
}
