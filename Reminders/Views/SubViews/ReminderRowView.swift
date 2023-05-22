//
//  ReminderRowView.swift
//  Reminders
//
//  Created by Imen Ksouri on 11/05/2023.
//

import SwiftUI

struct ReminderRowView: View {
    @Environment(\.managedObjectContext) var viewContext
    @State private var isCompleted: Bool
    @State private var title: String
    @State private var notes: String
    @State private var isShowingDetails = false
    let reminderList: ReminderList
    let reminder: Reminder

    var gridColumns = Array(repeating: GridItem(.flexible()), count: 6)

    private var priority: String {
      ReminderPriority(rawValue: reminder.priority)?.shortDisplay ?? ""
    }

    var remindersFetchRequest: FetchRequest<Reminder>

    var picturesFetchRequest: FetchRequest<Picture>
    var pictures: FetchedResults<Picture> {
        picturesFetchRequest.wrappedValue
    }

    init(reminderList: ReminderList, reminder: Reminder, remindersFetchRequest: FetchRequest<Reminder>) {
        self._isCompleted = .init(wrappedValue: reminder.isCompleted)
        self._title = .init(wrappedValue: reminder.title)
        self._notes = .init(wrappedValue: reminder.notes)
        self.reminderList = reminderList
        self.reminder = reminder
        self.remindersFetchRequest = remindersFetchRequest
        self.picturesFetchRequest = Picture.fetchPictures(in: reminder)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Button {
                    isCompleted.toggle()
                    reminder.isCompleted = isCompleted
                    PersistenceController.save(viewContext)
                } label: {
                    Circle()
                        .padding(4)
                        .overlay(
                            Circle()
                                .stroke(Color(reminderList.color), lineWidth: 2)
                        )
                        .foregroundColor(isCompleted ? Color(reminderList.color) : .clear)
                        .frame(width: 20, height: 20)
                }

                if !priority.isEmpty { Text(priority) }
                TextField("", text: $title)
                Spacer()
                if reminder.isFlagged {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.orange)
                }
            }
            .buttonStyle(.plain)
            .onChange(of: title) { newValue in
                Reminder.update(reminder: reminder,
                                title: newValue,
                                context: viewContext)
            }

            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 3) {
                    TextField("Add Note", text: $notes, axis: .vertical)

                    HStack {
                        if let dueDate = reminder.dueDate {
                            Text("\(dueDate, formatter: dateFormatter)")
                        }

                        if let dueHour = reminder.dueHour {
                            Text("\(dueHour, formatter: timeFormatter)")
                        }
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .onChange(of: notes) { newValue in
                    Reminder.update(reminder: reminder,
                                    notes: newValue,
                                    context: viewContext)
                }

                LazyVGrid(columns: gridColumns) {
                    ForEach(pictures, id: \.self) { picture in
                        if let data = picture.data {
                            if let uiImage = UIImage(data: data) {
                                GeometryReader { _ in
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(8)
                                }
                                .aspectRatio(1, contentMode: .fit)
                            }
                        }
                    }
                }
            }
            .padding(.leading, 28)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                withAnimation {
                    viewContext.delete(reminder)
                    PersistenceController.save(viewContext)
                }
            } label: {
                Text("Delete")
            }
            .tint(.red)

            Button {
                reminder.isFlagged.toggle()
                PersistenceController.save(viewContext)
            } label: {
                if reminder.isFlagged {
                    Text("Unflag")
                } else {
                    Text("Flag")
                }
            }
            .tint(.orange)

            Button {
                isShowingDetails.toggle()
            } label: {
                Text("Details")
            }
        }
        .sheet(isPresented: $isShowingDetails) {
            NavigationStack {
                EditReminderView(reminderList: reminder.list,
                                 isShowingDetails: $isShowingDetails,
                                 reminder: reminder)
            }
        }
    }
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

struct ReminderRowView_Previews: PreviewProvider {
    static var fetchAllReminders: FetchRequest<Reminder> = Reminder.fetchReminders(predicate: .all)
    static var previews: some View {
        let reminderList = PersistenceController.reminderListForPreview()
        let reminder = PersistenceController.reminderForPreview(reminderList: reminderList)
        // swiftlint:disable:next redundant_discardable_let
        let _ = PersistenceController.pictureForPreview(reminder: reminder)
        return NavigationStack {
            List {
                ReminderRowView(reminderList: reminderList,
                                reminder: reminder,
                                remindersFetchRequest: fetchAllReminders)
                    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            }
            .listStyle(.plain)
        }
    }
}
