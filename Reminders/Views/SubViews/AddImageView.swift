//
//  AddImageView.swift
//  Notes
//
//  Created by Imen Ksouri on 14/05/2023.
//

import SwiftUI

struct AddImageView: View {
    @Binding var pictures: [(id: UUID, data: Data)]

    var body: some View {
        List {
            ForEach(0..<pictures.count, id: \.self) { index in
                let id = pictures[index].id
                let data = pictures[index].data
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
                                pictures = pictures.filter { $0.id != id }
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
        }
    }
}

struct AddImageView_Previews: PreviewProvider {
    @State static var pictures: [(id: UUID, data: Data)] = []
    static var previews: some View {
        AddImageView(pictures: $pictures)
    }
}
