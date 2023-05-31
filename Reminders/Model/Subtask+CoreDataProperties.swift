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
