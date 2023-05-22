//
//  Picture+CoreDataProperties.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//
//

import Foundation
import CoreData
import SwiftUI

// PROPERTIES
extension Picture {
    @NSManaged public var id: UUID
    @NSManaged public var data: Data?
    @NSManaged public var reminder: Reminder?
}

// METHODS
extension Picture {
    static func create(pictures: [(id: UUID, data: Data)], in reminder: Reminder, context: NSManagedObjectContext) {
        if !pictures.isEmpty {
            for (id, data) in pictures {
                let newPicture = Picture(context: context)
                newPicture.id = id
                newPicture.data = data
                newPicture.reminder = reminder
            }
        }
        PersistenceController.save(context)
    }
}

// FETCH REQUESTS
extension Picture {
    static func fetchPictures(in reminder: Reminder) -> FetchRequest<Picture> {
        let reminderPredicate = NSPredicate(format: "%K == %@", #keyPath(Picture.reminder.id),
                                            reminder.id as NSUUID)
        return FetchRequest(entity: Picture.entity(),
                            sortDescriptors: [],
                            predicate: reminderPredicate)
    }

    static func fetchPictures() -> FetchRequest<Picture> {
        return FetchRequest(entity: Picture.entity(),
                            sortDescriptors: [])
    }
}
