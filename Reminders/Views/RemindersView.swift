//
//  RemindersView.swift
//  Reminders
//
//  Created by Imen Ksouri on 10/05/2023.
//

import SwiftUI

struct RemindersView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var isAddingReminder = false
    @State private var isSavingTemplate = false
    @Binding var sortDescriptor: SortDescriptor
    @Binding var isTemplate: Bool
    let reminderList: ReminderList
    var fetchRequest: FetchRequest<Reminder>
    var reminders: FetchedResults<Reminder> {
        return fetchRequest.wrappedValue
    }
    var subtasksFetchRequest: FetchRequest<Subtask>
    var subtasks: FetchedResults<Subtask> {
        subtasksFetchRequest.wrappedValue
    }

    init(reminderList: ReminderList, sortDescriptor: Binding<SortDescriptor>, isTemplate: Binding<Bool>) {
        self.reminderList = reminderList
        self._sortDescriptor = sortDescriptor
        self._isTemplate = isTemplate
        self.fetchRequest = Reminder.fetchReminders(in: reminderList, sortDescriptor: sortDescriptor.wrappedValue)
        self.subtasksFetchRequest = Subtask.fetchSubtasks()
    }

    var body: some View {
        List {
            if isTemplate {
                Text("Template")
                    .foregroundColor(.secondary)
            }
            ForEach(reminders, id: \.self) { reminder in
                ReminderRowView(reminderList: reminderList,
                                reminder: reminder,
                                remindersFetchRequest: fetchRequest)
                ForEach(subtasks, id: \.self) { subtask in
                    if subtask.reminder == reminder {
                        SubtaskRowView(reminder: reminder, subtask: subtask)
                            .moveDisabled(true)
                    }
                }
            }
            .onDelete { offsets in
                withAnimation {
                    offsets.map { reminders[$0] }.forEach(viewContext.delete)
                    PersistenceController.save(viewContext)
                }
            }
            .onMove { source, destination in
                withAnimation {
                    self.sortDescriptor = .none
                    var reminders: [Reminder] = self.reminders.map { $0 }
                    reminders.move(fromOffsets: source, toOffset: destination )
                    for reverseIndex in stride(from: reminders.count - 1,
                                               through: 0,
                                               by: -1) {
                        reminders[reverseIndex].order = Int16(reverseIndex)
                    }
                    PersistenceController.save(viewContext)
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitle(reminderList.title, displayMode: .large)
        .navigationBarTitleTextColor(reminderList.color)
        .toolbar {
            if !isTemplate {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        EditButton()
                        SharingView(render: render(
                        view: RenderedToPdfView(reminderList: reminderList,
                                                reminders: reminders,
                                                subtasks: subtasks),
                        path: "\(reminderList.title).pdf"))
                        ReminderSortMenuView(sortDescriptor: $sortDescriptor)
                    }
                }
            }
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    ButtonAddReminderView(isAddingReminder: $isAddingReminder,
                                          color: Color(reminderList.color),
                                          reminderList: reminderList)
                    Spacer()
                    if !isTemplate {
                        ButtonSaveTemplateView(isSavingTemplate: $isSavingTemplate, reminderList: reminderList)
                    }
                }
            }
        }
    }
}

struct RemindersView_Previews: PreviewProvider {
    @State static var sortDescriptor = SortDescriptor.dateCreated
    static var previews: some View {
        let reminderList = PersistenceController.reminderListForPreview()
        let reminder = PersistenceController.reminderForPreview(reminderList: reminderList)
        // swiftlint:disable:next redundant_discardable_let
        let _ = PersistenceController.pictureForPreview(reminder: reminder)
        // swiftlint:disable:next redundant_discardable_let
        let _ = PersistenceController.subtaskForPreview(reminder: reminder)
        return NavigationStack {
            RemindersView(reminderList: reminderList, sortDescriptor: $sortDescriptor, isTemplate: .constant(false))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
