import SwiftUI
import SwiftData

@main
struct FamblyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Member.self, ChoreTask.self])
    }
}
