//
//  CreateReminderView.swift
//  Reminders
//
//  Created by Imen Ksouri on 12/05/2023.
//

import SwiftUI

struct CreateReminderView: View {
    let reminderList: ReminderList
    @Binding var isAddingReminder: Bool
    @StateObject var viewModel: CreateReminderViewModel

    init(reminderList: ReminderList, isAddingReminder: Binding<Bool>) {
        self.reminderList = reminderList
        self._isAddingReminder = isAddingReminder
        self._viewModel = .init(wrappedValue: CreateReminderViewModel(
            reminderList: reminderList))
    }

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $viewModel.title)
                TextField("Notes", text: $viewModel.notes, axis: .vertical)
                    .frame(height: 100, alignment: .top)
            }

            Section {
                NavigationLink {
                    CreateReminderDetailsView(
                        reminderList: viewModel.selectedList,
                        isAddingReminder: $isAddingReminder,
                        viewModel: viewModel
                    ) {
                        viewModel.addReminder()
                    }
                } label: {
                    Text("Details")
                }
            }

            Section {
                NavigationLink {
                    SelectListView(reminderList: $viewModel.selectedList)
                } label: {
                    HStack {
                        Text("List")
                        Spacer()
                        HStack {
                            Circle()
                                .frame(width: 8)
                                .foregroundColor(Color(viewModel.selectedList.color))
                            Text(viewModel.selectedList.title)
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
                    viewModel.addReminder()
                    isAddingReminder.toggle()
                } label: {
                    Text("Add")
                }
                .disabled(viewModel.title.isEmpty)
            }
        }
    }
}

struct CreateReminderView_Previews: PreviewProvider {
    static var previews: some View {
        let reminderList = CoreDataManager.reminderListForPreview()
        return NavigationStack {
            CreateReminderView(reminderList: reminderList,
                               isAddingReminder: .constant(false))
        }
    }
}
