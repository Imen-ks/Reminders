//
//  ReminderListView.swift
//  Reminders
//
//  Created by Imen Ksouri on 10/05/2023.
//

import SwiftUI

struct ReminderListView: View {
    @EnvironmentObject var actionService: ActionService
    @Environment(\.scenePhase) var scenePhase
    @State private var isAddingReminder = false
    @State private var isAddingReminderList = false
    @State private var isEditingReminderList = false
    @State private var isTemplate = false
    @State private var selectedList: ReminderList?
    @StateObject var viewModel = DisplayReminderListViewModel()

    var body: some View {
        Section {
            List {
                Section(header: Text("My lists").font(.title2).bold().textCase(nil).foregroundColor(.black)) {
                    ForEach(viewModel.reminderLists, id: \.self) { reminderList in
                        HStack {
                            ReminderListRowView(
                                reminderList: reminderList,
                                isEditingReminderList: $isEditingReminderList,
                                isTemplate: $isTemplate)
                            .contentShape(Rectangle())
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(UIColor.lightGray))
                        }
                        .onTapGesture {
                            selectedList = reminderList
                        }
                        .navigationDestination(isPresented: .constant(selectedList == reminderList), destination: {
                            RemindersView(
                                reminderList: reminderList,
                                sortDescriptor: $viewModel.sortDescriptor,
                                isTemplate: $isTemplate)
                        })
                    }
                    .onDelete { offsets in
                        viewModel.delete(at: offsets)
                    }
                    .onMove { source, destination in
                        withAnimation {
                            viewModel.move(from: source, to: destination)
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
                            reminderList: viewModel.reminderLists.first ?? ReminderList())
                        .disabled(viewModel.reminderLists.isEmpty)
                        Spacer()
                        ButtonAddReminderListView(isAddingReminderList: $isAddingReminderList)
                    }
                }
            }
            .onChange(of: scenePhase) { newValue in
                switch newValue {
                case .active:
                    performAction()
                default:
                    updateShortcutItems()
                }
            }
        }
        .onAppear { selectedList = nil }
    }
    func performAction() {
        guard let action = actionService.action else { return }
        switch action {
        case .newReminderList:
            isAddingReminderList.toggle()
        case .editReminderList(identifier: let identifier):
            selectedList = viewModel.findList(withIdentifier: identifier)
        }
        actionService.action = nil
    }

    func updateShortcutItems() {
        UIApplication.shared.shortcutItems = viewModel.reminderLists.compactMap(\.shortcutItem)
    }
}

struct ReminderListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReminderListView(viewModel: DisplayReminderListViewModel(
                dataManager: CoreDataManager.preview))
        }
    }
}
