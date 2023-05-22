//
//  CreateReminderView.swift
//  Reminders
//
//  Created by Imen Ksouri on 12/05/2023.
//

import SwiftUI

struct CreateReminderView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var title = ""
    @State private var notes = ""
    @State private var dueDate: Date?
    @State private var dueHour: Date?
    @State private var tags = ""
    @State private var isFlagging = false
    @State private var priority = ReminderPriority.none
    let reminderList: ReminderList
    @Binding var isAddingReminder: Bool
    @State private var selectedList: ReminderList
    @State private var subtasks: [String] = []
    @State private var pictures: [(id: UUID, data: Data)] = []

    init(reminderList: ReminderList, isAddingReminder: Binding<Bool>) {
        self.reminderList = reminderList
        self._isAddingReminder = isAddingReminder
        self._selectedList = .init(wrappedValue: reminderList)
    }

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title)
                TextField("Notes", text: $notes, axis: .vertical)
                    .frame(height: 100, alignment: .top)
            }

            Section {
                NavigationLink {
                    CreateReminderDetailsView(title: $title,
                                              notes: $notes,
                                              dueDate: $dueDate,
                                              dueHour: $dueHour,
                                              tags: $tags,
                                              isFlagging: $isFlagging,
                                              priority: $priority,
                                              reminderList: selectedList,
                                              isAddingReminder: $isAddingReminder,
                                              subtasks: $subtasks,
                                              pictures: $pictures)
                } label: {
                    Text("Details")
                }
            }

            Section {
                NavigationLink {
                    SelectListView(reminderList: $selectedList)
                } label: {
                    HStack {
                        Text("List")
                        Spacer()
                        HStack {
                            Circle()
                                .frame(width: 8)
                                .foregroundColor(Color(selectedList.color))
                            Text(selectedList.title)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("New Reminder", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isAddingReminder.toggle()
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Reminder.create(title: title,
                                    notes: notes,
                                    dueDate: dueDate,
                                    dueHour: dueHour,
                                    priority: priority.rawValue,
                                    isFlagged: isFlagging,
                                    list: selectedList,
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

struct CreateReminderView_Previews: PreviewProvider {
    static var previews: some View {
        let reminderList = PersistenceController.reminderListForPreview()
        return NavigationStack {
            CreateReminderView(reminderList: reminderList, isAddingReminder: .constant(false))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
