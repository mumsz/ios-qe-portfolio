import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }

            MemberListView()
                .tabItem {
                    Label("Family", systemImage: "person.3.fill")
                }

            TaskListView()
                .tabItem {
                    Label("Chores", systemImage: "checkmark.circle.fill")
                }
        }
    }
}
