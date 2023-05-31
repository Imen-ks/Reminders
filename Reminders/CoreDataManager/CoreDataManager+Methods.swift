//
//  CoreDataManager+Methods.swift
//  Reminders
//
//  Created by Imen Ksouri on 25/05/2023.
//

import Foundation
import CoreData
import UIKit

extension CoreDataManager {
    func addReminderList(title: String,
                         color: UIColor) {
        let newReminderList = ReminderList(context: persistenceController.container.viewContext)
        newReminderList.id = UUID()
        newReminderList.title = title
        newReminderList.dateCreated = Date.now
        newReminderList.color = color
        newReminderList.order = 0
        newReminderList.isTemplate = false
        save()
    }

    func updateReminderList(reminderList: ReminderList,
                            title: String,
                            color: UIColor) {
        reminderList.title = title
        reminderList.color = color
        save()
    }

    // swiftlint:disable:next function_parameter_count
    func addReminder(title: String,
                     notes: String,
                     dueDate: Date?,
                     dueHour: Date?,
                     priority: Int16,
                     isFlagged: Bool,
                     list: ReminderList,
                     subtasks: [String],
                     tags: Set<Tag>? = nil,
                     pictures: [(id: UUID, data: Data)]) {
        let newReminder = Reminder(context: persistenceController.container.viewContext)
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

        create(subtasks: subtasks, in: newReminder)
        create(pictures: pictures, in: newReminder)
        save()
    }

    // swiftlint:disable:next function_parameter_count
    func updateReminder(reminder: Reminder,
                        title: String,
                        notes: String,
                        dueDate: Date?,
                        dueHour: Date?,
                        priority: Int16,
                        isFlagged: Bool,
                        list: ReminderList,
                        subtasks: [String],
                        tags: Set<Tag>? = nil,
                        pictures: [(id: UUID, data: Data)]) {
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

        create(subtasks: subtasks, in: reminder)
        create(pictures: pictures, in: reminder)
        save()
    }

    func updateReminder(reminder: Reminder,
                        title: String) {
        reminder.title = title
        save()
    }

    func updateReminder(reminder: Reminder,
                        notes: String) {
        reminder.notes = notes
        save()
    }

    func create(subtasks: [String], in reminder: Reminder) {
        if !subtasks.isEmpty {
            for subtaskTitle in subtasks where !subtaskTitle.isEmpty {
                let newSubtask = Subtask(context: persistenceController.container.viewContext)
                newSubtask.title = subtaskTitle
                newSubtask.dateCreated = Date.now
                newSubtask.reminder = reminder
            }
            save()
        }
    }

    func updateSubtask(subtask: Subtask, title: String) {
        subtask.title = title
        save()
    }

    func create(pictures: [(id: UUID, data: Data)], in reminder: Reminder) {
        if !pictures.isEmpty {
            for (id, data) in pictures {
                let newPicture = Picture(context: persistenceController.container.viewContext)
                newPicture.id = id
                newPicture.data = data
                newPicture.reminder = reminder
            }
        }
        save()
    }

    func saveAsTemplate(reminderList: ReminderList,
                        title: String,
                        color: UIColor,
                        reminders: [Reminder],
                        subtasks: [Subtask]) {
        let newTemplate = ReminderList(context: persistenceController.container.viewContext)
        newTemplate.id = UUID()
        newTemplate.title = title
        newTemplate.dateCreated = Date.now
        newTemplate.color = color
        newTemplate.order = 0
        newTemplate.isTemplate = true
        for reminder in reminders {
            let newReminder = createReminderFromTemplate(title: reminder.title,
                                                         notes: reminder.notes,
                                                         dueDate: reminder.dueDate,
                                                         dueHour: reminder.dueHour,
                                                         priority: reminder.priority,
                                                         isCompleted: reminder.isCompleted,
                                                         isFlagged: reminder.isFlagged,
                                                         template: newTemplate,
                                                         order: reminder.order)
            for subtask in subtasks where subtask.reminder == reminder {
                createSubtaskFromTemplate(in: newReminder,
                                          title: subtask.title)
            }
        }
        save()
    }

    func createReminderListFromTemplate(template: ReminderList,
                                        title: String,
                                        reminders: [Reminder],
                                        subtasks: [Subtask]) {
        let newReminderList = ReminderList(context: persistenceController.container.viewContext)
        newReminderList.id = UUID()
        newReminderList.title = title
        newReminderList.dateCreated = Date.now
        newReminderList.color = template.color
        newReminderList.order = 0
        newReminderList.isTemplate = false
        for reminder in reminders {
            let newReminder = createReminderFromTemplate(title: reminder.title,
                                                         notes: reminder.notes,
                                                         dueDate: reminder.dueDate,
                                                         dueHour: reminder.dueHour,
                                                         priority: reminder.priority,
                                                         isCompleted: reminder.isCompleted,
                                                         isFlagged: reminder.isFlagged,
                                                         template: newReminderList,
                                                         order: reminder.order)
            for subtask in subtasks where subtask.reminder == reminder {
                createSubtaskFromTemplate(in: newReminder,
                                          title: subtask.title)
            }
        }
        save()
    }

    // swiftlint:disable:next function_parameter_count
    func createReminderFromTemplate(title: String,
                                    notes: String,
                                    dueDate: Date?,
                                    dueHour: Date?,
                                    priority: Int16,
                                    isCompleted: Bool,
                                    isFlagged: Bool,
                                    template: ReminderList,
                                    order: Int16) -> Reminder {
        let newReminder = Reminder(context: persistenceController.container.viewContext)
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
        save()

        return newReminder
    }

    func createSubtaskFromTemplate(in reminder: Reminder, title: String) {
        let newSubtask = Subtask(context: persistenceController.container.viewContext)
        newSubtask.title = title
        newSubtask.dateCreated = Date.now
        newSubtask.reminder = reminder
        save()
    }
}
