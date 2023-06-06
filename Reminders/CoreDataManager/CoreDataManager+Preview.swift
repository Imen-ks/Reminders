//
//  CoreDataManager+Preview.swift
//  Reminders
//
//  Created by Imen Ksouri on 27/05/2023.
//

import Foundation
import UIKit

extension CoreDataManager {
    static let context = CoreDataManager.preview.persistenceController.container.viewContext

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
        reminder.title = "This is a reminder"
        reminder.notes = "These are notes"
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
        subtask.title = "This is a subtask"
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
