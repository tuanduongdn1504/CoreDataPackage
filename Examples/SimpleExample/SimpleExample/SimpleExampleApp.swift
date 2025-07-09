//
//  SimpleExampleApp.swift
//  SimpleExample
//
//  Created by Duong Tuan on 28/06/2025.
//

import SwiftUI
import CoreDataPackage

@main
struct SimpleExampleApp: App {
    // Get the managed object context from the shared persistent container.
    let viewContext = EcommerceDataManager.shared.mainContext
    
    var body: some Scene {
        WindowGroup {
            // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
            // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
            ContentView()
                .environment(\.managedObjectContext, viewContext)
        }
    }
}
