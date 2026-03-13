import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \ChoreTask.dueDate) private var tasks: [ChoreTask]
    @State private var showAddTask = false
    @State private var selectedFilter: FilterOption = .all

    enum FilterOption: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case completed = "Completed"
    }

    var filteredTasks: [ChoreTask] {
        switch selectedFilter {
        case .all: return tasks
        case .pending: return tasks.filter { !$0.isComplete }
        case .completed: return tasks.filter { $0.isComplete }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(FilterOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                List {
                    if filteredTasks.isEmpty {
                        ContentUnavailableView(
                            "No Tasks",
                            systemImage: "checkmark.circle",
                            description: Text("Add chores to get started")
                        )
                    } else {
                        ForEach(filteredTasks) { task in
                            TaskRowView(task: task)
                                .onTapGesture { toggleTask(task) }
                        }
                        .onDelete(perform: deleteTasks)
                    }
                }
            }
            .navigationTitle("Chores")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTask) {
                AddTaskView()
            }
        }
    }

    private func toggleTask(_ task: ChoreTask) {
        task.isComplete.toggle()
    }

    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            context.delete(filteredTasks[index])
        }
    }
}
