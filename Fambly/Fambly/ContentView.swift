import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
#if os(iOS)
        iPhoneLayout()
#else
        macLayout()
#endif
    }
}

// MARK: - iPhone Layout
private struct iPhoneLayout: View {
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

// MARK: - Mac Layout
private struct macLayout: View {
    @State private var selectedTab: Int? = 0

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                Label("Dashboard", systemImage: "house.fill")
                    .tag(0)
                Label("Family", systemImage: "person.3.fill")
                    .tag(1)
                Label("Chores", systemImage: "checkmark.circle.fill")
                    .tag(2)
            }
            .navigationTitle("Fambly")
        } detail: {
            switch selectedTab {
            case 0: DashboardView()
            case 1: MemberListView()
            case 2: TaskListView()
            default: DashboardView()
            }

        }
    }
}
