import SwiftUI
import SwiftData

@main
struct FamblyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Member.self, ChoreTask.self])
        }
#if os(macOS)
        .windowResizability(.contentSize)
        .defaultSize(width: 900, height: 600)
#endif
    }
}
