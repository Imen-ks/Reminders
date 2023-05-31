//
//  ReminderRowViewModel.swift
//  Reminders
//
//  Created by Imen Ksouri on 30/05/2023.
//

import Foundation
import CoreData
import Combine

@MainActor
final class ReminderRowViewModel: ObservableObject {
    @Published var dataManager: CoreDataManager
    @Published var reminderTitle: String?
    @Published var notes: String?
    @Published var subtaskTitle: String?
    @Published var reminder: Reminder?
    @Published var subtask: Subtask?

    var anyCancellable: AnyCancellable?

    init(dataManager: CoreDataManager = CoreDataManager.shared, reminder: Reminder? = nil, subtask: Subtask? = nil) {
        self.dataManager = dataManager
        if let reminder = reminder {
            self.reminder = reminder
            self.reminderTitle = reminder.title
            self.notes = reminder.notes
        }
        if let subtask = subtask {
            self.subtask = subtask
            self.subtaskTitle = subtask.title
        }
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    func getPictures() -> [Picture] {
        if let reminder = reminder {
            return dataManager.getPictures(in: reminder)
        } else {
            return [Picture]()
        }
    }

    func delete(_ object: NSManagedObject) {
        dataManager.delete(object)
    }

    func toggleCompleted() {
        reminder?.isCompleted.toggle()
        dataManager.save()
    }

    func toggleFlagged() {
        reminder?.isFlagged.toggle()
        dataManager.save()
    }

    func updateReminder(title: String) {
        if let reminder = reminder {
            dataManager.updateReminder(reminder: reminder, title: title)
        }
    }

    func updateReminder(notes: String) {
        if let reminder = reminder {
            dataManager.updateReminder(reminder: reminder, notes: notes)
        }
    }

    func updateSubtask(title: String) {
        if let subtask = subtask {
            dataManager.updateSubtask(subtask: subtask, title: title)
        }
    }
}
