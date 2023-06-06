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
    @Binding var storedSubtasks: [Subtask]

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
        .listStyle(.grouped)
        .background(Color(UIColor.secondarySystemBackground))
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
    static var reminderList = CoreDataManager.reminderListForPreview()
    static var reminder = CoreDataManager.reminderForPreview(reminderList: reminderList)
    static var subtask = CoreDataManager.subtaskForPreview(reminder: reminder)
    @State static var subtasks: [String] = ["f"]
    @State static var removedSubtasks: [Subtask] = []
    @State static var updated: [Subtask] = [subtask]
    @State static var removed: [Subtask] = []
    @State static var added: [String] = ["New Subtask"]
    @State static var storedSubtasks: [Subtask] = []
    static var previews: some View {
        NavigationStack {
            EditSubtaskView(reminder: reminder,
                            subtasks: $subtasks,
                            removedSubtasks: $removedSubtasks,
                            updated: $updated,
                            removed: $removed,
                            added: $added,
                            storedSubtasks: $storedSubtasks)
        }
    }
}
