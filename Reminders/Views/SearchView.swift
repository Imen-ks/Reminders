//
//  SearchView.swift
//  Reminders
//
//  Created by Imen Ksouri on 20/05/2023.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.isSearching) private var isSearching
    @Binding var searchText: String

    var fetchRequest: FetchRequest<Reminder> = Reminder.fetchReminders(predicate: .all)
    var reminders: FetchedResults<Reminder> {
        return fetchRequest.wrappedValue
    }

    var subtasksFetchRequest: FetchRequest<Subtask> = Subtask.fetchSubtasks()
    var subtasks: FetchedResults<Subtask> {
        subtasksFetchRequest.wrappedValue
    }

    var body: some View {
        if isSearching {
            if !searchText.isEmpty {
                List {
                    ForEach(reminders.filter { $0.title.lowercased()
                        .contains(searchText.lowercased())},
                            id: \.self) { reminder in
                        ReminderRowView(reminderList: reminder.list,
                                        reminder: reminder,
                                        remindersFetchRequest: fetchRequest)
                        ForEach(subtasks, id: \.self) { subtask in
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
    @State static var searchText: String = ""
    static var previews: some View {
        SearchView(searchText: $searchText)
    }
}
