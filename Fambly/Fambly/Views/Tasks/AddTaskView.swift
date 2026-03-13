import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var members: [Member]

    @State private var title = ""
    @State private var selectedMemberName = ""
    @State private var dueDate = Date()
    @State private var selectedPriority = Priority.medium
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    TextField("What needs to be done?", text: $title)
                }

                Section("Assign To") {
                    if members.isEmpty {
                        Text("Add family members first")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Member", selection: $selectedMemberName) {
                            Text("Select member").tag("")
                            ForEach(members) { member in
                                Text("\(member.emoji) \(member.name)")
                                    .tag(member.name)
                            }
                        }
                    }
                }

                Section("Due Date") {
                    DatePicker("Due", selection: $dueDate, displayedComponents: .date)
                }

                Section("Priority") {
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.label).tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Add Chore")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { saveTask() }
                }
            }
        }
    }

    private func saveTask() {
        let trimmed = title.trimmingCharacters(in: .whitespaces)

        guard !trimmed.isEmpty else {
            errorMessage = "Task title cannot be empty"
            return
        }

        guard !selectedMemberName.isEmpty else {
            errorMessage = "Please assign this task to a member"
            return
        }

        let task = ChoreTask(
            title: trimmed,
            assignedMemberName: selectedMemberName,
            dueDate: dueDate,
            priority: selectedPriority.rawValue
        )
        context.insert(task)
        dismiss()
    }
}
