//
//  SaveTemplateViewModel.swift
//  Reminders
//
//  Created by Imen Ksouri on 30/05/2023.
//

import Foundation
import Combine
import UIKit
import SwiftUI

@MainActor
final class SaveTemplateViewModel: ObservableObject {
    @Published var dataManager: CoreDataManager
    @Published var listTitle: String
    @Published var selectedColor: Color

    var anyCancellable: AnyCancellable?

    init(dataManager: CoreDataManager = CoreDataManager.shared, reminderList: ReminderList) {
        self.dataManager = dataManager
        self.listTitle = reminderList.title
        self.selectedColor = Color(reminderList.color)
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    func saveAsTemplate(reminderList: ReminderList) {
        dataManager.saveAsTemplate(reminderList: reminderList,
                                   title: listTitle,
                                   color: UIColor(selectedColor),
                                   reminders: dataManager.getReminders(
                                    in: reminderList, sortDescriptor: .none),
                                   subtasks: dataManager.subtasks)
    }
}
