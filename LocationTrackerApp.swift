//
//  LocationTrackerApp.swift
//  LocationTracker
//
//  Created by Opdyke, Connor L. on 7/15/25.
//

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
