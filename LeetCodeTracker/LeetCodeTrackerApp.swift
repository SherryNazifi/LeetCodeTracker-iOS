//
//  LeetCodeTrackerApp.swift
//  LeetCodeTracker
//
//  Created by Shahrzad Nazifi on 1/6/26.
//

import SwiftUI

@main
struct LeetCodeTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
