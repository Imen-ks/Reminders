//
//  Reminder+CoreDataProperties.swift
//  Reminders
//
//  Created by Imen Ksouri on 09/05/2023.
//

import Foundation
import CoreData
import SwiftUI

// PROPERTIES
extension Reminder {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var notes: String
    @NSManaged public var dateCreated: Date
    @NSManaged public var dueDate: Date?
    @NSManaged public var dueHour: Date?
    @NSManaged public var priority: Int16
    @NSManaged public var isCompleted: Bool
    @NSManaged public var isFlagged: Bool
    @NSManaged public var list: ReminderList
    @NSManaged public var subtasks: [Subtask]?
    @NSManaged public var tags: Set<Tag>?
    @NSManaged public var pictures: [Picture]?
    @NSManaged public var order: Int16

    @objc var subtaskCount: Int {
        let count = subtasks?.count ?? 0
        return count
    }
}

// METHODS
extension Reminder {
    // swiftlint:disable:next function_parameter_count
    static func create(title: String,
                       notes: String,
                       dueDate: Date?,
                       dueHour: Date?,
                       priority: Int16,
                       isFlagged: Bool,
                       list: ReminderList,
                       subtasks: [String],
                       tags: Set<Tag>? = nil,
                       pictures: [(id: UUID, data: Data)],
                       context: NSManagedObjectContext) {

        let newReminder = Reminder(context: context)
        newReminder.id = UUID()
        newReminder.title = title
        newReminder.notes = notes
        newReminder.dateCreated = Date.now
        if let dueDate = dueDate { newReminder.dueDate = dueDate }
        if let dueHour = dueHour { newReminder.dueHour = dueHour }
        newReminder.priority = priority
        newReminder.isCompleted = false
        newReminder.isFlagged = isFlagged
        newReminder.list = list
        if let tags = tags { newReminder.tags = tags }
        newReminder.order = 0

        Subtask.create(subtasks: subtasks, in: newReminder, context: context)
        Picture.create(pictures: pictures, in: newReminder, context: context)
        PersistenceController.save(context)
    }

    // swiftlint:disable:next function_parameter_count
    static func createFromTemplate(title: String,
                                   notes: String,
                                   dueDate: Date?,
                                   dueHour: Date?,
                                   priority: Int16,
                                   isCompleted: Bool,
                                   isFlagged: Bool,
                                   template: ReminderList,
                                   order: Int16,
                                   context: NSManagedObjectContext) -> Reminder {

        let newReminder = Reminder(context: context)
        newReminder.id = UUID()
        newReminder.title = title
        newReminder.notes = notes
        newReminder.dateCreated = Date.now
        if let dueDate = dueDate { newReminder.dueDate = dueDate }
        if let dueHour = dueHour { newReminder.dueHour = dueHour }
        newReminder.priority = priority
        newReminder.isCompleted = isCompleted
        newReminder.isFlagged = isFlagged
        newReminder.list = template
        newReminder.order = order
        PersistenceController.save(context)

        return newReminder
    }

    // swiftlint:disable:next function_parameter_count
    static func update(reminder: Reminder,
                       title: String,
                       notes: String,
                       dueDate: Date?,
                       dueHour: Date?,
                       priority: Int16,
                       isFlagged: Bool,
                       list: ReminderList,
                       subtasks: [String],
                       tags: Set<Tag>? = nil,
                       pictures: [(id: UUID, data: Data)],
                       context: NSManagedObjectContext) {
        reminder.title = title
        reminder.notes = notes
        if let dueDate = dueDate {
            reminder.dueDate = dueDate
        } else { reminder.dueDate = nil }
        if let dueHour = dueHour {
            reminder.dueHour = dueHour
        } else { reminder.dueHour = nil }
        reminder.priority = priority
        reminder.isFlagged = isFlagged
        reminder.list = list
        if let tags = tags { reminder.tags = tags }

        Subtask.create(subtasks: subtasks, in: reminder, context: context)
        Picture.create(pictures: pictures, in: reminder, context: context)
        PersistenceController.save(context)
    }

    static func update(reminder: Reminder,
                       title: String,
                       context: NSManagedObjectContext) {
        reminder.title = title
        PersistenceController.save(context)
    }

    static func update(reminder: Reminder,
                       notes: String,
                       context: NSManagedObjectContext) {
        reminder.notes = notes
        PersistenceController.save(context)
    }
}

// FETCH REQUESTS
extension Reminder {
    static func fetchReminders(predicate: ReminderPredicate) -> FetchRequest<Reminder> {
        let sort: [NSSortDescriptor] = [NSSortDescriptor(key: #keyPath(Reminder.dueDate), ascending: true)]
        let listPredicate = NSPredicate(format: "%K == %@", #keyPath(Reminder.list.isTemplate), NSNumber(value: false))
        var reminderPredicate: NSPredicate?
        let today = Date()
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = calendar.component(.day, from: today)
        components.month = calendar.component(.month, from: today)
        components.year = calendar.component(.year, from: today)
        components.hour = 23
        components.minute = 59
        let todayDate = calendar.date(from: components)

        if predicate == .all {
            reminderPredicate = nil
        } else if predicate == .completed {
            reminderPredicate = NSPredicate(format: "%K == %@", #keyPath(Reminder.isCompleted), NSNumber(value: true))
        } else if predicate == .flagged {
            reminderPredicate = NSPredicate(format: "%K == %@", #keyPath(Reminder.isFlagged), NSNumber(value: true))
        } else if predicate == .today {
            reminderPredicate = NSPredicate(format: "%K <= %@", #keyPath(Reminder.dueDate), todayDate! as NSDate)
        } else if predicate == .scheduled {
            reminderPredicate = NSPredicate(format: "%K != %@", #keyPath(Reminder.dueDate), NSNull())
        }

        if let reminderPredicate = reminderPredicate {
            return FetchRequest(entity: Reminder.entity(),
                                sortDescriptors: sort,
                                predicate: NSCompoundPredicate(andPredicateWithSubpredicates:
                                                                [listPredicate, reminderPredicate]))
        } else {
            return FetchRequest(entity: Reminder.entity(),
                                sortDescriptors: sort,
                                predicate: listPredicate)
        }
    }

    static func fetchReminders(in list: ReminderList, sortDescriptor: SortDescriptor) -> FetchRequest<Reminder> {
        var sort: [NSSortDescriptor]
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Reminder.list.id), list.id as NSUUID)

        if sortDescriptor == .none {
            sort = [
                NSSortDescriptor(key: #keyPath(Reminder.order), ascending: true),
                NSSortDescriptor(key: #keyPath(Reminder.dateCreated), ascending: true)
            ]
        } else if sortDescriptor == .title {
            sort = [
                NSSortDescriptor(key: #keyPath(Reminder.title), ascending: true,
                                 selector: #selector(NSString.caseInsensitiveCompare(_:)))]
        } else if sortDescriptor == .dueDate {
            sort = [NSSortDescriptor(key: #keyPath(Reminder.dueDate), ascending: true)]
        } else if sortDescriptor == .dateCreated {
            sort = [NSSortDescriptor(key: #keyPath(Reminder.dateCreated), ascending: false)]
        } else {
            sort = [NSSortDescriptor(key: #keyPath(Reminder.priority), ascending: false)]
        }

        return FetchRequest(entity: Reminder.entity(),
                            sortDescriptors: sort,
                            predicate: predicate)
    }
}
