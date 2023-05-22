//
//  ReminderSortMenuView.swift
//  Reminders
//
//  Created by Imen Ksouri on 12/05/2023.
//

import SwiftUI

enum SortDescriptor: String, CaseIterable {
    case title = "Title"
    case priority = "Priority"
    case dateCreated = "Creation Date"
    case dueDate = "Deadline"
    case none = "Manual"
}

struct ReminderSortMenuView: View {
    @Binding var sortDescriptor: SortDescriptor

    var body: some View {
        Menu {
            Section("Sort By") {
                ForEach(SortDescriptor.allCases, id: \.self) { sortType in
                    Button {
                        sortDescriptor = sortType
                    } label: {
                        Text(sortType.rawValue)
                        if self.sortDescriptor == sortType {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
}

struct ReminderSortMenuView_Previews: PreviewProvider {
    @State static var sortDescriptor = SortDescriptor.dateCreated
    static var previews: some View {
        ReminderSortMenuView(sortDescriptor: $sortDescriptor)
            .font(.system(size: 50))
    }
}
