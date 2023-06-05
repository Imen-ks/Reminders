//
//  TestCoreDataManager+FetchRequests.swift
//  RemindersTests
//
//  Created by Imen Ksouri on 04/06/2023.
//

import XCTest
@testable import Reminders

extension TestCoreDataManager {
    func test_CoreDataManager_fetchReminderLists() {
        let randomCountLists = Int.random(in: 1...10)
        let randomCountTemplates = Int.random(in: 1...10)
        for _ in 1...randomCountLists {
            // swiftlint:disable redundant_discardable_let
            let _ = getList()
        }
        for _ in 1...randomCountTemplates {
            let _ = getList(isTemplate: true)
        }
        dataManager.fetchReminderLists()
        XCTAssertEqual(dataManager.reminderLists.count, randomCountLists)
        XCTAssertEqual(dataManager.reminderTemplates, [])
    }

    func test_CoreDataManager_fetchReminderTemplates() {
        let randomCountLists = Int.random(in: 1...10)
        let randomCountTemplates = Int.random(in: 1...10)
        for _ in 1...randomCountLists {
            let _ = getList()
        }
        for _ in 1...randomCountTemplates {
            let _ = getList(isTemplate: true)
            // swiftlint:enable redundant_discardable_let
        }
        dataManager.fetchReminderTemplates()
        XCTAssertEqual(dataManager.reminderLists, [])
        XCTAssertEqual(dataManager.reminderTemplates.count, randomCountTemplates)
    }

    func test_CoreDataManager_getRemindersWithNoneSortDescriptor() {
        let list = getList()
        let randomCount = Int.random(in: 1...10)
        var reminders: [Reminder] = []
        for _ in 1...randomCount {
            let reminder = getReminder(
                dateCreated: Date.random(in: Date.now.addingTimeInterval(-86400 * 45)..<Date.now),
                list: list)
            reminders.append(reminder)
        }
        let sortedReminders = reminders.sorted {
            $0.order == $1.order ? $0.dateCreated < $1.dateCreated : $0.order < $1.order }
        let fetchedReminders = dataManager.getReminders(in: list, sortDescriptor: .none)
        XCTAssertEqual(fetchedReminders, sortedReminders)
    }

    func test_CoreDataManager_getRemindersWithTitleSortDescriptor() {
        let list = getList()
        let randomCount = Int.random(in: 1...10)
        var reminders: [Reminder] = []
        for _ in 1...randomCount {
            let reminder = getReminder(list: list)
            reminders.append(reminder)
        }
        let sortedReminders = reminders.sorted { $0.title < $1.title }
        let fetchedReminders = dataManager.getReminders(in: list, sortDescriptor: .title)
        XCTAssertEqual(fetchedReminders, sortedReminders)
    }

    func test_CoreDataManager_getRemindersWithDueDateSortDescriptor() {
        let list = getList()
        let randomCount = Int.random(in: 1...10)
        var reminders: [Reminder] = []
        for _ in 1...randomCount {
            let reminder = getReminder(
                dueDate: Date.random(in: Date.now..<Date.now.addingTimeInterval(86400 * 45)),
                list: list)
            reminders.append(reminder)
        }
        let sortedReminders = reminders.sorted { $0.dueDate ?? Date() < $1.dueDate ?? Date() }
        let fetchedReminders = dataManager.getReminders(in: list, sortDescriptor: .dueDate)
        XCTAssertEqual(fetchedReminders, sortedReminders)
    }

    func test_CoreDataManager_getRemindersWithDateCreatedSortDescriptor() {
        let list = getList()
        let randomCount = Int.random(in: 1...10)
        var reminders: [Reminder] = []
        for _ in 1...randomCount {
            let reminder = getReminder(
                dateCreated: Date.random(in: Date.now.addingTimeInterval(-86400 * 45)..<Date.now),
                list: list)
            reminders.append(reminder)
        }
        let sortedReminders = reminders.sorted { $0.dateCreated > $1.dateCreated }
        let fetchedReminders = dataManager.getReminders(in: list, sortDescriptor: .dateCreated)
        XCTAssertEqual(fetchedReminders, sortedReminders)
    }

    func test_CoreDataManager_getRemindersWithPrioritySortDescriptor() {
        let list = getList()
        let randomCount = Int.random(in: 1...10)
        var reminders: [Reminder] = []
        for _ in 1...randomCount {
            let reminder = getReminder(
                dateCreated: Date.random(in: Date.now.addingTimeInterval(-86400 * 45)..<Date.now),
                list: list)
            reminders.append(reminder)
        }
        let sortedReminders = reminders.sorted {
            $0.priority == $1.priority ? $0.dateCreated < $1.dateCreated : $0.priority > $1.priority }
        let fetchedReminders = dataManager.getReminders(in: list, sortDescriptor: .priority)
        XCTAssertEqual(fetchedReminders, sortedReminders)
    }

    func test_CoreDataManager_fetchAllReminders() {
        let list = getList()
        let randomCount = Int.random(in: 1...10)
        var reminders: [Reminder] = []

        for _ in 1...randomCount {
            let reminder = getReminder(list: list)
            reminders.append(reminder)
        }

        let sortedReminders = reminders.sorted {
            $0.dueDate ?? $0.dateCreated < $1.dueDate ?? $1.dateCreated }

        dataManager.fetchReminders(predicate: .all)
        XCTAssertEqual(dataManager.allReminders, sortedReminders)
    }

    func test_CoreDataManager_fetchCompletedReminders() {
        let list = getList()
        let randomCountCompleted = Int.random(in: 1...10)
        let randomCountNotCompleted = Int.random(in: 1...10)
        var reminders: [Reminder] = []

        for _ in 1...randomCountCompleted {
            let reminder = getReminder(
                isCompleted: true,
                list: list)
            reminders.append(reminder)
        }

        for _ in 1...randomCountNotCompleted {
            let reminder = getReminder(
                isCompleted: false,
                list: list)
            reminders.append(reminder)
        }

        let sortedReminders = reminders.filter { $0.isCompleted == true }.sorted {
            $0.dueDate ?? $0.dateCreated > $1.dueDate ?? $1.dateCreated }

        dataManager.fetchReminders(predicate: .all)
        dataManager.fetchReminders(predicate: .completed)
        XCTAssertEqual(dataManager.allReminders.count, reminders.count)
        XCTAssertEqual(dataManager.completedReminders, sortedReminders)
    }

    func test_CoreDataManager_fetchFlaggedReminders() {
        let list = getList()
        let randomCountFlagged = Int.random(in: 1...10)
        let randomCountNotFlagged = Int.random(in: 1...10)
        var reminders: [Reminder] = []

        for _ in 1...randomCountFlagged {
            let reminder = getReminder(
                isFlagged: true,
                list: list)
            reminders.append(reminder)
        }

        for _ in 1...randomCountNotFlagged {
            let reminder = getReminder(
                isFlagged: false,
                list: list)
            reminders.append(reminder)
        }

        let sortedReminders = reminders.filter { $0.isFlagged == true }.sorted {
            $0.dueDate ?? $0.dateCreated < $1.dueDate ?? $1.dateCreated }

        dataManager.fetchReminders(predicate: .all)
        dataManager.fetchReminders(predicate: .flagged)
        XCTAssertEqual(dataManager.allReminders.count, reminders.count)
        XCTAssertEqual(dataManager.flaggedReminders, sortedReminders)
    }

    func test_CoreDataManager_fetchTodayReminders() {
        let list = getList()
        let randomCountToday = Int.random(in: 1...10)
        let randomCountNotToday = Int.random(in: 1...10)
        let randomCountNotScheduled = Int.random(in: 1...10)
        var reminders: [Reminder] = []

        let today = Date()
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = calendar.component(.day, from: today)
        components.month = calendar.component(.month, from: today)
        components.year = calendar.component(.year, from: today)
        components.hour = 23
        components.minute = 59
        let todayDate = calendar.date(from: components)

        for _ in 1...randomCountToday {
            let reminder = getReminder(
                dueDate: todayDate,
                list: list)
            reminders.append(reminder)
        }

        for _ in 1...randomCountNotToday {
            let reminder = getReminder(
                dueDate: Date.random(
                    in: Date.now.addingTimeInterval(86400 * 5)..<Date.now.addingTimeInterval(86400 * 45)),
                list: list)
            reminders.append(reminder)
        }

        for _ in 1...randomCountNotScheduled {
            let reminder = getReminder(
                dueDate: nil,
                list: list)
            reminders.append(reminder)
        }

        let sortedReminders = reminders.filter { $0.dueDate == todayDate }.sorted {
            $0.dueDate ?? $0.dateCreated < $1.dueDate ?? $1.dateCreated }

        dataManager.fetchReminders(predicate: .all)
        dataManager.fetchReminders(predicate: .today)
        XCTAssertEqual(dataManager.allReminders.count, reminders.count)
        XCTAssertEqual(dataManager.todayReminders.count, sortedReminders.count)
    }

    func test_CoreDataManager_fetchScheduledReminders() {
        let list = getList()
        let randomCountScheduled = Int.random(in: 1...10)
        let randomCountNotScheduled = Int.random(in: 1...10)
        var reminders: [Reminder] = []

        for _ in 1...randomCountScheduled {
            let reminder = getReminder(
                dueDate: Date.random(
                    in: Date.now.addingTimeInterval(86400 * 5)..<Date.now.addingTimeInterval(86400 * 45)),
                list: list)
            reminders.append(reminder)
        }

        for _ in 1...randomCountNotScheduled {
            let reminder = getReminder(
                dueDate: nil,
                list: list)
            reminders.append(reminder)
        }

        let sortedReminders = reminders.filter { $0.dueDate != nil }.sorted {
            $0.dueDate ?? $0.dateCreated < $1.dueDate ?? $1.dateCreated }

        dataManager.fetchReminders(predicate: .all)
        dataManager.fetchReminders(predicate: .scheduled)
        XCTAssertEqual(dataManager.allReminders.count, reminders.count)
        XCTAssertEqual(dataManager.scheduledReminders.count, sortedReminders.count)
    }
}
