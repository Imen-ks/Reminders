//
//  ReminderListRowView.swift
//  Reminders
//
//  Created by Imen Ksouri on 12/05/2023.
//

import SwiftUI

struct ReminderListRowView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.editMode) private var editMode
    let reminderList: ReminderList
    @Binding var isEditingReminderList: Bool
    @Binding var isTemplate: Bool

    var body: some View {
        HStack {
            Image(systemName: "list.bullet")
                .foregroundColor(.white)
                .bold()
                .padding(12)
                .background(Color(reminderList.color))
                .clipShape(Circle())
            Text(reminderList.title)
            Spacer()
            if editMode?.wrappedValue.isEditing == false && !isTemplate {
                Text("\(reminderList.reminderCount)")
                    .foregroundColor(.secondary)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                withAnimation {
                    viewContext.delete(reminderList)
                    PersistenceController.save(viewContext)
                }
            } label: {
                Image(systemName: "trash")
            }
            .tint(.red)
            if !isTemplate {
                Button {
                    isEditingReminderList.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .sheet(isPresented: $isEditingReminderList) {
            NavigationStack {
                EditReminderListView(isEditingReminderList: $isEditingReminderList, reminderList: reminderList)
            }
        }
    }
}

struct ReminderListRowView_Previews: PreviewProvider {
    static var previews: some View {
        let reminderList = PersistenceController.reminderListForPreview()
        // swiftlint:disable:next redundant_discardable_let
        let _ = PersistenceController.reminderForPreview(reminderList: reminderList)
        return List {
            ReminderListRowView(
                reminderList: reminderList,
                isEditingReminderList: .constant(false),
                isTemplate: .constant(false))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
