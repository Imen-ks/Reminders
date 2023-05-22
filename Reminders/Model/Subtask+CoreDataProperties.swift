//
//  Subtask+CoreDataProperties.swift
//  Reminders
//
//  Created by Imen Ksouri on 09/05/2023.
//

import Foundation
import CoreData
import SwiftUI

// PROPERTIES
extension Subtask {
    @NSManaged public var title: String
    @NSManaged public var dateCreated: Date
    @NSManaged public var reminder: Reminder
}

// METHODS
extension Subtask {
    static func create(subtasks: [String], in reminder: Reminder, context: NSManagedObjectContext) {
        if !subtasks.isEmpty {
            for subtaskTitle in subtasks where !subtaskTitle.isEmpty {
                let newSubtask = Subtask(context: context)
                newSubtask.title = subtaskTitle
                newSubtask.dateCreated = Date.now
                newSubtask.reminder = reminder
            }
            PersistenceController.save(context)
        }
    }

    static func createFromTemplate(in reminder: Reminder, title: String, context: NSManagedObjectContext) {
        let newSubtask = Subtask(context: context)
        newSubtask.title = title
        newSubtask.dateCreated = Date.now
        newSubtask.reminder = reminder
        PersistenceController.save(context)
    }

    static func update(subtask: Subtask,
                       title: String,
                       context: NSManagedObjectContext) {
        subtask.title = title
        PersistenceController.save(context)
    }
}

// FETCH REQUESTS
extension Subtask {
    static func fetchSubtasks() -> FetchRequest<Subtask> {
        return FetchRequest(entity: Subtask.entity(),
                            sortDescriptors: [NSSortDescriptor(key: #keyPath(Subtask.dateCreated), ascending: true)])
    }

    static func fetchSubtasks(in reminder: Reminder) -> FetchRequest<Subtask> {
        let reminderPredicate = NSPredicate(format: "%K == %@", #keyPath(Subtask.reminder.id),
                                            reminder.id as NSUUID)
        return FetchRequest(entity: Subtask.entity(),
                            sortDescriptors: [],
                            predicate: reminderPredicate)
    }
}
