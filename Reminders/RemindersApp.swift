//
//  RemindersApp.swift
//  Reminders
//
//  Created by Imen Ksouri on 09/05/2023.
//

import SwiftUI

@main
struct RemindersApp: App {
    let dataManager = CoreDataManager.shared.persistenceController

    var body: some Scene {
        WindowGroup {
            HomeScreenView()
                .environment(\.managedObjectContext, dataManager.container.viewContext)
        }
    }
}
