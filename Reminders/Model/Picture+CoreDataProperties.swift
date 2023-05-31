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
