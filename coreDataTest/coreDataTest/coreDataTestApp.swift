//
//  coreDataTestApp.swift
//  coreDataTest
//
//  Created by Kaua Miguel on 11/08/23.
//

import SwiftUI

@main
struct coreDataTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
