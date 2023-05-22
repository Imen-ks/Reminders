//
//  FlaggedRemindersView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct FlaggedRemindersView: View {
    var fetchFlaggedReminders: FetchRequest<Reminder>
    var flaggedReminders: [Reminder] {
        return Array(fetchFlaggedReminders.wrappedValue)
            .sorted { $0.dueDate ?? $0.dateCreated < $1.dueDate ?? $1.dateCreated }
    }

    var subtasksFetchRequest: FetchRequest<Subtask>
    var subtasks: FetchedResults<Subtask> {
        subtasksFetchRequest.wrappedValue
    }

    var body: some View {
        List {
            ForEach(flaggedReminders, id: \.self) { reminder in
                ReminderRowView(reminderList: reminder.list,
                                reminder: reminder,
                                remindersFetchRequest: fetchFlaggedReminders)
                ForEach(subtasks, id: \.self) { subtask in
                    if subtask.reminder == reminder {
                        SubtaskRowView(reminder: reminder, subtask: subtask)
                            .moveDisabled(true)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitle("Flagged", displayMode: .large)
        .navigationBarTitleTextColor(UIColor(.orange))
    }
}

struct FlaggedRemindersView_Previews: PreviewProvider {
    static var fetchFlaggedReminders: FetchRequest<Reminder> = Reminder.fetchReminders(predicate: .flagged)
    static var subtasksFetchRequest: FetchRequest<Subtask> = Subtask.fetchSubtasks()
    static var previews: some View {
        return NavigationStack {
            FlaggedRemindersView(
                fetchFlaggedReminders: fetchFlaggedReminders,
                subtasksFetchRequest: subtasksFetchRequest)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
