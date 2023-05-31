//
//  CreateReminderListViewModel.swift
//  Reminders
//
//  Created by Imen Ksouri on 29/05/2023.
//

import Foundation
import Combine
import UIKit
import SwiftUI

@MainActor
final class CreateReminderListViewModel: ObservableObject {
    @Published var dataManager: CoreDataManager
    @Published var listTitle = ""
    @Published var selectedColor: Color = .blue

    var anyCancellable: AnyCancellable?

    init(dataManager: CoreDataManager = CoreDataManager.shared) {
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    func addReminderList() {
        dataManager.addReminderList(title: listTitle, color: UIColor(selectedColor))
    }
}
