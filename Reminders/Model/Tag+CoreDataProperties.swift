//
//  Tag+CoreDataProperties.swift
//  Reminders
//
//  Created by Imen Ksouri on 09/05/2023.
//

import Foundation
import CoreData

// PROPERTIES
extension Tag {
    @NSManaged public var title: String
    @NSManaged public var reminders: Set<Reminder>
}
