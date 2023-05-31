//
//  SearchView.swift
//  Reminders
//
//  Created by Imen Ksouri on 20/05/2023.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.isSearching) private var isSearching
    @StateObject var viewModel: SummaryViewModel

    var body: some View {
        if isSearching {
            if !viewModel.searchText.isEmpty {
                List {
                    ForEach(viewModel.allReminders.filter { $0.title.lowercased()
                        .contains(viewModel.searchText.lowercased())},
                            id: \.self) { reminder in
                        ReminderRowView(reminderList: reminder.list,
                                        reminder: reminder)
                        ForEach(viewModel.subtasks, id: \.self) { subtask in
                            if subtask.reminder == reminder {
                                SubtaskRowView(reminder: reminder, subtask: subtask)
                                    .moveDisabled(true)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: SummaryViewModel(dataManager: .preview))
    }
}
