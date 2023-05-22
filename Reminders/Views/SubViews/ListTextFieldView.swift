//
//  ListTextFieldView.swift
//  Reminders
//
//  Created by Imen Ksouri on 11/05/2023.
//

import SwiftUI

struct ListTextFieldView: View {
    @Binding var listTitle: String
    @Binding var selectedColor: Color

    var body: some View {
        HStack {
            ZStack(alignment: .center) {
                TextField("List Name", text: $listTitle)
                    .multilineTextAlignment(.center)
                .foregroundColor(selectedColor)
            }
            if !listTitle.isEmpty {
                Button {
                    listTitle = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.secondary)
                        .opacity(0.7)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .font(.title2)
        .bold()
        .background(.quaternary)
        .cornerRadius(15)
        .padding()
    }
}

struct ListTextFieldView_Previews: PreviewProvider {
    @State static var listTitle = ""
    @State static var selectedColor: Color = .blue
    static var previews: some View {
        ListTextFieldView(listTitle: $listTitle, selectedColor: $selectedColor)
    }
}
