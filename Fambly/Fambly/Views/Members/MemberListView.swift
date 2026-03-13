import SwiftUI
import SwiftData

struct MemberListView: View {
    @Environment(\.modelContext) private var context
    @Query private var members: [Member]
    @State private var showAddMember = false

    var body: some View {
        NavigationStack {
            List {
                if members.isEmpty {
                    ContentUnavailableView(
                        "No Members Yet",
                        systemImage: "person.3",
                        description: Text("Add your family members to get started")
                    )
                } else {
                    ForEach(members) { member in
                        MemberRowView(member: member)
                    }
                    .onDelete(perform: deleteMembers)
                }
            }
            .navigationTitle("Family")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddMember = true
                    } label: {
                        Image(systemName: "person.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $showAddMember) {
                AddMemberView()
            }
        }
    }

    private func deleteMembers(at offsets: IndexSet) {
        for index in offsets {
            context.delete(members[index])
        }
    }
}
