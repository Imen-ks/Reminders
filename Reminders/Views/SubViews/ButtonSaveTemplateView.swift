//
//  ButtonSaveTemplateView.swift
//  Reminders
//
//  Created by Imen Ksouri on 11/05/2023.
//

import SwiftUI

struct ButtonSaveTemplateView: View {
    @Binding var isSavingTemplate: Bool
    let reminderList: ReminderList

    var body: some View {
        Button {
            isSavingTemplate.toggle()
        } label: {
            Text("Save as Template")
        }
        .foregroundColor(Color(reminderList.color))
        .sheet(isPresented: $isSavingTemplate) {
            NavigationStack {
                SaveTemplateView(isSavingTemplate: $isSavingTemplate, reminderList: reminderList)
            }
        }
    }
}

struct ButtonSaveTemplateView_Previews: PreviewProvider {
    static var reminderList = CoreDataManager.reminderListForPreview()
    static var previews: some View {
        ButtonSaveTemplateView(isSavingTemplate: .constant(false), reminderList: reminderList)
    }
}
