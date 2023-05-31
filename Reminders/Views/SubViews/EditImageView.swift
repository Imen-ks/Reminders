//
//  EditImageView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct EditImageView: View {
    @State private var pictures: [Picture] = []
    let reminder: Reminder
    @Binding var removedPictures: [Picture]
    @Binding var storedPictures: [Picture]

    var body: some View {
        Section {
            HStack {
                Text("Attached Images")
                Spacer()
                Text("\(pictures.count)")
                    .foregroundColor(.secondary)
            }
            ForEach(0..<pictures.count, id: \.self) { index in
                if let data = pictures[index].data {
                    if let uiImage = UIImage(data: data) {
                        HStack {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                            Text("Image")
                                .padding(.leading, 10)
                            Spacer()
                            Button {
                                withAnimation {
                                    removedPictures.append(pictures[index])
                                    pictures.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            }
        }
        .onAppear { pictures = Array(storedPictures) }
    }
}

struct EditImageView_Previews: PreviewProvider {
    @State static var removedPictures: [Picture] = []
    @State static var storedPictures: [Picture] = []
    static var previews: some View {
        let reminderList = CoreDataManager.reminderListForPreview()
        let reminder = CoreDataManager.reminderForPreview(reminderList: reminderList)
        // swiftlint:disable:next redundant_discardable_let
        let _ = CoreDataManager.pictureForPreview(reminder: reminder)
        return Form {
            EditImageView(reminder: reminder,
                          removedPictures: $removedPictures,
                          storedPictures: $storedPictures)
        }
    }
}
