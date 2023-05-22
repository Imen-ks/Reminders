//
//  Persistence.swift
//  Reminders
//
//  Created by Imen Ksouri on 09/05/2023.
//

import CoreData
import UIKit
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()

    static func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let list = ReminderList(context: viewContext)
        list.id = UUID()
        list.title = "To Do List"
        list.color = UIColor(.cyan)
        list.isTemplate = false

        let reminder1 = Reminder(context: viewContext)
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

        let reminder2 = Reminder(context: viewContext)
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

        let reminder3 = Reminder(context: viewContext)
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

        let subtask1 = Subtask(context: viewContext)
        subtask1.title = "Bread"
        subtask1.dateCreated = Date.now
        subtask1.reminder = reminder1

        let subtask2 = Subtask(context: viewContext)
        subtask2.title = "Income tax"
        subtask2.dateCreated = Date.now
        subtask2.reminder = reminder2

        let subtask3 = Subtask(context: viewContext)
        subtask3.title = "Compare flights"
        subtask3.dateCreated = Date.now
        subtask3.reminder = reminder3

        let subtask4 = Subtask(context: viewContext)
        subtask4.title = "Find accommodation"
        subtask4.dateCreated = Date.now
        subtask4.reminder = reminder3

        let picture1 = Picture(context: viewContext)
        picture1.id = UUID()
        picture1.data = Data()
        picture1.reminder = reminder1

        let picture2 = Picture(context: viewContext)
        picture2.id = UUID()
        picture2.data = Data()
        picture2.reminder = reminder2

        let picture3 = Picture(context: viewContext)
        picture3.id = UUID()
        picture3.data = Data()
        picture3.reminder = reminder3

        let template = ReminderList(context: viewContext)
        template.id = UUID()
        template.title = "To Do List"
        template.color = UIColor(.cyan)
        template.isTemplate = true

        let reminder4 = Reminder(context: viewContext)
        reminder4.id = UUID()
        reminder4.title = "Shopping"
        reminder4.notes = "Go to bakery before 6pm"
        reminder4.dateCreated = Date.now
        reminder4.dueDate = Date.now
        reminder4.dueHour = Date.now
        reminder4.priority = 3
        reminder4.isFlagged = true
        reminder4.isCompleted = true
        reminder4.list = template

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Reminders")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension PersistenceController {
    static let context = PersistenceController.preview.container.viewContext

    static func reminderListForPreview() -> ReminderList {
        let reminderList = ReminderList(context: context)
        reminderList.id = UUID()
        reminderList.title = "Reminders"
        reminderList.color = UIColor(.purple)
        reminderList.isTemplate = false
        return reminderList
    }

    static func reminderForPreview(reminderList: ReminderList) -> Reminder {
        var components = DateComponents()
        components.day = 20
        components.month = 5
        components.year = 2023
        components.hour = 8
        components.minute = 30
        let date = Calendar.current.date(from: components)
        let reminder = Reminder(context: context)
        reminder.id = UUID()
        reminder.title = "New reminder"
        reminder.notes = "New notes"
        reminder.dateCreated = Date.now
        reminder.dueDate = date
        reminder.dueHour = date
        reminder.priority = 3
        reminder.isFlagged = true
        reminder.isCompleted = true
        reminder.list = reminderList
        return reminder
    }

    static func subtaskForPreview(reminder: Reminder) -> Subtask {
        let subtask = Subtask(context: context)
        subtask.title = "New subtask"
        subtask.dateCreated = Date.now
        subtask.reminder = reminder
        return subtask
    }

    static func pictureForPreview(reminder: Reminder) -> Picture {
        let picture = Picture(context: context)
        picture.id = UUID()
        picture.data = Data()
        picture.reminder = reminder
        return picture
    }
}
