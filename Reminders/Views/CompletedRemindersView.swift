//
//  CompletedRemindersView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct CompletedRemindersView: View {
    var fetchCompletedReminders: FetchRequest<Reminder>
    var completedReminders: [Reminder] {
        return Array(fetchCompletedReminders.wrappedValue)
            .sorted { $0.dueDate ?? $0.dateCreated > $1.dueDate ?? $1.dateCreated }
    }

    var subtasksFetchRequest: FetchRequest<Subtask>
    var subtasks: FetchedResults<Subtask> {
        subtasksFetchRequest.wrappedValue
    }

    var body: some View {
        List {
            ForEach(completedReminders, id: \.self) { reminder in
                ReminderRowView(reminderList: reminder.list,
                                reminder: reminder,
                                remindersFetchRequest: fetchCompletedReminders)
                ForEach(subtasks, id: \.self) { subtask in
                    if subtask.reminder == reminder {
                        SubtaskRowView(reminder: reminder, subtask: subtask)
                            .moveDisabled(true)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitle("Completed", displayMode: .large)
        .navigationBarTitleTextColor(UIColor(.gray))
    }
}

struct CompletedRemindersView_Previews: PreviewProvider {
    static var fetchCompletedReminders: FetchRequest<Reminder> = Reminder.fetchReminders(predicate: .completed)
    static var subtasksFetchRequest: FetchRequest<Subtask> = Subtask.fetchSubtasks()
    static var previews: some View {
        return NavigationStack {
            CompletedRemindersView(
                fetchCompletedReminders: fetchCompletedReminders,
                subtasksFetchRequest: subtasksFetchRequest)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
