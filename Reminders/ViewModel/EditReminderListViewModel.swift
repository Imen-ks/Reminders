//
//  EditReminderListViewModel.swift
//  Reminders
//
//  Created by Imen Ksouri on 29/05/2023.
//

import Foundation
import Combine
import UIKit
import SwiftUI

@MainActor
final class EditReminderListViewModel: ObservableObject {
    @Published var dataManager: CoreDataManager
    @Published var listTitle = ""
    @Published var selectedColor: Color = .blue

    var anyCancellable: AnyCancellable?

    init(dataManager: CoreDataManager = CoreDataManager.shared, reminderList: ReminderList) {
        self.dataManager = dataManager
        self.listTitle = reminderList.title
        self.selectedColor = Color(reminderList.color)
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    func updateReminderList(reminderList: ReminderList) {
        dataManager.updateReminderList(reminderList: reminderList, title: listTitle, color: UIColor(selectedColor))
    }
}
