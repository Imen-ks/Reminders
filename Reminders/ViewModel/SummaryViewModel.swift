//
//  SummaryViewModel.swift
//  Reminders
//
//  Created by Imen Ksouri on 31/05/2023.
//

import Foundation
import Combine

@MainActor
final class SummaryViewModel: ObservableObject {
    @Published var dataManager: CoreDataManager
    @Published var searchText: String = ""
    @Published var cards: [Card] = [
        Card(icon: "clock.badge.fill", color: .blue,
             keyPath: \Self.todayReminders,
             predicate: .today),
        Card(icon: "calendar", color: .red,
             keyPath: \Self.scheduledReminders,
             predicate: .scheduled),
        Card(icon: "tray.fill", color: .black,
             keyPath: \Self.allReminders,
             predicate: .all),
        Card(icon: "flag.fill", color: .orange,
             keyPath: \Self.flaggedReminders,
             predicate: .flagged),
        Card(icon: "checkmark", color: .gray,
             keyPath: \Self.completedReminders,
             predicate: .completed)
    ]

    var anyCancellable: AnyCancellable?

    init(dataManager: CoreDataManager = CoreDataManager.shared) {
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    var allReminders: [Reminder] {
        dataManager.allReminders
    }

    var todayReminders: [Reminder] {
        dataManager.todayReminders
    }

    var scheduledReminders: [Reminder] {
        dataManager.scheduledReminders
    }

    var flaggedReminders: [Reminder] {
        dataManager.flaggedReminders
    }

    var completedReminders: [Reminder] {
        dataManager.completedReminders
    }

    var subtasks: [Subtask] {
        dataManager.subtasks
    }
}
