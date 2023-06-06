//
//  SelectTemplateView.swift
//  Reminders
//
//  Created by Imen Ksouri on 20/05/2023.
//

import SwiftUI

struct SelectTemplateView: View {
    @State private var isEditingReminderList = false
    @State private var isTemplate = true
    @State private var isEditingTemplate = false
    @State private var selectedList: ReminderList?
    @State private var isTapped = false
    @Binding var isAddingReminderList: Bool
    @StateObject var viewModel = SelectTemplateViewModel()

    var body: some View {
        List {
            ForEach(viewModel.templates, id: \.self) { reminderTemplate in
                HStack {
                    ReminderListRowView(
                        reminderList: reminderTemplate,
                        isEditingReminderList: $isEditingReminderList,
                        isTemplate: $isTemplate)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isTapped.toggle()
                    }
                    .alert("Name List", isPresented: $isTapped) {
                        TextField("List Name", text: $viewModel.nameList)
                        Button("Create") {
                            viewModel.createReminderListFromTemplate(template: reminderTemplate)
                            isAddingReminderList.toggle()
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                    Spacer()
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            selectedList = reminderTemplate
                            isEditingTemplate.toggle()
                        }
                }
            }
        }
        .sheet(isPresented: .constant(isEditingTemplate && selectedList != nil)) {
            NavigationStack {
                if let selectedList = selectedList {
                    RemindersView(
                        reminderList: selectedList,
                        sortDescriptor: $viewModel.sortDescriptor,
                        isTemplate: $isTemplate)
                    .interactiveDismissDisabled()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                isEditingTemplate.toggle()
                                self.selectedList = nil
                            } label: {
                                Text("Done")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SelectTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectTemplateView(
                isAddingReminderList: .constant(true),
                viewModel: SelectTemplateViewModel(dataManager: .preview))
        }
    }
}
