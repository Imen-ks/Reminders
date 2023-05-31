//
//  SaveTemplateView.swift
//  Reminders
//
//  Created by Imen Ksouri on 20/05/2023.
//

import SwiftUI

struct SaveTemplateView: View {
    @Binding var isSavingTemplate: Bool
    let reminderList: ReminderList
    @StateObject var viewModel: SaveTemplateViewModel

    init(isSavingTemplate: Binding<Bool>, reminderList: ReminderList) {
        self._isSavingTemplate = isSavingTemplate
        self.reminderList = reminderList
        self._viewModel = .init(wrappedValue: SaveTemplateViewModel(reminderList: reminderList))
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
                    isSavingTemplate.toggle()
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.saveAsTemplate(reminderList: reminderList)
                    isSavingTemplate.toggle()
                } label: {
                    Text("Save")
                }
                .disabled(viewModel.listTitle.isEmpty)
            }
        }
    }
}

struct SaveTemplateView_Previews: PreviewProvider {
    static var reminderList = CoreDataManager.reminderListForPreview()
    static var previews: some View {
        SaveTemplateView(isSavingTemplate: .constant(true), reminderList: reminderList)
    }
}
