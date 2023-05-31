//
//  ReminderViewModel.swift
//  Reminders
//
//  Created by Imen Ksouri on 27/05/2023.
//

import Foundation
import CoreData
import Combine

@MainActor
final class DisplayReminderViewModel: ObservableObject {
    @Published var dataManager: CoreDataManager
    @Published var reminders: [Reminder] = []

    var anyCancellable: AnyCancellable?

    init(dataManager: CoreDataManager = CoreDataManager.shared) {
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    var subtasks: [Subtask] {
        dataManager.subtasks
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            dataManager.delete(reminders[index])
        }
    }

    func delete(_ object: NSManagedObject) {
        dataManager.delete(object)
    }

    func move(from source: IndexSet, to destination: Int) {
        var reminders: [Reminder] = reminders.map { $0 }
        reminders.move(fromOffsets: source, toOffset: destination )
        for reverseIndex in stride(from: reminders.count - 1,
                                    through: 0,
                                    by: -1) {
            reminders[reverseIndex].order =
                Int16(reverseIndex)
        }
        dataManager.save()
    }
}
