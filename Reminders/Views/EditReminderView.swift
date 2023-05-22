//
//  EditReminderView.swift
//  Reminders
//
//  Created by Imen Ksouri on 14/05/2023.
//

import SwiftUI

struct EditReminderView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var title: String
    @State private var notes: String
    @State private var isAddingDueDate: Bool
    @State private var isAddingDueHour: Bool
    @State private var dueDate: Date?
    @State private var dueHour: Date?
    @State private var tags: String = ""
    @State private var isFlagging: Bool
    @State private var priority: ReminderPriority
    @State private var isAddingImage: Bool = false
    @State private var reminderList: ReminderList
    @Binding var isShowingDetails: Bool
    let reminder: Reminder
    @State private var pictures: [(id: UUID, data: Data)] = []
    @State private var removedPictures: [Picture] = []
    @State private var subtasks: [String] = []
    @State private var removedSubtasks: [Subtask] = []
    @State private var updated: [Subtask] = []
    @State private var removed: [Subtask] = []
    @State private var added: [String] = []

    init(reminderList: ReminderList, isShowingDetails: Binding<Bool>, reminder: Reminder) {
        self._title = .init(wrappedValue: reminder.title)
        self._notes = .init(wrappedValue: reminder.notes)
        self._isAddingDueDate = .init(wrappedValue: reminder.dueDate != nil)
        self._isAddingDueHour = .init(wrappedValue: reminder.dueHour != nil)
        self._dueDate = .init(wrappedValue: reminder.dueDate)
        self._dueHour = .init(wrappedValue: reminder.dueHour)
        self._isFlagging = .init(wrappedValue: reminder.isFlagged)
        self._priority = .init(wrappedValue: ReminderPriority(rawValue: reminder.priority) ?? .none)
        self.reminder = reminder
        self._reminderList = .init(wrappedValue: reminderList)
        self._isShowingDetails = isShowingDetails
    }

    var body: some View {
        NavigationStack {
            Form {
                SelectDueDateAndHourView(isAddingDueDate: $isAddingDueDate,
                                         isAddingDueHour: $isAddingDueHour,
                                         dueDate: $dueDate,
                                         dueHour: $dueHour)

                SelectTagView(tags: $tags)

                FlagView(isFlagging: $isFlagging)

                Section {
                    SelectPriorityView(priority: $priority)

                    NavigationLink {
                        SelectListView(reminderList: $reminderList)
                    } label: {
                        HStack {
                            Text("List")
                            Spacer()
                            HStack {
                                Circle()
                                    .frame(width: 8)
                                    .foregroundColor(Color(reminderList.color))
                                Text(reminder.list.title)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                Section {
                    NavigationLink {
                        EditSubtaskView(reminder: reminder,
                                        subtasks: $subtasks,
                                        removedSubtasks: $removedSubtasks,
                                        updated: $updated,
                                        removed: $removed,
                                        added: $added)
                    } label: {
                        HStack {
                            Text("Subtasks")
                            Spacer()
                            if reminder.subtaskCount > 0 {
                                Text("\(reminder.subtaskCount - removedSubtasks.count + added.count)")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                Section {
                    PhotoPickerView(isAddingImage: $isAddingImage, pictures: $pictures)
                    AddImageView(pictures: $pictures)
                }

                EditImageView(reminder: reminder, removedPictures: $removedPictures)
            }
            .navigationBarTitle("Details", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingDetails.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            removedPictures.forEach(viewContext.delete)
                            removedSubtasks.forEach(viewContext.delete)
                            Reminder.update(reminder: reminder,
                                            title: title,
                                            notes: notes,
                                            dueDate: dueDate,
                                            dueHour: dueHour,
                                            priority: priority.rawValue,
                                            isFlagged: isFlagging,
                                            list: reminderList,
                                            subtasks: subtasks,
                                            pictures: pictures,
                                            context: viewContext)
                            isShowingDetails.toggle()
                        }
                    } label: {
                        Text("Done")
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
    }
}

struct EditReminderView_Previews: PreviewProvider {
    static var previews: some View {
        let reminderList = PersistenceController.reminderListForPreview()
        let reminder = PersistenceController.reminderForPreview(reminderList: reminderList)
        // swiftlint:disable:next redundant_discardable_let
        let _ = PersistenceController.pictureForPreview(reminder: reminder)
        // swiftlint:disable:next redundant_discardable_let
        let _ = PersistenceController.subtaskForPreview(reminder: reminder)
        return NavigationStack {
            EditReminderView(reminderList: reminderList, isShowingDetails: .constant(false), reminder: reminder)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
