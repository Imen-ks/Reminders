//
//  CompletedRemindersView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct CompletedRemindersView: View {
    @StateObject var viewModel: SummaryViewModel

    var body: some View {
        List {
            ForEach(viewModel.completedReminders, id: \.self) { reminder in
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
        .navigationBarTitle("Completed", displayMode: .large)
        .navigationBarTitleTextColor(UIColor(.gray))
    }
}

struct CompletedRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationStack {
            CompletedRemindersView(viewModel: SummaryViewModel(dataManager: .preview))
        }
    }
}
