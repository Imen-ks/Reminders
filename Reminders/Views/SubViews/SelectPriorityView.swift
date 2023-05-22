//
//  SelectPriorityView.swift
//  Reminders
//
//  Created by Imen Ksouri on 13/05/2023.
//

import SwiftUI

struct SelectPriorityView: View {
    @Binding var priority: ReminderPriority

    var body: some View {
        Picker("Priority", selection: $priority) {
            ForEach(ReminderPriority.allCases, id: \.self) { priority in
                Text("\(priority.fullDisplay)")
            }
        }
        .pickerStyle(.automatic)
    }
}

struct SelectPriorityView_Previews: PreviewProvider {
    @State static var priority = ReminderPriority.none
    static var previews: some View {
        NavigationStack {
            Form {
                SelectPriorityView(priority: $priority)
            }
        }
    }
}
