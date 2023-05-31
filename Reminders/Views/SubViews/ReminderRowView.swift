//
//  ReminderRowView.swift
//  Reminders
//
//  Created by Imen Ksouri on 11/05/2023.
//

import SwiftUI

struct ReminderRowView: View {
    @State private var isShowingDetails = false
    let reminderList: ReminderList
    let reminder: Reminder
    @StateObject var viewModel: ReminderRowViewModel

    var gridColumns = Array(repeating: GridItem(.flexible()), count: 6)

    private var priority: String {
      ReminderPriority(rawValue: reminder.priority)?.shortDisplay ?? ""
    }

    init(reminderList: ReminderList, reminder: Reminder) {
        self.reminderList = reminderList
        self.reminder = reminder
        self._viewModel = .init(wrappedValue: ReminderRowViewModel(reminder: reminder))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Button {
                    viewModel.toggleCompleted()
                } label: {
                    Circle()
                        .padding(4)
                        .overlay(
                            Circle()
                                .stroke(Color(reminderList.color), lineWidth: 2)
                        )
                        .foregroundColor(reminder.isCompleted ? Color(reminderList.color) : .clear)
                        .frame(width: 20, height: 20)
                }

                if !priority.isEmpty { Text(priority) }
                TextField("", text: Binding<String>(
                    get: {viewModel.reminderTitle ?? reminder.title},
                    set: {viewModel.reminderTitle = $0}))
                Spacer()
                if reminder.isFlagged {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.orange)
                }
            }
            .buttonStyle(.plain)
            .onChange(of: viewModel.reminderTitle ?? reminder.title) { newValue in
                viewModel.updateReminder(title: newValue)
            }

            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 3) {
                    TextField("Add Note", text: Binding<String>(
                        get: {viewModel.notes ?? reminder.notes},
                        set: {viewModel.notes = $0}), axis: .vertical)

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
                .onChange(of: viewModel.notes ?? reminder.notes) { newValue in
                    viewModel.updateReminder(notes: newValue)
                }

                LazyVGrid(columns: gridColumns) {
                    ForEach(viewModel.getPictures(), id: \.self) { picture in
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
                    viewModel.delete(reminder)
                }
            } label: {
                Text("Delete")
            }
            .tint(.red)

            Button {
                viewModel.toggleFlagged()
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
    static var previews: some View {
        let reminderList = CoreDataManager.reminderListForPreview()
        let reminder = CoreDataManager.reminderForPreview(reminderList: reminderList)
        // swiftlint:disable:next redundant_discardable_let
        let _ = CoreDataManager.pictureForPreview(reminder: reminder)
        return NavigationStack {
            List {
                ReminderRowView(reminderList: reminderList,
                                reminder: reminder)
            }
            .listStyle(.plain)
        }
    }
}
