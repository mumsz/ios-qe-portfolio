import SwiftUI
import SwiftData

struct AddMemberView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var age = 5
    @State private var selectedEmoji = "👤"
    @State private var selectedColor = "#5856D6"
    @State private var errorMessage = ""

    let emojiOptions = ["👦🏽","👧🏽","👩🏽","👨🏽","👶🏽","🧒🏽","👴🏽","👵🏽"]
    let colorOptions = ["#5856D6","#FF3B30","#FF9500","#34C759","#007AFF","#AF52DE"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Full name", text: $name)
                }

                Section("Age") {
                    Stepper("\(age) years old", value: $age, in: 1...100)
                }

                Section("Emoji") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                        ForEach(emojiOptions, id: \.self) { emoji in
                            Text(emoji)
                                .font(.largeTitle)
                                .padding(8)
                                .background(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .onTapGesture { selectedEmoji = emoji }
                        }
                    }
                }

                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6)) {
                        ForEach(colorOptions, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle().stroke(Color.primary, lineWidth: selectedColor == hex ? 3 : 0)
                                )
                                .onTapGesture { selectedColor = hex }
                        }
                    }
                }

                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Add Member")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif

            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { saveMember() }
                }
            }
        }
    }

    private func saveMember() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            errorMessage = "Name cannot be empty"
            return
        }
        let member = Member(name: trimmed, age: age, colorHex: selectedColor, emoji: selectedEmoji)
        context.insert(member)
        dismiss()
    }
}
