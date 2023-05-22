//
//  ListColorView.swift
//  Reminders
//
//  Created by Imen Ksouri on 11/05/2023.
//

import SwiftUI

struct ListColorView: View {
    let color: Color
    @Binding var selectedColor: Color

    var body: some View {
        VStack {
            color
                .mask(Circle())
                .padding(.horizontal, 5)
                .overlay(content: {
                    Circle()
                        .stroke(.gray, lineWidth: 3)
                        .opacity(color == selectedColor ? 1 : 0)
                })
                .onTapGesture {
                    selectedColor = color
                }
        }
    }
}

struct ListColorView_Previews: PreviewProvider {
    @State static var selectedColor: Color = .blue
    @State static var isSelected = true
    static var previews: some View {
        ListColorView(color: .blue, selectedColor: $selectedColor)
            .frame(width: 50)
    }
}
