//
//  SummaryView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

struct Card: Identifiable {
    var id = UUID()
    var icon: String
    var color: Color
    var keyPath: KeyPath<SummaryViewModel, [Reminder]>
    var predicate: ReminderPredicate
}

struct SummaryView: View {
    @State var isTapped = false
    @State var predicate: ReminderPredicate?
    @State var keyPath: KeyPath<SummaryViewModel, [Reminder]>?
    @StateObject var viewModel: SummaryViewModel

    var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 15) {
            ForEach(viewModel.cards) { card in
                CardView(card: card,
                         count: viewModel[keyPath: card.keyPath].count,
                         isTapped: $isTapped)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            self.predicate = card.predicate
                            self.keyPath = card.keyPath
                        }
                )
                .navigationDestination(isPresented: $isTapped, destination: {
                    if let predicate = self.predicate, let keyPath = self.keyPath {
                        DetailsView(viewModel: viewModel,
                                    keyPath: keyPath,
                                    predicate: predicate,
                                    color: card.color)
                    }
                })
            }
        }
        .padding()
        .onAppear {
            self.predicate = nil
            self.keyPath = nil
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        Section {
            SummaryView(viewModel: SummaryViewModel(dataManager: .preview))
        }
        .background(Color(UIColor.tertiarySystemFill))
    }
}
