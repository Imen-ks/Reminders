//
//  AllRemindersView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct AllRemindersView: View {
    @StateObject var viewModel: SummaryViewModel

    var reminderLists: [ReminderList] {
        Set(viewModel.allReminders.map { $0.list }).sorted { $0.order < $1.order }
    }

    var body: some View {
        List {
            ForEach(reminderLists, id: \.self) { list in
                Text(list.title)
                    .font(.title3)
                    .foregroundColor(Color(list.color))
                    .fontWeight(.bold)
                ForEach(viewModel.allReminders.filter { $0.list == list }, id: \.self) { reminder in
                    Section {
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
            }
        }
        .listStyle(.plain)
        .navigationBarTitle("All", displayMode: .large)
    }
}

struct AllRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationStack {
            AllRemindersView(viewModel: SummaryViewModel(dataManager: .preview))
        }
    }
}
