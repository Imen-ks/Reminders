//
//  ReminderPriority.swift
//  Reminders
//
//  Created by Imen Ksouri on 09/05/2023.
//

import Foundation

enum ReminderPriority: Int16, CaseIterable {
    case none = 0
    case low = 1
    case medium = 2
    case high = 3
}

extension ReminderPriority {
    var shortDisplay: String {
        switch self {
        case .none: return ""
        case .low: return "!"
        case .medium: return "!!"
        case .high: return "!!!"
        }
    }
    var fullDisplay: String {
        switch self {
        case .none: return "None"
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
}
