//
//  AllRemindersView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct AllRemindersView: View {
    var fetchAllReminders: FetchRequest<Reminder>
    var allReminders: [Reminder] {
        return Array(fetchAllReminders.wrappedValue)
            .sorted { $0.dueDate ?? $0.dateCreated < $1.dueDate ?? $1.dateCreated }
    }
    var reminderLists: [ReminderList] {
        Set(allReminders.map { $0.list }).sorted { $0.order < $1.order }
    }

    var subtasksFetchRequest: FetchRequest<Subtask>
    var subtasks: FetchedResults<Subtask> {
        subtasksFetchRequest.wrappedValue
    }

    var body: some View {
        List {
            ForEach(reminderLists, id: \.self) { list in
                Text(list.title)
                    .font(.title3)
                    .foregroundColor(Color(list.color))
                    .fontWeight(.bold)
                ForEach(allReminders.filter { $0.list == list }, id: \.self) { reminder in
                    Section {
                    ReminderRowView(reminderList: reminder.list,
                                    reminder: reminder,
                                    remindersFetchRequest: fetchAllReminders)
                        ForEach(subtasks, id: \.self) { subtask in
                            if subtask.reminder == reminder {
                                SubtaskRowView(reminder: reminder, subtask: subtask)
                                    .moveDisabled(true)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitle("All", displayMode: .large)
    }
}

struct AllRemindersView_Previews: PreviewProvider {
    static var fetchAllReminders: FetchRequest<Reminder> = Reminder.fetchReminders(predicate: .all)
    static var subtasksFetchRequest: FetchRequest<Subtask> = Subtask.fetchSubtasks()
    static var previews: some View {
        return NavigationStack {
            AllRemindersView(fetchAllReminders: fetchAllReminders,
                             subtasksFetchRequest: subtasksFetchRequest)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
