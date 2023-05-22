//
//  EditSubtaskView.swift
//  Reminders
//
//  Created by Imen Ksouri on 19/05/2023.
//

import SwiftUI

struct EditSubtaskView: View {
    let reminder: Reminder
    @Binding var subtasks: [String]
    @Binding var removedSubtasks: [Subtask]
    @Binding var updated: [Subtask]
    @Binding var removed: [Subtask]
    @Binding var added: [String]
    var subtasksFetchRequest: FetchRequest<Subtask>
    var storedSubtasks: FetchedResults<Subtask> {
        subtasksFetchRequest.wrappedValue
    }

    init(reminder: Reminder, subtasks: Binding<[String]>,
         removedSubtasks: Binding<[Subtask]>, updated: Binding<[Subtask]>,
         removed: Binding<[Subtask]>, added: Binding<[String]>) {
        self.reminder = reminder
        self._subtasks = subtasks
        self._removedSubtasks = removedSubtasks
        self.subtasksFetchRequest = Subtask.fetchSubtasks(in: reminder)
        self._updated = updated
        self._removed = removed
        self._added = added
    }

    var body: some View {
        List {
            Section {
                if !updated.isEmpty {
                    Text("Your subtasks")
                        .font(.title3)
                        .foregroundColor(.accentColor)
                }
                ForEach(0..<updated.count, id: \.self) { index in
                    HStack {
                        Text(updated[index].title)
                        Spacer()
                        Button {
                            withAnimation {
                                removed.append(updated[index])
                                updated.remove(at: index)
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Section {
                ForEach(added.indices, id: \.self) { index in
                    if index == 0 || !added[index-1].isEmpty {
                        HStack {
                            Circle()
                                .padding(4)
                                .foregroundColor(.clear)
                                .overlay(
                                    Circle()
                                        .stroke(.tertiary, lineWidth: 2)
                                )
                                .frame(width: 20, height: 20)
                            TextField("", text: $added[index])
                                .padding(.horizontal, 5)
                        }
                    }
                }
                .onDelete { offsets in
                    withAnimation {
                        added.remove(atOffsets: offsets)
                    }
                }

                Button {
                    if added.count == 0 || !added[added.count - 1].isEmpty {
                        added.append("")
                    }
                } label: {
                    Text("Add Subtask")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .onAppear {
            updated = substract(removedSubtasks,
                                from: Array(storedSubtasks))
        }
        .onDisappear {
            removedSubtasks = removed
            subtasks = added
        }
        .navigationBarTitle("Subtasks", displayMode: .inline)
    }

    func substract(_ array: [Subtask], from secondArray: [Subtask] ) -> [Subtask] {
        var subtasks = secondArray
        for subtask1 in secondArray {
            for subtask2 in array where subtask1 == subtask2 {
                if let index = subtasks.firstIndex(of: subtask2) {
                    subtasks.remove(at: index)
                }
            }
        }
        return subtasks
    }
}

struct EditSubtaskView_Previews: PreviewProvider {
    @State static var subtasks: [String] = []
    @State static var removedSubtasks: [Subtask] = []
    @State static var updated: [Subtask] = []
    @State static var removed: [Subtask] = []
    @State static var added: [String] = []
    static var previews: some View {
        return NavigationStack {
            let reminderList = PersistenceController.reminderListForPreview()
            let reminder = PersistenceController.reminderForPreview(reminderList: reminderList)
            EditSubtaskView(reminder: reminder, subtasks: $subtasks,
                            removedSubtasks: $removedSubtasks, updated: $updated,
                            removed: $removed, added: $added)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}