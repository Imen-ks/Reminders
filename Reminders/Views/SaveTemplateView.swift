//
//  SaveTemplateView.swift
//  Reminders
//
//  Created by Imen Ksouri on 20/05/2023.
//

import SwiftUI

struct SaveTemplateView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var listTitle: String
    @State private var selectedColor: Color
    @Binding var isSavingTemplate: Bool
    let reminderList: ReminderList

    var remindersFetchRequest: FetchRequest<Reminder>
    var reminders: FetchedResults<Reminder> {
        return remindersFetchRequest.wrappedValue
    }

    var subtasksFetchRequest: FetchRequest<Subtask>
    var subtasks: FetchedResults<Subtask> {
        subtasksFetchRequest.wrappedValue
    }

    init(isSavingTemplate: Binding<Bool>,
         reminderList: ReminderList) {
        self._listTitle = .init(wrappedValue: reminderList.title)
        self._selectedColor = .init(wrappedValue: Color(reminderList.color))
        self._isSavingTemplate = isSavingTemplate
        self.reminderList = reminderList
        self.remindersFetchRequest = Reminder.fetchReminders(in: reminderList, sortDescriptor: .none)
        self.subtasksFetchRequest = Subtask.fetchSubtasks()
    }
    var body: some View {
        Form {
            Section {
                CreateListTitleView(listTitle: $listTitle, selectedColor: $selectedColor)
            }
            Section {
                SelectListColorView(selectedColor: $selectedColor)
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
                    ReminderList.saveAsTemplate(
                        reminderList: reminderList,
                        title: listTitle,
                        color: UIColor(selectedColor),
                        reminders: reminders,
                        subtasks: subtasks,
                        context: viewContext)
                    isSavingTemplate.toggle()
                } label: {
                    Text("Save")
                }
                .disabled(listTitle.isEmpty)
            }
        }
    }
}

struct SaveTemplateView_Previews: PreviewProvider {
    static var reminderList = PersistenceController.reminderListForPreview()
    static var previews: some View {
        SaveTemplateView(isSavingTemplate: .constant(true), reminderList: reminderList)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
