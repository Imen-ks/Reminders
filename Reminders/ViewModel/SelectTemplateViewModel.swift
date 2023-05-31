//
//  SelectTemplateViewModel.swift
//  Reminders
//
//  Created by Imen Ksouri on 29/05/2023.
//

import Foundation
import Combine

@MainActor
final class SelectTemplateViewModel: ObservableObject {
    @Published var dataManager: CoreDataManager
    @Published var sortDescriptor = SortDescriptor.none
    @Published var nameList = ""

    var anyCancellable: AnyCancellable?

    init(dataManager: CoreDataManager = CoreDataManager.shared) {
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    var templates: [ReminderList] {
        dataManager.reminderTemplates
    }

    func createReminderListFromTemplate(template: ReminderList) {
        dataManager.createReminderListFromTemplate(template: template,
                                                   title: nameList,
                                                   reminders: dataManager.getReminders(
                                                    in: template, sortDescriptor: .none),
                                                   subtasks: dataManager.subtasks)
    }
}
