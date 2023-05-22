//
//  RenderedToPdfView.swift
//  Reminders
//
//  Created by Imen Ksouri on 22/05/2023.
//

import SwiftUI

struct RenderedToPdfView: View {
    let reminderList: ReminderList
    var reminders: FetchedResults<Reminder>
    var subtasks: FetchedResults<Subtask>

    var gridColumns = Array(repeating: GridItem(.flexible()), count: 6)

    var body: some View {
        VStack {
            Text(reminderList.title)
                .font(.largeTitle)
                .foregroundColor(Color(reminderList.color))
                .fontWeight(.bold)
            ForEach(reminders, id: \.self) { reminder in
                let priority = ReminderPriority(rawValue: reminder.priority)?.shortDisplay ?? ""
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Circle()
                            .padding(4)
                            .overlay(
                                Circle()
                                    .stroke(Color(reminderList.color), lineWidth: 2)
                            )
                            .foregroundColor(reminder.isCompleted ? Color(reminderList.color) : .clear)
                            .frame(width: 20, height: 20)
                        if !priority.isEmpty {
                            Text(priority)
                        }
                        Text(reminder.title)
                        Spacer()
                        if reminder.isFlagged {
                            Image(systemName: "flag.fill")
                                .foregroundColor(.orange)
                        }
                    }
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(reminder.notes)
                            HStack {
                                if let dueDate = reminder.dueDate {
                                    Text("\(dueDate, formatter: dateFormatter)")
                                }

                                if let dueHour = reminder.dueHour {
                                    Text("\(dueHour, formatter: timeFormatter)")
                                }
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding(.leading, 28)
                }
                VStack(alignment: .leading) {
                    ForEach(subtasks, id: \.self) { subtask in
                        if subtask.reminder == reminder {
                            HStack {
                                Circle()
                                    .padding(4)
                                    .foregroundColor(Color(reminder.list.color))
                                    .frame(width: 20, height: 20)

                                Text(subtask.title)
                                    .padding(.leading, 5)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
