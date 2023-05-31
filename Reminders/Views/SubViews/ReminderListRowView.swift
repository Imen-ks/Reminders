//
//  ReminderListRowView.swift
//  Reminders
//
//  Created by Imen Ksouri on 12/05/2023.
//

import SwiftUI

struct ReminderListRowView: View {
    @Environment(\.editMode) private var editMode
    let reminderList: ReminderList
    @Binding var isEditingReminderList: Bool
    @Binding var isTemplate: Bool
    @StateObject var viewModel = DisplayReminderListViewModel()

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
                    viewModel.delete(reminderList)
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
                EditReminderListView(isEditingReminderList: $isEditingReminderList,
                                     reminderList: reminderList)
            }
        }
    }
}

struct ReminderListRowView_Previews: PreviewProvider {
    static var previews: some View {
        let reminderList = CoreDataManager.reminderListForPreview()
        // swiftlint:disable:next redundant_discardable_let
        let _ = CoreDataManager.reminderForPreview(reminderList: reminderList)
        return List {
            ReminderListRowView(
                reminderList: reminderList,
                isEditingReminderList: .constant(false),
                isTemplate: .constant(false),
                viewModel: DisplayReminderListViewModel(
                    dataManager: CoreDataManager.preview))
        }
    }
}
