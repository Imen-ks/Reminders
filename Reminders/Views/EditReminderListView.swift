//
//  EditReminderListView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct EditReminderListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var listTitle: String
    @State private var selectedColor: Color
    @Binding var isEditingReminderList: Bool
    let reminderList: ReminderList

    init(isEditingReminderList: Binding<Bool>, reminderList: ReminderList) {
        self._listTitle = .init(wrappedValue: reminderList.title)
        self._selectedColor = .init(wrappedValue: Color(reminderList.color))
        self._isEditingReminderList = isEditingReminderList
        self.reminderList = reminderList
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
                    isEditingReminderList.toggle()
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    ReminderList.update(reminderList: reminderList,
                                        title: listTitle,
                                        color: UIColor(selectedColor),
                                        context: viewContext)
                    isEditingReminderList.toggle()
                } label: {
                    Text("Done")
                }
                .disabled(listTitle.isEmpty)
            }
        }
    }
}

struct EditReminderListView_Previews: PreviewProvider {
    static var reminderList = PersistenceController.reminderListForPreview()
    static var previews: some View {
        NavigationStack {
            EditReminderListView(isEditingReminderList: .constant(true), reminderList: reminderList)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
