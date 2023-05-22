//
//  ScheduledRemindersView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct ScheduledRemindersView: View {
    var fetchScheduledReminders: FetchRequest<Reminder>
    var scheduledReminders: [Reminder] {
        return Array(fetchScheduledReminders.wrappedValue)
            .sorted { $0.dueDate ?? $0.dateCreated < $1.dueDate ?? $1.dateCreated }
    }

    var subtasksFetchRequest: FetchRequest<Subtask>
    var subtasks: FetchedResults<Subtask> {
        subtasksFetchRequest.wrappedValue
    }

    var body: some View {
        List {
            ForEach(scheduledReminders, id: \.self) { reminder in
                ReminderRowView(reminderList: reminder.list,
                                reminder: reminder,
                                remindersFetchRequest: fetchScheduledReminders)
                ForEach(subtasks, id: \.self) { subtask in
                    if subtask.reminder == reminder {
                        SubtaskRowView(reminder: reminder, subtask: subtask)
                            .moveDisabled(true)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitle("Scheduled", displayMode: .large)
        .navigationBarTitleTextColor(UIColor(.red))
    }
}

struct ScheduledRemindersView_Previews: PreviewProvider {
    static var fetchScheduledReminders: FetchRequest<Reminder> = Reminder.fetchReminders(predicate: .scheduled)
    static var subtasksFetchRequest: FetchRequest<Subtask> = Subtask.fetchSubtasks()
    static var previews: some View {
        return NavigationStack {
            ScheduledRemindersView(
                fetchScheduledReminders: fetchScheduledReminders,
                subtasksFetchRequest: subtasksFetchRequest)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
