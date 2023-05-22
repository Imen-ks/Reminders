//
//  CardView.swift
//  Reminders
//
//  Created by Imen Ksouri on 17/05/2023.
//

import SwiftUI

struct CardView: View {
    var name: String
    var icon: String
    var count: Int
    var color: Color
    @Binding var isTapped: Bool

    var body: some View {
        Button {
            isTapped.toggle()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(color)
                            .frame(width: 40)
                        Image(systemName: icon)
                            .foregroundColor(.white)
                            .bold()
                    }
                    Spacer()
                    Text("\(count)")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .padding(.trailing, 5)
                }
                Text(name)
                    .fontDesign(.rounded)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            .padding(8)
            .padding(.horizontal, 6)
            .background(.white)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}

struct CardView_Previews: PreviewProvider {
    @State static var isTapped = false
    static var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
    static var previews: some View {
        LazyVGrid(columns: gridColumns, spacing: 15) {
            CardView(name: "Today",
                     icon: "clock.badge.fill",
                     count: 8,
                     color: .blue,
                     isTapped: $isTapped)
        }
        .padding()
        .background(Color(UIColor.tertiarySystemFill))
    }
}
