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

    var fetchTodayReminders: FetchRequest<Reminder> = Reminder.fetchReminders(predicate: .today)
    var todayRemindersCount: Int {
        return fetchTodayReminders.wrappedValue.count
    }
    var fetchScheduledReminders: FetchRequest<Reminder> = Reminder.fetchReminders(predicate: .scheduled)
    var scheduledRemindersCount: Int {
        return fetchScheduledReminders.wrappedValue.count
    }
    var fetchAllReminders: FetchRequest<Reminder> = Reminder.fetchReminders(predicate: .all)
    var allRemindersCount: Int {
        return fetchAllReminders.wrappedValue.count
    }
    var fetchFlaggedReminders: FetchRequest<Reminder> = Reminder.fetchReminders(predicate: .flagged)
    var flaggedRemindersCount: Int {
        return fetchFlaggedReminders.wrappedValue.count
    }
    var fetchCompletedReminders: FetchRequest<Reminder> = Reminder.fetchReminders(predicate: .completed)
    var completedRemindersCount: Int {
        return fetchCompletedReminders.wrappedValue.count
    }

    var subtasksFetchRequest: FetchRequest<Subtask> = Subtask.fetchSubtasks()

    var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 15) {
            CardView(name: "Today",
                     icon: "clock.badge.fill",
                     count: todayRemindersCount,
                     color: .blue,
                     isTapped: $todayIsTapped)
            .navigationDestination(isPresented: $todayIsTapped, destination: {
                TodayRemindersView(
                    fetchTodayReminders: fetchTodayReminders,
                    subtasksFetchRequest: subtasksFetchRequest)
            })
            CardView(name: "Scheduled",
                     icon: "calendar",
                     count: scheduledRemindersCount,
                     color: .red,
                     isTapped: $scheduledIsTapped)
            .navigationDestination(isPresented: $scheduledIsTapped, destination: {
                ScheduledRemindersView(
                    fetchScheduledReminders: fetchScheduledReminders,
                    subtasksFetchRequest: subtasksFetchRequest)
            })
            CardView(name: "All",
                     icon: "tray.fill",
                     count: allRemindersCount,
                     color: .black,
                     isTapped: $allIsTapped)
            .navigationDestination(isPresented: $allIsTapped, destination: {
                AllRemindersView(
                    fetchAllReminders: fetchAllReminders,
                    subtasksFetchRequest: subtasksFetchRequest)
            })
            CardView(name: "Flagged",
                     icon: "flag.fill",
                     count: flaggedRemindersCount,
                     color: .orange,
                     isTapped: $flaggedIsTapped)
            .navigationDestination(isPresented: $flaggedIsTapped, destination: {
                FlaggedRemindersView(
                    fetchFlaggedReminders: fetchFlaggedReminders,
                    subtasksFetchRequest: subtasksFetchRequest)
            })
            CardView(name: "Completed",
                     icon: "checkmark",
                     count: completedRemindersCount,
                     color: .gray,
                     isTapped: $completedIsTapped)
            .navigationDestination(isPresented: $completedIsTapped, destination: {
                CompletedRemindersView(
                    fetchCompletedReminders: fetchCompletedReminders,
                    subtasksFetchRequest: subtasksFetchRequest)
            })
        }
        .padding()
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        Section {
            SummaryView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
        .background(Color(UIColor.tertiarySystemFill))
    }
}
