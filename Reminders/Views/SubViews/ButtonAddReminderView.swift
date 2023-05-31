//
//  ButtonAddReminderView.swift
//  Reminders
//
//  Created by Imen Ksouri on 11/05/2023.
//

import SwiftUI

struct ButtonAddReminderView: View {
    @Binding var isAddingReminder: Bool
    let color: Color
    let reminderList: ReminderList

    var body: some View {
        Button {
            isAddingReminder.toggle()
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
                .bold()
            Text("New Reminder")
              .font(.headline)
        }
        .foregroundColor(color)
        .sheet(isPresented: $isAddingReminder) {
            NavigationStack {
                CreateReminderView(reminderList: reminderList, isAddingReminder: $isAddingReminder)
            }
        }
    }
}

struct ButtonAddReminderView_Previews: PreviewProvider {
    static var previews: some View {
        let reminderList = CoreDataManager.reminderListForPreview()
        ButtonAddReminderView(isAddingReminder: .constant(false), color: .accentColor, reminderList: reminderList)
    }
}
