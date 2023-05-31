//
//  Reminder+CoreDataProperties.swift
//  Reminders
//
//  Created by Imen Ksouri on 09/05/2023.
//

import Foundation
import CoreData

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
