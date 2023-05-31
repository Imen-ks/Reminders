//
//  SubtaskRowView.swift
//  Reminders
//
//  Created by Imen Ksouri on 19/05/2023.
//

import SwiftUI

struct SubtaskRowView: View {
    let reminder: Reminder
    let subtask: Subtask
    @StateObject var viewModel: ReminderRowViewModel

    init(reminder: Reminder, subtask: Subtask) {
        self.reminder = reminder
        self.subtask = subtask
        self._viewModel = .init(wrappedValue: ReminderRowViewModel(reminder: reminder, subtask: subtask))
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .padding(4)
                    .foregroundColor(Color(reminder.list.color))
                    .frame(width: 20, height: 20)

                TextField("", text: Binding<String>(
                    get: {viewModel.subtaskTitle ?? subtask.title},
                    set: {viewModel.subtaskTitle = $0}))
                    .padding(.leading, 5)
            }
        }
        .padding(.leading, 28)
        .onChange(of: viewModel.subtaskTitle ?? subtask.title, perform: { newValue in
            viewModel.updateSubtask(title: newValue)
        })
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                withAnimation {
                    viewModel.delete(subtask)
                }
            } label: {
                Text("Delete")
            }
            .tint(.red)
        }
    }
}

struct SubtaskRowView_Previews: PreviewProvider {
    static var reminderList = CoreDataManager.reminderListForPreview()
    static var reminder = CoreDataManager.reminderForPreview(reminderList: reminderList)
    static var subtask = CoreDataManager.subtaskForPreview(reminder: reminder)
    static var previews: some View {
        VStack(alignment: .leading) {
            SubtaskRowView(reminder: reminder, subtask: subtask)
            Divider()
                .padding(.leading, 33)
        }
    }
}
