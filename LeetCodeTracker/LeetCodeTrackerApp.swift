import SwiftUI

// Entry point of the app
// This is where the SwiftUI app lifecycle begins
@main
struct LeetCodeTrackerApp: App {

    var body: some Scene {

        // Main window scene for the app
        WindowGroup {

          // Root view of the application
          // All navigation and state flow starts from here
          ProblemListView()
        }
    }
}

