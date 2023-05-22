//
//  CreateReminderDetailsView.swift
//  Reminders
//
//  Created by Imen Ksouri on 12/05/2023.
//

import SwiftUI

struct CreateReminderDetailsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var isAddingDueDate = false
    @State private var isAddingDueHour = false
    @State private var isAddingImage = false
    @State private var newSubtasks: [String] = []
    @Binding var title: String
    @Binding var notes: String
    @Binding var dueDate: Date?
    @Binding var dueHour: Date?
    @Binding var tags: String
    @Binding var isFlagging: Bool
    @Binding var priority: ReminderPriority
    let reminderList: ReminderList
    @Binding var isAddingReminder: Bool
    @Binding var subtasks: [String]
    @Binding var pictures: [(id: UUID, data: Data)]

    var body: some View {
        Form {
            SelectDueDateAndHourView(isAddingDueDate: $isAddingDueDate,
                                     isAddingDueHour: $isAddingDueHour,
                                     dueDate: $dueDate,
                                     dueHour: $dueHour)

            SelectTagView(tags: $tags)

            FlagView(isFlagging: $isFlagging)

            SelectPriorityView(priority: $priority)

            Section {
                NavigationLink {
                    AddSubtaskView(subtasks: $subtasks, newSubtasks: $newSubtasks)
                } label: {
                    HStack {
                        Text("Subtasks")
                        Spacer()
                        Spacer()
                        if newSubtasks.count > 0 {
                            Text("\(newSubtasks.count)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            Section {
                PhotoPickerView(isAddingImage: $isAddingImage, pictures: $pictures)
                AddImageView(pictures: $pictures)
            }
        }
        .navigationBarTitle("Details", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Reminder.create(title: title,
                                    notes: notes,
                                    dueDate: dueDate,
                                    dueHour: dueHour,
                                    priority: priority.rawValue,
                                    isFlagged: isFlagging,
                                    list: reminderList,
                                    subtasks: subtasks,
                                    pictures: pictures,
                                    context: viewContext)
                    isAddingReminder.toggle()
                } label: {
                    Text("Add")
                }
                .disabled(title.isEmpty)
            }
        }
    }
}

struct CreateReminderDetailsView_Previews: PreviewProvider {
    @State static var title: String = ""
    @State static var notes: String = ""
    @State static var dueDate: Date? = Date.now
    @State static var dueHour: Date? = Date.now
    @State static var tags = ""
    @State static var isFlagging = false
    @State static var priority = ReminderPriority.none
    @State static var isAddingReminder = false
    @State static var pictures = [(id: UUID(), data: Data())]
    static var reminderList = PersistenceController.reminderListForPreview()
    @State static var subtasks: [String] = []

    static var previews: some View {
        NavigationStack {
            CreateReminderDetailsView(title: $title,
                                      notes: $notes,
                                      dueDate: $dueDate,
                                      dueHour: $dueHour,
                                      tags: $tags,
                                      isFlagging: $isFlagging,
                                      priority: $priority,
                                      reminderList: reminderList,
                                      isAddingReminder: $isAddingReminder,
                                      subtasks: $subtasks,
                                      pictures: $pictures)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
