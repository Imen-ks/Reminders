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
    var predicate: ReminderPredicate
    var color: Color

    var reminders: [Reminder] {
        if predicate == .today {
            return viewModel.todayReminders
        } else if predicate == .scheduled {
            return viewModel.scheduledReminders
        } else if predicate == .all {
            return viewModel.allReminders
        } else if predicate == .flagged {
            return viewModel.flaggedReminders
        } else if predicate == .completed {
            return viewModel.completedReminders
        }
        return [Reminder]()
    }

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
                    ForEach(reminders.filter { $0.list == list }, id: \.self) { reminder in
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
                ForEach(reminders, id: \.self) { reminder in
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
    static var predicate = ReminderPredicate.today
    static var previews: some View {
        NavigationStack {
            DetailsView(viewModel: SummaryViewModel(dataManager: .preview),
                        predicate: .today,
                        color: .blue)
        }
    }
}
