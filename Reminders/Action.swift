//
//  Action.swift
//  Reminders
//
//  Created by Imen Ksouri on 01/06/2023.
//

import Foundation
import UIKit

enum ActionType: String {
    case newReminderList = "NewReminderList"
    case editReminderList = "EditReminderList"
}

enum Action: Equatable {
    case newReminderList
    case editReminderList(identifier: String)

    init?(shortcutItem: UIApplicationShortcutItem) {
        guard let type = ActionType(rawValue: shortcutItem.type) else {
            return nil
        }

        switch type {
        case .newReminderList:
            self = .newReminderList
        case .editReminderList:
            if let identifier = shortcutItem.userInfo?["ReminderListID"] as? String {
                self = .editReminderList(identifier: identifier)
            } else {
                return nil
            }
        }
    }
}

class ActionService: ObservableObject {
    static let shared = ActionService()

    @Published var action: Action?
}
