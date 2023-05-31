//
//  CreateReminderDetailsView.swift
//  Reminders
//
//  Created by Imen Ksouri on 12/05/2023.
//

import SwiftUI

struct CreateReminderDetailsView: View {
    @State private var isAddingImage = false
    let reminderList: ReminderList
    @Binding var isAddingReminder: Bool
    @StateObject var viewModel: CreateReminderViewModel
    var action: () -> Void

    var body: some View {
        Form {
            SelectDueDateAndHourView(isAddingDueDate: $viewModel.isAddingDueDate,
                                     isAddingDueHour: $viewModel.isAddingDueHour,
                                     dueDate: $viewModel.dueDate,
                                     dueHour: $viewModel.dueHour)

            SelectTagView(tags: $viewModel.tags)

            FlagView(isFlagging: $viewModel.isFlagging)

            SelectPriorityView(priority: $viewModel.priority)

            Section {
                NavigationLink {
                    AddSubtaskView(subtasks: $viewModel.subtasks, newSubtasks: $viewModel.newSubtasks)
                } label: {
                    HStack {
                        Text("Subtasks")
                        Spacer()
                        Spacer()
                        if viewModel.newSubtasks.count > 0 {
                            Text("\(viewModel.newSubtasks.count)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            Section {
                PhotoPickerView(isAddingImage: $isAddingImage, pictures: $viewModel.pictures)
                AddImageView(pictures: $viewModel.pictures)
            }
        }
        .navigationBarTitle("Details", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    action()
                    isAddingReminder.toggle()
                } label: {
                    Text("Add")
                }
                .disabled(viewModel.title.isEmpty)
            }
        }
    }
}

struct CreateReminderDetailsView_Previews: PreviewProvider {
    @State static var isAddingReminder = false
    static var reminderList = CoreDataManager.reminderListForPreview()
    @State static var subtasks: [String] = []

    static var previews: some View {
        NavigationStack {
            CreateReminderDetailsView(
                reminderList: reminderList,
                isAddingReminder: $isAddingReminder,
                viewModel: CreateReminderViewModel(
                    dataManager: CoreDataManager.preview,
                    reminderList: reminderList)
            ) {}
        }
    }
}
