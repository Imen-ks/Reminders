//
//  EditImageView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct EditImageView: View {
    let reminder: Reminder
    @Binding var removedPictures: [Picture]
    var fetchRequest: FetchRequest<Picture>
    var storedPictures: FetchedResults<Picture> {
        fetchRequest.wrappedValue
    }

    @State private var pictures: [Picture] = []

    init(reminder: Reminder, removedPictures: Binding<[Picture]>) {
        self.reminder = reminder
        self._removedPictures = removedPictures
        self.fetchRequest = Picture.fetchPictures(in: reminder)
    }

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
    static var previews: some View {
        let reminderList = PersistenceController.reminderListForPreview()
        let reminder = PersistenceController.reminderForPreview(reminderList: reminderList)
        // swiftlint:disable:next redundant_discardable_let
        let _ = PersistenceController.pictureForPreview(reminder: reminder)
        return Form {
            EditImageView(reminder: reminder, removedPictures: $removedPictures)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
