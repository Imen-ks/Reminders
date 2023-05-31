//
//  CoreDataManager.swift
//  Reminders
//
//  Created by Imen Ksouri on 22/05/2023.
//

import Foundation
import CoreData
import UIKit

enum DataManagerType {
    case normal, preview, testing
}

class CoreDataManager: ObservableObject {
    var persistenceController: PersistenceController

    static let shared = CoreDataManager(type: .normal)
    static let preview = CoreDataManager(type: .preview)
    static let testing = CoreDataManager(type: .testing)

    @Published var reminderLists: [ReminderList] = []
    @Published var reminderTemplates: [ReminderList] = []
    @Published var allReminders: [Reminder] = []
    @Published var todayReminders: [Reminder] = []
    @Published var scheduledReminders: [Reminder] = []
    @Published var flaggedReminders: [Reminder] = []
    @Published var completedReminders: [Reminder] = []
    @Published var subtasks: [Subtask] = []
    @Published var pictures: [Picture] = []

    // swiftlint:disable:next function_body_length
    init(type: DataManagerType) {
        switch type {
        case .normal:
            persistenceController = PersistenceController()
        case .preview:
            persistenceController = PersistenceController(inMemory: true)
            let list = ReminderList(context: persistenceController.container.viewContext)
            list.id = UUID()
            list.title = "To Do List"
            list.color = UIColor(.cyan)
            list.isTemplate = false

            let reminder1 = Reminder(context: persistenceController.container.viewContext)
            reminder1.id = UUID()
            reminder1.title = "Shopping"
            reminder1.notes = "Go to bakery before 6pm"
            reminder1.dateCreated = Date.now
            reminder1.dueDate = Date.now
            reminder1.dueHour = Date.now
            reminder1.priority = 3
            reminder1.isFlagged = true
            reminder1.isCompleted = true
            reminder1.list = list

            let reminder2 = Reminder(context: persistenceController.container.viewContext)
            reminder2.id = UUID()
            reminder2.title = "Administrative stuff"
            reminder2.notes = ""
            reminder2.dateCreated = Date.now
            reminder2.dueDate = Date.now
            reminder2.dueHour = Date.now
            reminder2.dueDate = Date.now.addingTimeInterval(86400 * 15)
            reminder2.priority = 2
            reminder2.isFlagged = false
            reminder2.isCompleted = false
            reminder2.list = list

            let reminder3 = Reminder(context: persistenceController.container.viewContext)
            reminder3.id = UUID()
            reminder3.title = "Take vacation"
            reminder3.notes = ""
            reminder3.dateCreated = Date.now
            reminder3.dueDate = Date.now.addingTimeInterval(86400 * 45)
            reminder3.dueHour = Date.now
            reminder3.priority = 0
            reminder3.isFlagged = true
            reminder3.isCompleted = false
            reminder3.list = list

            let subtask1 = Subtask(context: persistenceController.container.viewContext)
            subtask1.title = "Bread"
            subtask1.dateCreated = Date.now
            subtask1.reminder = reminder1

            let subtask2 = Subtask(context: persistenceController.container.viewContext)
            subtask2.title = "Income tax"
            subtask2.dateCreated = Date.now
            subtask2.reminder = reminder2

            let subtask3 = Subtask(context: persistenceController.container.viewContext)
            subtask3.title = "Compare flights"
            subtask3.dateCreated = Date.now
            subtask3.reminder = reminder3

            let subtask4 = Subtask(context: persistenceController.container.viewContext)
            subtask4.title = "Find accommodation"
            subtask4.dateCreated = Date.now
            subtask4.reminder = reminder3

            let picture1 = Picture(context: persistenceController.container.viewContext)
            picture1.id = UUID()
            picture1.data = Data()
            picture1.reminder = reminder1

            let picture2 = Picture(context: persistenceController.container.viewContext)
            picture2.id = UUID()
            picture2.data = Data()
            picture2.reminder = reminder2

            let picture3 = Picture(context: persistenceController.container.viewContext)
            picture3.id = UUID()
            picture3.data = Data()
            picture3.reminder = reminder3

            let template1 = ReminderList(context: persistenceController.container.viewContext)
            template1.id = UUID()
            template1.title = "To Do List"
            template1.color = UIColor(.cyan)
            template1.isTemplate = true

            let reminder4 = Reminder(context: persistenceController.container.viewContext)
            reminder4.id = UUID()
            reminder4.title = "Shopping"
            reminder4.notes = "Go to bakery before 6pm"
            reminder4.dateCreated = Date.now
            reminder4.dueDate = Date.now
            reminder4.dueHour = Date.now
            reminder4.priority = 3
            reminder4.isFlagged = true
            reminder4.isCompleted = true
            reminder4.list = template1
            try? self.persistenceController.container.viewContext.save()
        case .testing:
            persistenceController = PersistenceController(inMemory: true)
        }

        fetchReminderLists()
        fetchReminderTemplates()
        fetchReminders(predicate: .all)
        fetchReminders(predicate: .today)
        fetchReminders(predicate: .scheduled)
        fetchReminders(predicate: .flagged)
        fetchReminders(predicate: .completed)
        fetchSubtasks()
        fetchPictures()
    }

    func delete(_ object: NSManagedObject) {
        persistenceController.container.viewContext.delete(object)
        save()
    }

    func save() {
        if persistenceController.container.viewContext.hasChanges {
            do {
                try persistenceController.container.viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        fetchReminderLists()
        fetchReminderTemplates()
        fetchReminders(predicate: .all)
        fetchReminders(predicate: .today)
        fetchReminders(predicate: .scheduled)
        fetchReminders(predicate: .flagged)
        fetchReminders(predicate: .completed)
        fetchSubtasks()
        fetchPictures()
    }
}
