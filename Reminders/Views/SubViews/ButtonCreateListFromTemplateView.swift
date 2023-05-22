//
//  ButtonCreateListFromTemplateView.swift
//  Reminders
//
//  Created by Imen Ksouri on 21/05/2023.
//

import SwiftUI

struct ButtonCreateListFromTemplateView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Binding var nameList: String
    @Binding var isAddingReminderList: Bool
    let template: ReminderList

    var remindersFetchRequest: FetchRequest<Reminder>
    var reminders: FetchedResults<Reminder> {
        return remindersFetchRequest.wrappedValue
    }

    var subtasksFetchRequest: FetchRequest<Subtask> = Subtask.fetchSubtasks()
    var subtasks: FetchedResults<Subtask> {
        subtasksFetchRequest.wrappedValue
    }

    init(nameList: Binding<String>, isAddingReminderList: Binding<Bool>, template: ReminderList) {
        self._nameList = nameList
        self._isAddingReminderList = isAddingReminderList
        self.template = template
        self.remindersFetchRequest = Reminder.fetchReminders(in: template, sortDescriptor: .none)
        self.subtasksFetchRequest = Subtask.fetchSubtasks()
    }

    var body: some View {
        Button("Create") {
            ReminderList
                .createReminderListFromTemplate(template: template,
                                                title: nameList,
                                                reminders: reminders,
                                                subtasks: subtasks,
                                                context: viewContext)
            isAddingReminderList.toggle()
        }
    }
}

struct ButtonCreateListFromTemplateView_Previews: PreviewProvider {
    @State static var nameList = ""
    @State static var isAddingReminderList = true
    static var template = PersistenceController.reminderListForPreview()
    static var previews: some View {
        ButtonCreateListFromTemplateView(nameList: $nameList,
                                         isAddingReminderList: $isAddingReminderList,
                                         template: template)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
