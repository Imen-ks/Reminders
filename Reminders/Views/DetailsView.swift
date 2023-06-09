//
//  DetailsView.swift
//  Reminders
//
//  Created by Imen Ksouri on 06/06/2023.
//

import SwiftUI

enum ReminderPredicate: String {
    case all = "All"
    case today = "Today"
    case scheduled = "Scheduled"
    case flagged = "Flagged"
    case completed = "Completed"
}

struct DetailsView: View {
    @StateObject var viewModel: SummaryViewModel
    var keyPath: KeyPath<SummaryViewModel, [Reminder]>
    var predicate: ReminderPredicate
    var color: Color

    var reminderLists: [ReminderList] {
        Set(viewModel.allReminders.map { $0.list }).sorted { $0.order < $1.order }
    }

    var body: some View {
        List {
            if predicate == .all {
                ForEach(reminderLists, id: \.self) { list in
                    Text(list.title)
                        .font(.title3)
                        .foregroundColor(Color(list.color))
                        .fontWeight(.bold)
                    ForEach(viewModel[keyPath: keyPath].filter { $0.list == list }, id: \.self) { reminder in
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
            } else {
                ForEach(viewModel[keyPath: keyPath], id: \.self) { reminder in
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
        .listStyle(.plain)
        .navigationBarTitle(predicate.rawValue, displayMode: .large)
        .navigationBarTitleTextColor(UIColor(color))
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailsView(viewModel: SummaryViewModel(dataManager: .preview),
                        keyPath: \SummaryViewModel.allReminders,
                        predicate: .all,
                        color: .blue)
        }
    }
}
