//
//  CreateReminderViewModel.swift
//  Reminders
//
//  Created by Imen Ksouri on 29/05/2023.
//

import Foundation
import Combine

@MainActor
final class CreateReminderViewModel: ObservableObject {
    @Published var dataManager: CoreDataManager
    @Published var selectedList: ReminderList
    @Published var title = ""
    @Published var notes = ""
    @Published var isAddingDueDate = false
    @Published var isAddingDueHour = false
    @Published var dueDate: Date?
    @Published var dueHour: Date?
    @Published var tags = ""
    @Published var isFlagging = false
    @Published var priority = ReminderPriority.none
    @Published var pictures: [(id: UUID, data: Data)] = []
    @Published var subtasks: [String] = []
    @Published var newSubtasks: [String] = []

    var anyCancellable: AnyCancellable?

    init(dataManager: CoreDataManager = CoreDataManager.shared, reminderList: ReminderList) {
        self.dataManager = dataManager
        self.selectedList = reminderList
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    func addReminder() {
        dataManager.addReminder(title: title,
                                notes: notes,
                                dueDate: dueDate,
                                dueHour: dueHour,
                                priority: priority.rawValue,
                                isFlagged: isFlagging,
                                list: selectedList,
                                subtasks: subtasks,
                                pictures: pictures)
    }
}
