//
//  TodayRemindersView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct TodayRemindersView: View {
    @StateObject var viewModel: SummaryViewModel

    var body: some View {
        List {
            ForEach(viewModel.todayReminders, id: \.self) { reminder in
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
        .navigationBarTitle("Today", displayMode: .large)
        .navigationBarTitleTextColor(UIColor(.blue))
    }
}

struct TodayRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationStack {
            TodayRemindersView(viewModel: SummaryViewModel(dataManager: .preview))
        }
    }
}
