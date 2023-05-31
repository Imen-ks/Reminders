//
//  ScheduledRemindersView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct ScheduledRemindersView: View {
    @StateObject var viewModel: SummaryViewModel

    var body: some View {
        List {
            ForEach(viewModel.scheduledReminders, id: \.self) { reminder in
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
        .navigationBarTitle("Scheduled", displayMode: .large)
        .navigationBarTitleTextColor(UIColor(.red))
    }
}

struct ScheduledRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationStack {
            ScheduledRemindersView(viewModel: SummaryViewModel(dataManager: .preview))
        }
    }
}
