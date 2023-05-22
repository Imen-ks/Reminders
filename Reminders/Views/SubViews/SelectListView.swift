//
//  SelectListView.swift
//  Reminders
//
//  Created by Imen Ksouri on 14/05/2023.
//

import SwiftUI

struct SelectListView: View {
    @Binding var reminderList: ReminderList
    var fetchRequest: FetchRequest<ReminderList> = ReminderList.fetchReminderLists()
    var reminderLists: FetchedResults<ReminderList> {
        fetchRequest.wrappedValue
    }

    var body: some View {
        List {
            ForEach(reminderLists, id: \.self) { reminderList in
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
    @State static var reminderList = PersistenceController.reminderListForPreview()
    static var previews: some View {
        SelectListView(reminderList: $reminderList)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
