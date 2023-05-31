//
//  EditReminderView.swift
//  Reminders
//
//  Created by Imen Ksouri on 14/05/2023.
//

import SwiftUI

struct EditReminderView: View {
    @State private var isAddingImage: Bool = false
    @Binding var isShowingDetails: Bool
    let reminderList: ReminderList
    let reminder: Reminder
    @StateObject var viewModel: EditReminderViewModel

    init(reminderList: ReminderList, isShowingDetails: Binding<Bool>, reminder: Reminder) {
        self.reminderList = reminderList
        self.reminder = reminder
        self._isShowingDetails = isShowingDetails
        self._viewModel = .init(wrappedValue: EditReminderViewModel(reminderList: reminderList, reminder: reminder))
    }

    var body: some View {
        NavigationStack {
            Form {
                SelectDueDateAndHourView(isAddingDueDate: $viewModel.isAddingDueDate,
                                         isAddingDueHour: $viewModel.isAddingDueHour,
                                         dueDate: $viewModel.dueDate,
                                         dueHour: $viewModel.dueHour)

                SelectTagView(tags: $viewModel.tags)

                FlagView(isFlagging: $viewModel.isFlagging)

                Section {
                    SelectPriorityView(priority: $viewModel.priority)

                    NavigationLink {
                        SelectListView(reminderList: $viewModel.selectedList)
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
                                        subtasks: $viewModel.subtasks,
                                        removedSubtasks: $viewModel.removedSubtasks,
                                        updated: $viewModel.updated,
                                        removed: $viewModel.removed,
                                        added: $viewModel.added,
                                        storedSubtasks: $viewModel.storedSubtasks)
                    } label: {
                        HStack {
                            Text("Subtasks")
                            Spacer()
                            if reminder.subtaskCount > 0 {
                                Text("""
                                    \(reminder.subtaskCount - viewModel.removedSubtasks.count + viewModel.added.count)
                                """)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                Section {
                    PhotoPickerView(isAddingImage: $isAddingImage, pictures: $viewModel.pictures)
                    AddImageView(pictures: $viewModel.pictures)
                }

                EditImageView(reminder: reminder,
                              removedPictures: $viewModel.removedPictures,
                              storedPictures: $viewModel.storedPictures)
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
                            for picture in viewModel.removedPictures {
                                viewModel.delete(picture)
                            }
                            for subtask in viewModel.removedSubtasks {
                                viewModel.delete(subtask)
                            }
                            viewModel.updateReminder(
                                reminder: reminder,
                                list: reminderList)
                            isShowingDetails.toggle()
                        }
                    } label: {
                        Text("Done")
                    }
                    .disabled(viewModel.title.isEmpty)
                }
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
    }
}

struct EditReminderView_Previews: PreviewProvider {
    static var previews: some View {
        let reminderList = CoreDataManager.reminderListForPreview()
        let reminder = CoreDataManager.reminderForPreview(reminderList: reminderList)
        // swiftlint:disable:next redundant_discardable_let
        let _ = CoreDataManager.pictureForPreview(reminder: reminder)
        // swiftlint:disable:next redundant_discardable_let
        let _ = CoreDataManager.subtaskForPreview(reminder: reminder)
        return NavigationStack {
            EditReminderView(reminderList: reminderList, isShowingDetails: .constant(false), reminder: reminder)
        }
    }
}
