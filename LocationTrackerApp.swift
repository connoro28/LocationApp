import SwiftUI
import FirebaseCore // Import Firebase

@main
struct LocationTrackerApp: App {
    
    // Add this initializer
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
