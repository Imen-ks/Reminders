//
//  CardView.swift
//  Reminders
//
//  Created by Imen Ksouri on 17/05/2023.
//

import SwiftUI

struct CardView: View {
    var card: Card
    var count: Int
    @Binding var isTapped: Bool

    var body: some View {
        Button {
            isTapped.toggle()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(card.color)
                            .frame(width: 40)
                        Image(systemName: card.icon)
                            .foregroundColor(.white)
                            .bold()
                    }
                    Spacer()
                    Text("\(count)")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .padding(.trailing, 5)
                }
                Text(card.predicate.rawValue)
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
            CardView(card: Card(
                icon: "clock.badge.fill",
                color: .blue,
                keyPath: \SummaryViewModel.todayReminders,
                predicate: .today),
                     count: 8,
                     isTapped: $isTapped)
        }
        .padding()
        .background(Color(UIColor.tertiarySystemFill))
    }
}
