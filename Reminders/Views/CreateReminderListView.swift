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
    @State private var selection: Selection = .list
    @Binding var isAddingReminderList: Bool
    @StateObject var viewModel = CreateReminderListViewModel()

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
                        CreateListTitleView(listTitle: $viewModel.listTitle, selectedColor: $viewModel.selectedColor)
                    }

                    Section {
                        SelectListColorView(selectedColor: $viewModel.selectedColor)
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
                    viewModel.addReminderList()
                    isAddingReminderList.toggle()
                } label: {
                    Text("Done")
                }
                .disabled(viewModel.listTitle.isEmpty)
            }
        }
    }
}

struct CreateReminderListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateReminderListView(
                isAddingReminderList: .constant(true),
                viewModel: CreateReminderListViewModel(
                    dataManager: CoreDataManager.preview))
        }
    }
}
