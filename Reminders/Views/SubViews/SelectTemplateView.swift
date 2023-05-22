//
//  SelectTemplateView.swift
//  Reminders
//
//  Created by Imen Ksouri on 20/05/2023.
//

import SwiftUI

struct SelectTemplateView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var sortDescriptor = SortDescriptor.none
    @State private var isEditingReminderList = false
    @State private var isTemplate = true
    @State private var isEditingTemplate = false
    @State private var isTapped = false
    @State private var nameList = ""
    @Binding var isAddingReminderList: Bool

    var fetchRequest: FetchRequest<ReminderList> = ReminderList.fetchReminderTemplates()
    var reminderTemplates: FetchedResults<ReminderList> {
        fetchRequest.wrappedValue
    }

    var body: some View {
        List {
            ForEach(reminderTemplates, id: \.self) { reminderTemplate in
                HStack {
                    ReminderListRowView(
                        reminderList: reminderTemplate,
                        isEditingReminderList: $isEditingReminderList,
                        isTemplate: $isTemplate)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isTapped.toggle()
                    }
                    .alert("Name List", isPresented: $isTapped) {
                        TextField("List Name", text: $nameList)
                        ButtonCreateListFromTemplateView(
                            nameList: $nameList,
                            isAddingReminderList: $isAddingReminderList,
                            template: reminderTemplate)
                        Button("Cancel", role: .cancel) { }
                    }
                    Spacer()
                    .overlay {
                        Button {
                            isEditingTemplate.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.plain)
                        .sheet(isPresented: $isEditingTemplate) {
                            NavigationStack {
                                RemindersView(
                                    reminderList: reminderTemplate,
                                    sortDescriptor: $sortDescriptor,
                                    isTemplate: $isTemplate)
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button {
                                            isEditingTemplate.toggle()
                                        } label: {
                                            Text("Done")
                                        }

                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onDelete { offsets in
                withAnimation {
                    offsets.map { reminderTemplates[$0] }.forEach(viewContext.delete)
                    PersistenceController.save(viewContext)
                }
            }
        }
    }
}

struct SelectTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectTemplateView(isAddingReminderList: .constant(true))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
