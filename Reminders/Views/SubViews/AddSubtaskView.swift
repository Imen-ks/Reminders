//
//  AddSubtaskView.swift
//  Reminders
//
//  Created by Imen Ksouri on 19/05/2023.
//

import SwiftUI

struct AddSubtaskView: View {
    @Binding var subtasks: [String]
    @Binding var newSubtasks: [String]

    var body: some View {
        List {
            Section {
                ForEach(newSubtasks.indices, id: \.self) { index in
                    if index == 0 || !newSubtasks[index-1].isEmpty {
                        HStack {
                            Circle()
                                .padding(4)
                                .foregroundColor(.clear)
                                .overlay(
                                    Circle()
                                        .stroke(.tertiary, lineWidth: 2)
                                )
                                .frame(width: 20, height: 20)
                            TextField("", text: $newSubtasks[index])
                                .padding(.horizontal, 5)
                        }
                    }
                }
                .onDelete { offsets in
                    withAnimation {
                        newSubtasks.remove(atOffsets: offsets)
                    }
                }
            }

            Section {
                Button {
                    if newSubtasks.count == 0 || !newSubtasks[newSubtasks.count - 1].isEmpty {
                        newSubtasks.append("")
                    }
                } label: {
                    Text("Add Subtask")
                        .foregroundColor(.accentColor)
                }
                .padding(.horizontal, 30)
            }
        }
        .listStyle(.plain)
        .onDisappear { subtasks = newSubtasks }
    }
}

struct AddSubtaskView_Previews: PreviewProvider {
    @State static var subtasks: [String] = []
    @State static var newSubtasks: [String] = []
    static var previews: some View {
        AddSubtaskView(subtasks: $subtasks, newSubtasks: $newSubtasks)
    }
}
