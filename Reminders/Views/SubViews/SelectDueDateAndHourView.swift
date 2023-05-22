//
//  SelectDueDateAndHourView.swift
//  Reminders
//
//  Created by Imen Ksouri on 13/05/2023.
//

import SwiftUI

struct SelectDueDateAndHourView: View {
    @Binding var isAddingDueDate: Bool
    @Binding var isAddingDueHour: Bool
    @Binding var dueDate: Date?
    @Binding var dueHour: Date?
    @State private var showCalendar = false
    @State private var showClock = false

    var body: some View {
        Section {
            Section {
                HStack {
                    Toggle(isOn: $isAddingDueDate) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                                .padding(5)
                                .background {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(.red)
                                }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Date")
                                if let dueDate = dueDate {
                                    Text("\(dueDate, formatter: dateFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .padding(.leading, 8)
                        }
                    }
                }
                if isAddingDueDate && showCalendar {
                    DatePicker(selection: Binding<Date>(get: {dueDate ?? Date.now},
                                                        set: {dueDate = $0}),
                               displayedComponents: .date) {
                        Text("")
                    }
                    .datePickerStyle(.graphical)
                }

            }
            .onChange(of: isAddingDueDate) { _ in
                if showCalendar == false { showCalendar = true }
                if isAddingDueDate == false { dueDate = nil; dueHour = nil; isAddingDueHour = false }
                if isAddingDueDate {
                    if dueDate == nil { dueDate = Date.now }
                }
            }
            Section {
                HStack {
                    Toggle(isOn: $isAddingDueHour) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.white)
                                .padding(5)
                                .background {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color.accentColor)
                                }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Time")
                                if let dueHour = dueHour {
                                    Text("\(dueHour, formatter: timeFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .padding(.leading, 8)
                        }
                    }
                }
                if isAddingDueHour && showClock {
                    DatePicker(selection: Binding<Date>(get: {dueHour ?? Date.now},
                                                        set: {dueHour = $0}),
                               displayedComponents: .hourAndMinute) {
                        Text("")
                    }
                    .datePickerStyle(.wheel)
                }
            }
            .onChange(of: isAddingDueHour) { _ in
                if showClock == false { showClock = true }
                if isAddingDueHour == false { dueDate = nil; dueHour = nil; isAddingDueDate = false }
                if isAddingDueHour {
                    isAddingDueDate = true
                    if dueDate == nil { dueDate = Date.now }
                    if dueHour == nil { dueHour = Date.now }
                }
            }
        }
        .listRowInsets(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
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

struct SelectDueDateAndHourView_Previews: PreviewProvider {
    @State static var dueDate: Date? = Date.now
    @State static var dueHour: Date? = Date.now
    @State static var isAddingDueDate: Bool = true
    @State static var isAddindDueHour: Bool = true
    static var previews: some View {
        Form {
            SelectDueDateAndHourView(isAddingDueDate: $isAddingDueDate,
                                     isAddingDueHour: $isAddindDueHour,
                                     dueDate: $dueDate,
                                     dueHour: $dueHour)
        }
    }
}
