//
//  ReminderList+CoreDataProperties.swift
//  Reminders
//
//  Created by Imen Ksouri on 09/05/2023.
//

import Foundation
import CoreData
import UIKit

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

    var identifier: String {
        objectID.uriRepresentation().absoluteString
    }
}

extension ReminderList {
    var shortcutItem: UIApplicationShortcutItem? {
        return UIApplicationShortcutItem(
            type: ActionType.editReminderList.rawValue,
            localizedTitle: "New in \(title)",
            localizedSubtitle: nil,
            icon: .init(systemImageName: "plus"),
            userInfo: [
            "ReminderListID": identifier as NSString
            ]
        )
    }
}
