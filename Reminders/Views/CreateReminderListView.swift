//
//  CreateReminderListView.swift
//  Reminders
//
//  Created by Imen Ksouri on 11/05/2023.
//

import SwiftUI

enum Selection: String, CaseIterable {
    case list = "New List"
    case template = "Templates"
}

struct CreateReminderListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var selection: Selection = .list
    @State private var listTitle = ""
    @State private var selectedColor: Color = .blue
    @Binding var isAddingReminderList: Bool

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $selection) {
                ForEach(Selection.allCases, id: \.self) { selection in
                    Text(selection.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .background(Color(UIColor.secondarySystemBackground))

            if selection == .list {
                Form {
                    Section {
                        CreateListTitleView(listTitle: $listTitle, selectedColor: $selectedColor)
                    }

                    Section {
                        SelectListColorView(selectedColor: $selectedColor)
                    }
                }
            } else if selection == .template {
                SelectTemplateView(isAddingReminderList: $isAddingReminderList)
            }
        }
        .navigationBarTitle("New List", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isAddingReminderList.toggle()
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    ReminderList.create(title: listTitle,
                                        color: UIColor(selectedColor),
                                        context: viewContext)
                    isAddingReminderList.toggle()
                } label: {
                    Text("Done")
                }
                .disabled(listTitle.isEmpty)
            }
        }
    }
}

struct CreateReminderListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateReminderListView(isAddingReminderList: .constant(true))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
