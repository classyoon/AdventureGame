//
//  AdventureGameApp.swift
//  AdventureGame
//
//  Created by Conner Yoon on 11/17/24.
//

import SwiftUI
import SwiftData

@main
struct AdventureGameApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self, Tile.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TileListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
