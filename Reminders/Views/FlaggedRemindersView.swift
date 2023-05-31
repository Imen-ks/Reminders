//
//  FlaggedRemindersView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct FlaggedRemindersView: View {
    @StateObject var viewModel: SummaryViewModel

    var body: some View {
        List {
            ForEach(viewModel.flaggedReminders, id: \.self) { reminder in
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
        .navigationBarTitle("Flagged", displayMode: .large)
        .navigationBarTitleTextColor(UIColor(.orange))
    }
}

struct FlaggedRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationStack {
            FlaggedRemindersView(viewModel: SummaryViewModel(dataManager: .preview))
        }
    }
}
