//
//  SelectListColorView.swift
//  Reminders
//
//  Created by Imen Ksouri on 12/05/2023.
//

import SwiftUI

struct SelectListColorView: View {
    @Binding var selectedColor: Color

    var gridColumns = Array(repeating: GridItem(.flexible()), count: 6)

    var colors = [
        Color.red, Color.orange, Color.yellow, Color.green, Color.cyan, Color.blue,
        Color.indigo, Color.pink, Color.purple, Color.brown, Color.gray, Color.mint]

    var body: some View {
        LazyVGrid(columns: gridColumns) {
            ForEach(colors, id: \.self) { color in
                GeometryReader { _ in
                    ListColorView(color: color, selectedColor: $selectedColor)
                }
                .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

struct SelectListColorView_Previews: PreviewProvider {
    @State static var selectedColor: Color = .blue
    static var previews: some View {
        Form {
            SelectListColorView(selectedColor: $selectedColor)
        }
    }
}
