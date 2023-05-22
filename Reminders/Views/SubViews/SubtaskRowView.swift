//
//  SubtaskRowView.swift
//  Reminders
//
//  Created by Imen Ksouri on 19/05/2023.
//

import SwiftUI

struct SubtaskRowView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var title: String
    let reminder: Reminder
    let subtask: Subtask

    init(reminder: Reminder, subtask: Subtask) {
        self._title = .init(wrappedValue: subtask.title)
        self.reminder = reminder
        self.subtask = subtask
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .padding(4)
                    .foregroundColor(Color(reminder.list.color))
                    .frame(width: 20, height: 20)

                TextField("", text: $title)
                    .padding(.leading, 5)
            }
        }
        .padding(.leading, 28)
        .onChange(of: title, perform: { newValue in
            Subtask.update(subtask: subtask,
                           title: newValue,
                           context: viewContext)
        })
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                withAnimation {
                    viewContext.delete(subtask)
                    PersistenceController.save(viewContext)
                }
            } label: {
                Text("Delete")
            }
            .tint(.red)
        }
    }
}

struct SubtaskRowView_Previews: PreviewProvider {
    static var reminderList = PersistenceController.reminderListForPreview()
    static var reminder = PersistenceController.reminderForPreview(reminderList: reminderList)
    static var subtask = PersistenceController.subtaskForPreview(reminder: reminder)
    static var previews: some View {
        VStack(alignment: .leading) {
            SubtaskRowView(reminder: reminder, subtask: subtask)
            Divider()
                .padding(.leading, 33)
        }
    }
}
