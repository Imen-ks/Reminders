//
//  CoreDataManager+FetchRequests.swift
//  Reminders
//
//  Created by Imen Ksouri on 25/05/2023.
//

import Foundation
import CoreData

extension CoreDataManager {
    func fetchReminderLists() {
        let request = NSFetchRequest<ReminderList>(entityName: "ReminderList")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ReminderList.order, ascending: true),
            NSSortDescriptor(keyPath: \ReminderList.dateCreated, ascending: true)
        ]
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(ReminderList.isTemplate),
                                        NSNumber(value: false))
        do {
            reminderLists = try persistenceController.container.viewContext.fetch(request)
        } catch {
            print(error)
        }
    }

    func fetchReminderTemplates() {
        let request = NSFetchRequest<ReminderList>(entityName: "ReminderList")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ReminderList.title, ascending: true),
            NSSortDescriptor(keyPath: \ReminderList.dateCreated, ascending: true)
        ]
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(ReminderList.isTemplate),
                                        NSNumber(value: true))
        do {
            reminderTemplates = try persistenceController.container.viewContext.fetch(request)
        } catch {
            print(error)
        }
    }

    func fetchReminders(request: NSFetchRequest<Reminder>) -> [Reminder] {
        do {
            return try persistenceController.container.viewContext.fetch(request)
        } catch {
            print(error)
        }
        return []
    }

    func getReminders(in list: ReminderList, sortDescriptor: SortDescriptor) -> [Reminder] {
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Reminder.list.id), list.id as NSUUID)

        if sortDescriptor == .none {
            request.sortDescriptors = [
                NSSortDescriptor(key: #keyPath(Reminder.order), ascending: true),
                NSSortDescriptor(key: #keyPath(Reminder.dateCreated), ascending: true)]
            return fetchReminders(request: request)
        } else if sortDescriptor == .title {
            request.sortDescriptors = [
                NSSortDescriptor(key: #keyPath(Reminder.title), ascending: true,
                                 selector: #selector(NSString.caseInsensitiveCompare(_:)))]
            return fetchReminders(request: request)
        } else if sortDescriptor == .dueDate {
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Reminder.dueDate), ascending: true)]
            return fetchReminders(request: request)
        } else if sortDescriptor == .dateCreated {
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Reminder.dateCreated), ascending: false)]
            return fetchReminders(request: request)
        } else {
            request.sortDescriptors = [
                NSSortDescriptor(key: #keyPath(Reminder.priority), ascending: false),
                NSSortDescriptor(key: #keyPath(Reminder.dateCreated), ascending: true)]
            return fetchReminders(request: request)
        }
    }

    func fetchReminders(predicate: ReminderPredicate) {
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Reminder.dueDate), ascending: true)]
        let listPredicate = NSPredicate(format: "%K == %@", #keyPath(Reminder.list.isTemplate), NSNumber(value: false))

        if predicate == .all {
            request.predicate = listPredicate
            allReminders = fetchReminders(request: request)
                .sorted { $0.dueDate ?? $0.dateCreated < $1.dueDate ?? $1.dateCreated }
        } else if predicate == .completed {
            let reminderPredicate = NSPredicate(format: "%K == %@",
                                                #keyPath(Reminder.isCompleted), NSNumber(value: true))
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:
                                                        [listPredicate, reminderPredicate])
            completedReminders = fetchReminders(request: request)
                .sorted { $0.dueDate ?? $0.dateCreated > $1.dueDate ?? $1.dateCreated }
        } else if predicate == .flagged {
            let reminderPredicate = NSPredicate(format: "%K == %@",
                                                #keyPath(Reminder.isFlagged), NSNumber(value: true))
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:
                                                        [listPredicate, reminderPredicate])
            flaggedReminders = fetchReminders(request: request)
                .sorted { $0.dueDate ?? $0.dateCreated < $1.dueDate ?? $1.dateCreated }
        } else if predicate == .today {
            let today = Date()
            let calendar = Calendar.current
            var components = DateComponents()
            components.day = calendar.component(.day, from: today)
            components.month = calendar.component(.month, from: today)
            components.year = calendar.component(.year, from: today)
            components.hour = 23
            components.minute = 59
            let todayDate = calendar.date(from: components)
            let reminderPredicate = NSPredicate(format: "%K <= %@",
                                                #keyPath(Reminder.dueDate), todayDate! as NSDate)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:
                                                        [listPredicate, reminderPredicate])
            todayReminders = fetchReminders(request: request)
                .sorted { $0.dueDate ?? $0.dateCreated < $1.dueDate ?? $1.dateCreated }
        } else if predicate == .scheduled {
            let reminderPredicate = NSPredicate(format: "%K != %@",
                                                #keyPath(Reminder.dueDate), NSNull())
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:
                                                        [listPredicate, reminderPredicate])
            scheduledReminders = fetchReminders(request: request)
                .sorted { $0.dueDate ?? $0.dateCreated < $1.dueDate ?? $1.dateCreated }
        }
    }

    func fetchSubtasks() {
        let request = NSFetchRequest<Subtask>(entityName: "Subtask")
        do {
            subtasks = try persistenceController.container.viewContext.fetch(request)
        } catch {
            print(error)
        }
    }

    func getSubtasks(in reminder: Reminder) -> [Subtask] {
        let request = NSFetchRequest<Subtask>(entityName: "Subtask")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Subtask.reminder.id),
                                            reminder.id as NSUUID)
        do {
            return try persistenceController.container.viewContext.fetch(request)
        } catch {
            print(error)
        }
        return [Subtask]()
    }

    func fetchPictures() {
        let request = NSFetchRequest<Picture>(entityName: "Picture")
        do {
            pictures = try persistenceController.container.viewContext.fetch(request)
        } catch {
            print(error)
        }
    }

    func getPictures(in reminder: Reminder) -> [Picture] {
        let request = NSFetchRequest<Picture>(entityName: "Picture")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Picture.reminder.id),
                                            reminder.id as NSUUID)
        do {
            return try persistenceController.container.viewContext.fetch(request)
        } catch {
            print(error)
        }
        return [Picture]()
    }
}
