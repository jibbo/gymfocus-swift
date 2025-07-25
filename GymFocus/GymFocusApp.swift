//
//  GymFocusApp.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 14/07/25.
//

import SwiftUI
import SwiftData

@main
struct GymFocusApp: App {
    @StateObject private var settings = Settings()
    
    init() {
            // Large title
            UINavigationBar.appearance().largeTitleTextAttributes = [
                .font: UIFont(name: Theme.fontName, size: 36)!
            ]
            // Inline title
            UINavigationBar.appearance().titleTextAttributes = [
                .font: UIFont(name: Theme.fontName, size: 20)!
            ]
        }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
            // If container creation fails, try with in-memory storage as fallback
//            print("Failed to create persistent ModelContainer: \(error)")
//            let fallbackConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
//            do {
//                return try ModelContainer(for: schema, configurations: [fallbackConfiguration])
//            } catch {
//                fatalError("Could not create ModelContainer: \(error)")
//            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(settings)
    }
}

