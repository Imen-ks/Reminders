//
//  SummaryView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI

enum ReminderPredicate {
    case all
    case today
    case scheduled
    case flagged
    case completed
}

struct SummaryView: View {
    @State var todayIsTapped = false
    @State var scheduledIsTapped = false
    @State var allIsTapped = false
    @State var flaggedIsTapped = false
    @State var completedIsTapped = false

    @StateObject var viewModel: SummaryViewModel

    var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 15) {
            CardView(name: "Today",
                     icon: "clock.badge.fill",
                     count: viewModel.todayReminders.count,
                     color: .blue,
                     isTapped: $todayIsTapped)
            .navigationDestination(isPresented: $todayIsTapped, destination: {
                TodayRemindersView(viewModel: viewModel)
            })
            CardView(name: "Scheduled",
                     icon: "calendar",
                     count: viewModel.scheduledReminders.count,
                     color: .red,
                     isTapped: $scheduledIsTapped)
            .navigationDestination(isPresented: $scheduledIsTapped, destination: {
                ScheduledRemindersView(viewModel: viewModel)
            })
            CardView(name: "All",
                     icon: "tray.fill",
                     count: viewModel.allReminders.count,
                     color: .black,
                     isTapped: $allIsTapped)
            .navigationDestination(isPresented: $allIsTapped, destination: {
                AllRemindersView(viewModel: viewModel)
            })
            CardView(name: "Flagged",
                     icon: "flag.fill",
                     count: viewModel.flaggedReminders.count,
                     color: .orange,
                     isTapped: $flaggedIsTapped)
            .navigationDestination(isPresented: $flaggedIsTapped, destination: {
                FlaggedRemindersView(viewModel: viewModel)
            })
            CardView(name: "Completed",
                     icon: "checkmark",
                     count: viewModel.completedReminders.count,
                     color: .gray,
                     isTapped: $completedIsTapped)
            .navigationDestination(isPresented: $completedIsTapped, destination: {
                CompletedRemindersView(viewModel: viewModel)
            })
        }
        .padding()
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
