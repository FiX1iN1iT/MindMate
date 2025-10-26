//
//  MindMateApp.swift
//  MindMate
//
//  Created by Alexander on 22.10.2025.
//

import SwiftData
import SwiftUI

@main
struct MindMateApp: App {

    // MARK: Private Properties

    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([Note.self, CheckListItem.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            if let nsError = error as NSError? {
                fatalError("Error creating ModelContainer: \(nsError), \(nsError.userInfo)")
            } else {
                fatalError("Error creating ModelContainer: \(error)")
            }
        }
    }()

    // MARK: Body

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
