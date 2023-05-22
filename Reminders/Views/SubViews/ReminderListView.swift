//
//  ReminderListView.swift
//  Reminders
//
//  Created by Imen Ksouri on 10/05/2023.
//

import SwiftUI

struct ReminderListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Binding var sortDescriptor: SortDescriptor
    @State private var isAddingReminder = false
    @State private var isAddingReminderList = false
    @State private var isEditingReminderList = false
    @State private var isTemplate = false

    var fetchRequest: FetchRequest<ReminderList> = ReminderList.fetchReminderLists()
    var reminderLists: FetchedResults<ReminderList> {
        fetchRequest.wrappedValue
    }

    var body: some View {
        Section {
            List {
                Section(header: Text("My lists").font(.title2).bold().textCase(nil).foregroundColor(.black)) {
                    ForEach(reminderLists, id: \.self) { reminderList in
                        NavigationLink {
                            RemindersView(
                                reminderList: reminderList,
                                sortDescriptor: $sortDescriptor,
                                isTemplate: $isTemplate)
                        } label: {
                            ReminderListRowView(
                                reminderList: reminderList,
                                isEditingReminderList: $isEditingReminderList,
                                isTemplate: $isTemplate)
                        }
                    }
                    .onDelete { offsets in
                        withAnimation {
                            offsets.map { reminderLists[$0] }.forEach(viewContext.delete)
                            PersistenceController.save(viewContext)
                        }
                    }
                    .onMove { source, destination in
                        withAnimation {
                            var reminderLists: [ReminderList] = self.reminderLists.map { $0 }
                            reminderLists.move(fromOffsets: source, toOffset: destination )
                            for reverseIndex in stride(from: reminderLists.count - 1,
                                                       through: 0,
                                                       by: -1) {
                                reminderLists[reverseIndex].order = Int16(reverseIndex)
                            }
                            PersistenceController.save(viewContext)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 15))
                }
            }
            .navigationBarTitle("Lists", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        ButtonAddReminderView(
                            isAddingReminder: $isAddingReminder,
                            color: .accentColor,
                            reminderList: reminderLists.first ?? ReminderList())
                        .disabled(reminderLists.isEmpty)
                        Spacer()
                        ButtonAddReminderListView(isAddingReminderList: $isAddingReminderList)
                    }
                }
            }
        }
    }
}

struct ReminderListView_Previews: PreviewProvider {
    @State static var sortDescriptor = SortDescriptor.dateCreated
    static var previews: some View {
        NavigationStack {
            ReminderListView(sortDescriptor: $sortDescriptor)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
