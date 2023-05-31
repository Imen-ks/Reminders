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
                    .overlay {
                        Button {
                            isEditingTemplate.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.plain)
                        .sheet(isPresented: $isEditingTemplate) {
                            NavigationStack {
                                RemindersView(
                                    reminderList: reminderTemplate,
                                    sortDescriptor: $viewModel.sortDescriptor,
                                    isTemplate: $isTemplate)
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button {
                                            isEditingTemplate.toggle()
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
