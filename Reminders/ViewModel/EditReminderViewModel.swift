//
//  EditReminderViewModel.swift
//  Reminders
//
//  Created by Imen Ksouri on 29/05/2023.
//

import Foundation
import CoreData
import Combine

@MainActor
final class EditReminderViewModel: ObservableObject {
    @Published var dataManager: CoreDataManager
    @Published var selectedList: ReminderList
    @Published var title = ""
    @Published var notes = ""
    @Published var isAddingDueDate = false
    @Published var isAddingDueHour = false
    @Published var dueDate: Date?
    @Published var dueHour: Date?
    @Published var tags = ""
    @Published var isFlagging = false
    @Published var priority = ReminderPriority.none
    @Published var pictures: [(id: UUID, data: Data)] = []
    @Published var storedPictures: [Picture]
    @Published var removedPictures: [Picture] = []
    @Published var subtasks: [String] = []
    @Published var storedSubtasks: [Subtask]
    @Published var removedSubtasks: [Subtask] = []
    @Published var updated: [Subtask] = []
    @Published var removed: [Subtask] = []
    @Published var added: [String] = []

    var anyCancellable: AnyCancellable?

    init(dataManager: CoreDataManager = CoreDataManager.shared, reminderList: ReminderList, reminder: Reminder) {
        self.dataManager = dataManager
        self.selectedList = reminderList
        self.title = reminder.title
        self.notes = reminder.notes
        self.isAddingDueDate = reminder.dueDate != nil
        self.isAddingDueHour = reminder.dueHour != nil
        self.dueDate = reminder.dueDate
        self.dueHour = reminder.dueHour
        self.isFlagging = reminder.isFlagged
        self.priority = ReminderPriority(rawValue: reminder.priority) ?? .none
        self.storedPictures = dataManager.getPictures(in: reminder)
        self.storedSubtasks = dataManager.getSubtasks(in: reminder)
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    func delete(_ object: NSManagedObject) {
        dataManager.delete(object)
    }

    func updateReminder(reminder: Reminder, list: ReminderList) {
        dataManager.updateReminder(reminder: reminder,
                                   title: title,
                                   notes: notes,
                                   dueDate: dueDate,
                                   dueHour: dueHour,
                                   priority: priority.rawValue,
                                   isFlagged: isFlagging,
                                   list: list,
                                   subtasks: subtasks,
                                   pictures: pictures)
    }
}
