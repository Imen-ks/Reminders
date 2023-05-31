//
//  EditReminderListView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct EditReminderListView: View {
    @Binding var isEditingReminderList: Bool
    let reminderList: ReminderList
    @StateObject var viewModel: EditReminderListViewModel

    init(isEditingReminderList: Binding<Bool>, reminderList: ReminderList) {
        self._isEditingReminderList = isEditingReminderList
        self.reminderList = reminderList
        self._viewModel = .init(wrappedValue: EditReminderListViewModel(reminderList: reminderList))
    }

    var body: some View {
        Form {
            Section {
                CreateListTitleView(listTitle: $viewModel.listTitle, selectedColor: $viewModel.selectedColor)
            }

            Section {
                SelectListColorView(selectedColor: $viewModel.selectedColor)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isEditingReminderList.toggle()
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.updateReminderList(reminderList: reminderList)
                    isEditingReminderList.toggle()
                } label: {
                    Text("Done")
                }
                .disabled(viewModel.listTitle.isEmpty)
            }
        }
    }
}

struct EditReminderListView_Previews: PreviewProvider {
    static var reminderList = CoreDataManager.reminderListForPreview()
    static var previews: some View {
        NavigationStack {
            EditReminderListView(isEditingReminderList: .constant(true), reminderList: reminderList)
        }
    }
}
