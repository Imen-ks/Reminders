//
//  RemindersView.swift
//  Reminders
//
//  Created by Imen Ksouri on 10/05/2023.
//

import SwiftUI

struct RemindersView: View {
    @State private var isAddingReminder = false
    @State private var isSavingTemplate = false
    let reminderList: ReminderList
    @Binding var sortDescriptor: SortDescriptor
    @Binding var isTemplate: Bool
    @StateObject var viewModel = DisplayReminderViewModel()

    var body: some View {
        List {
            if isTemplate {
                Text("Template")
                    .foregroundColor(.secondary)
            }
            ForEach(viewModel.dataManager.getReminders(
                in: reminderList, sortDescriptor: sortDescriptor), id: \.self) { reminder in
                ReminderRowView(reminderList: reminderList,
                                reminder: reminder)
                    ForEach(viewModel.subtasks, id: \.self) { subtask in
                    if subtask.reminder == reminder {
                        SubtaskRowView(reminder: reminder, subtask: subtask)
                            .moveDisabled(true)
                    }
                }
            }
            .onDelete { offsets in
                withAnimation {
                    viewModel.reminders = viewModel.dataManager.getReminders(
                        in: reminderList, sortDescriptor: sortDescriptor)
                    viewModel.delete(at: offsets)
                }
            }
            .onMove { source, destination in
                withAnimation {
                    viewModel.reminders = viewModel.dataManager.getReminders(
                        in: reminderList, sortDescriptor: sortDescriptor)
                    viewModel.move(from: source, to: destination)
                    sortDescriptor = .none
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
                                                reminders: viewModel.dataManager.getReminders(
                                                    in: reminderList, sortDescriptor: sortDescriptor),
                                                subtasks: viewModel.subtasks),
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
        let reminderList = CoreDataManager.reminderListForPreview()
        // swiftlint:disable:next redundant_discardable_let
        let _ = CoreDataManager.reminderForPreview(reminderList: reminderList)
        return NavigationStack {
            RemindersView(
                reminderList: reminderList,
                sortDescriptor: $sortDescriptor,
                isTemplate: .constant(false),
                viewModel: DisplayReminderViewModel(dataManager: .preview))
        }
    }
}
