//
//  TodayRemindersView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct TodayRemindersView: View {
    var fetchTodayReminders: FetchRequest<Reminder>
    var todayReminders: [Reminder] {
        return Array(fetchTodayReminders.wrappedValue)
            .sorted { $0.dueDate ?? $0.dateCreated < $1.dueDate ?? $1.dateCreated }
    }

    var subtasksFetchRequest: FetchRequest<Subtask>
    var subtasks: FetchedResults<Subtask> {
        subtasksFetchRequest.wrappedValue
    }

    var body: some View {
        List {
            ForEach(todayReminders, id: \.self) { reminder in
                ReminderRowView(reminderList: reminder.list,
                                reminder: reminder,
                                remindersFetchRequest: fetchTodayReminders)
                ForEach(subtasks, id: \.self) { subtask in
                    if subtask.reminder == reminder {
                        SubtaskRowView(reminder: reminder, subtask: subtask)
                            .moveDisabled(true)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitle("Today", displayMode: .large)
        .navigationBarTitleTextColor(UIColor(.blue))
    }
}

struct TodayRemindersView_Previews: PreviewProvider {
    static var fetchTodayReminders: FetchRequest<Reminder> = Reminder.fetchReminders(predicate: .today)
    static var subtasksFetchRequest: FetchRequest<Subtask> = Subtask.fetchSubtasks()
    static var previews: some View {
        return NavigationStack {
            TodayRemindersView(fetchTodayReminders: fetchTodayReminders,
                               subtasksFetchRequest: subtasksFetchRequest)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
