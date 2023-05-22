//
//  ButtonAddReminderListView.swift
//  Reminders
//
//  Created by Imen Ksouri on 11/05/2023.
//

import SwiftUI

struct ButtonAddReminderListView: View {
    @Binding var isAddingReminderList: Bool

    var body: some View {
        Button {
            isAddingReminderList.toggle()
        } label: {
            Text("Add list")
        }
        .sheet(isPresented: $isAddingReminderList) {
            NavigationStack {
                CreateReminderListView(isAddingReminderList: $isAddingReminderList)
            }
        }
    }
}

struct ButtonAddReminderListView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonAddReminderListView(isAddingReminderList: .constant(false))
    }
}
