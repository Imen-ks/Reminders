//
//  ReminderList+CoreDataProperties.swift
//  Reminders
//
//  Created by Imen Ksouri on 09/05/2023.
//

import Foundation
import CoreData
import SwiftUI

// PROPERTIES
extension ReminderList {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var dateCreated: Date
    @NSManaged public var color: UIColor
    @NSManaged public var order: Int16
    @NSManaged public var isTemplate: Bool
    @NSManaged public var reminders: [Reminder]?

    @objc var reminderCount: Int {
        let count = reminders?.count ?? 0
        return count
    }
}

// METHODS
extension ReminderList {
    static func create(title: String,
                       color: UIColor,
                       context: NSManagedObjectContext) {
        let newReminderList = ReminderList(context: context)
        newReminderList.id = UUID()
        newReminderList.title = title
        newReminderList.dateCreated = Date.now
        newReminderList.color = color
        newReminderList.order = 0
        newReminderList.isTemplate = false
        PersistenceController.save(context)
    }

    static func update(reminderList: ReminderList,
                       title: String,
                       color: UIColor,
                       context: NSManagedObjectContext) {
        reminderList.title = title
        reminderList.color = color
        PersistenceController.save(context)
    }

    // swiftlint:disable:next function_parameter_count
    static func saveAsTemplate(reminderList: ReminderList,
                               title: String,
                               color: UIColor,
                               reminders: FetchedResults<Reminder>,
                               subtasks: FetchedResults<Subtask>,
                               context: NSManagedObjectContext) {
        let newTemplate = ReminderList(context: context)
        newTemplate.id = UUID()
        newTemplate.title = title
        newTemplate.dateCreated = Date.now
        newTemplate.color = color
        newTemplate.order = 0
        newTemplate.isTemplate = true
        for reminder in reminders {
            let newReminder = Reminder.createFromTemplate(title: reminder.title,
                                                          notes: reminder.notes,
                                                          dueDate: reminder.dueDate,
                                                          dueHour: reminder.dueHour,
                                                          priority: reminder.priority,
                                                          isCompleted: reminder.isCompleted,
                                                          isFlagged: reminder.isFlagged,
                                                          template: newTemplate,
                                                          order: reminder.order,
                                                          context: context)
            for subtask in subtasks where subtask.reminder == reminder {
                Subtask.createFromTemplate(in: newReminder,
                                           title: subtask.title,
                                           context: context)
            }
        }
        PersistenceController.save(context)
    }

    static func createReminderListFromTemplate(template: ReminderList,
                                               title: String,
                                               reminders: FetchedResults<Reminder>,
                                               subtasks: FetchedResults<Subtask>,
                                               context: NSManagedObjectContext) {
        let newReminderList = ReminderList(context: context)
        newReminderList.id = UUID()
        newReminderList.title = title
        newReminderList.dateCreated = Date.now
        newReminderList.color = template.color
        newReminderList.order = 0
        newReminderList.isTemplate = false
        for reminder in reminders {
            let newReminder = Reminder.createFromTemplate(title: reminder.title,
                                                          notes: reminder.notes,
                                                          dueDate: reminder.dueDate,
                                                          dueHour: reminder.dueHour,
                                                          priority: reminder.priority,
                                                          isCompleted: reminder.isCompleted,
                                                          isFlagged: reminder.isFlagged,
                                                          template: newReminderList,
                                                          order: reminder.order,
                                                          context: context)
            for subtask in subtasks where subtask.reminder == reminder {
                Subtask.createFromTemplate(in: newReminder,
                                           title: subtask.title,
                                           context: context)
            }
        }
        PersistenceController.save(context)
    }
}

// FETCH REQUESTS
extension ReminderList {
    static func fetchReminderLists() -> FetchRequest<ReminderList> {
        return FetchRequest(entity: ReminderList.entity(),
                            sortDescriptors: [
                                NSSortDescriptor(keyPath: \ReminderList.order, ascending: true),
                                NSSortDescriptor(keyPath: \ReminderList.dateCreated, ascending: true)
                            ],
                            predicate: NSPredicate(format: "%K == %@",
                                                   #keyPath(ReminderList.isTemplate),
                                                   NSNumber(value: false)))
    }

    static func fetchReminderTemplates() -> FetchRequest<ReminderList> {
        return FetchRequest(entity: ReminderList.entity(),
                            sortDescriptors: [
                                NSSortDescriptor(keyPath: \ReminderList.title, ascending: true),
                                NSSortDescriptor(keyPath: \ReminderList.dateCreated, ascending: true)
                            ],
                            predicate: NSPredicate(format: "%K == %@",
                                                   #keyPath(ReminderList.isTemplate),
                                                   NSNumber(value: true)))
    }
}
