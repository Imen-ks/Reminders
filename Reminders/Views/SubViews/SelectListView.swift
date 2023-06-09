//
//  SelectListView.swift
//  Reminders
//
//  Created by Imen Ksouri on 14/05/2023.
//

import SwiftUI

struct SelectListView: View {
    @Binding var reminderList: ReminderList
    @StateObject var viewModel = DisplayReminderListViewModel()

    var body: some View {
        List {
            ForEach(viewModel.reminderLists, id: \.self) { reminderList in
                Button {
                    self.reminderList = reminderList
                } label: {
                    HStack {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.white)
                            .bold()
                            .padding(12)
                            .background(Color(reminderList.color))
                            .clipShape(Circle())
                        Text("\(reminderList.title)")
                        Spacer()
                        if self.reminderList == reminderList {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .tint(.primary)
            }
        }
        .listStyle(.plain)
        .navigationBarTitle("List", displayMode: .inline)
    }
}

struct SelectListView_Previews: PreviewProvider {
    @State static var reminderList = CoreDataManager.reminderListForPreview()
    static var previews: some View {
        SelectListView(reminderList: $reminderList,
                       viewModel: DisplayReminderListViewModel(dataManager: .preview))
    }
}
