//
//  DisplayReminderListViewModel.swift
//  Reminders
//
//  Created by Imen Ksouri on 27/05/2023.
//

import Foundation
import CoreData
import Combine

@MainActor
final class DisplayReminderListViewModel: ObservableObject {
    @Published var dataManager: CoreDataManager
    @Published var sortDescriptor: SortDescriptor = .dateCreated

    var anyCancellable: AnyCancellable?

    init(dataManager: CoreDataManager = CoreDataManager.shared) {
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    var reminderLists: [ReminderList] {
        dataManager.reminderLists
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            dataManager.delete(reminderLists[index])
        }
    }

    func delete(_ list: NSManagedObject) {
        dataManager.delete(list)
    }

    func move(from source: IndexSet, to destination: Int) {
        var reminderLists: [ReminderList] = self.reminderLists.map { $0 }
        reminderLists.move(fromOffsets: source, toOffset: destination )
        for reverseIndex in stride(from: reminderLists.count - 1,
                                    through: 0,
                                    by: -1) {
            reminderLists[reverseIndex].order =
                Int16(reverseIndex)
        }
        dataManager.save()
    }

    func findList(withIdentifier: String) -> ReminderList? {
        dataManager.findList(withIdentifier: withIdentifier)
    }
}
