//
//  TestCoreDataManager.swift
//  RemindersTests
//
//  Created by Imen Ksouri on 02/06/2023.
//

import XCTest
@testable import Reminders

final class TestCoreDataManager: XCTestCase {
    var dataManager: CoreDataManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataManager = CoreDataManager(type: .testing)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataManager = nil
    }

    // Helper function for getting sample reminder list
    func getList(isTemplate: Bool = false) -> ReminderList {
        let list = ReminderList(context: dataManager.persistenceController.container.viewContext)
        list.id = UUID()
        list.title = UUID().uuidString
        list.dateCreated = Date.now
        list.color = .random
        list.order = Int16.random(in: 0...20)
        list.isTemplate = isTemplate
        return list
    }

    // Helper function for getting sample reminder
    func getReminder(dateCreated: Date = Date.now,
                     dueDate: Date? = nil,
                     priority: Int16? = nil,
                     isFlagged: Bool? = nil,
                     isCompleted: Bool? = nil,
                     list: ReminderList? = nil) -> Reminder {
        let sampleList = list != nil ? nil : getList()
        let reminder = Reminder(context: dataManager.persistenceController.container.viewContext)
        reminder.id = UUID()
        reminder.title = UUID().uuidString
        reminder.notes = UUID().uuidString
        reminder.dateCreated = dateCreated
        reminder.dueDate = dueDate
        reminder.dueHour = nil
        if let priority = priority { reminder.priority = priority } else {
            reminder.priority = 0
        }
        if let isFlagged = isFlagged { reminder.isFlagged = isFlagged } else {
            reminder.isFlagged = false
        }
        if let isCompleted = isCompleted { reminder.isCompleted = isCompleted } else {
            reminder.isCompleted = false
        }
        reminder.list = list ?? sampleList!
        reminder.order = Int16.random(in: 0...20)
        return reminder
    }

    // Helper function for getting sample subtask
    func getSubtask(in reminder: Reminder) -> Subtask {
        let subtask = Subtask(context: dataManager.persistenceController.container.viewContext)
        subtask.title = UUID().uuidString
        subtask.dateCreated = Date.now
        subtask.reminder = reminder
        return subtask
    }

    func test_CoreDataManager_init() {
        XCTAssertEqual(dataManager.reminderLists, [])
        XCTAssertEqual(dataManager.reminderTemplates, [])
        XCTAssertEqual(dataManager.allReminders, [])
        XCTAssertEqual(dataManager.todayReminders, [])
        XCTAssertEqual(dataManager.scheduledReminders, [])
        XCTAssertEqual(dataManager.flaggedReminders, [])
        XCTAssertEqual(dataManager.completedReminders, [])
        XCTAssertEqual(dataManager.subtasks, [])
        XCTAssertEqual(dataManager.pictures, [])
    }

    func test_CoreDataManager_save() {
        let randomCountLists = Int.random(in: 1...10)
        let randomCountRemindersInList = Int.random(in: 1...10)
        let randomCountTemplates = Int.random(in: 1...10)
        let randomCountRemindersInTemplate = Int.random(in: 1...10)
        let randomCountSubtasks = Int.random(in: 1...10)

        for _ in 1...randomCountLists {
            let list = getList()
            for _ in 1...randomCountRemindersInList {
                let reminder = getReminder(list: list)
                for _ in 1...randomCountSubtasks {
                    // swiftlint:disable redundant_discardable_let
                    let _ = getSubtask(in: reminder)
                }
            }
        }

        for _ in 1...randomCountTemplates {
            let template = getList(isTemplate: true)
            for _ in 1...randomCountRemindersInTemplate {
                let reminder = getReminder(list: template)
                for _ in 1...randomCountSubtasks {
                    let _ = getSubtask(in: reminder)
                    // swiftlint:enable redundant_discardable_let
                }
            }
        }

        dataManager.save()

        XCTAssertEqual(dataManager.reminderLists.count, randomCountLists)
        XCTAssertEqual(dataManager.reminderTemplates.count, randomCountTemplates)
        XCTAssertEqual(dataManager.allReminders.count, // reminders included in lists only
                       randomCountLists * randomCountRemindersInList)
        XCTAssertEqual(dataManager.todayReminders, [])
        XCTAssertEqual(dataManager.scheduledReminders, [])
        XCTAssertEqual(dataManager.flaggedReminders, [])
        XCTAssertEqual(dataManager.completedReminders, [])
        XCTAssertEqual(dataManager.subtasks.count, // subtasks in lists + templates
                       randomCountLists * randomCountRemindersInList * randomCountSubtasks
                       + randomCountTemplates * randomCountRemindersInTemplate * randomCountSubtasks)
        XCTAssertEqual(dataManager.pictures, [])
    }

    func test_CoreDataManager_delete() {
        let randomCountLists = Int.random(in: 1...10)
        let randomCountRemindersInList = Int.random(in: 1...10)
        let randomCountTemplates = Int.random(in: 1...10)
        let randomCountRemindersInTemplate = Int.random(in: 1...10)
        let randomCountSubtasks = Int.random(in: 1...10)

        for _ in 1...randomCountLists {
            let list = getList()
            for _ in 1...randomCountRemindersInList {
                let reminder = getReminder(list: list)
                for _ in 1...randomCountSubtasks {
                    // swiftlint:disable redundant_discardable_let
                    let _ = getSubtask(in: reminder)
                }
            }
        }

        for _ in 1...randomCountTemplates {
            let template = getList(isTemplate: true)
            for _ in 1...randomCountRemindersInTemplate {
                let reminder = getReminder(list: template)
                for _ in 1...randomCountSubtasks {
                    let _ = getSubtask(in: reminder)
                    // swiftlint:enable redundant_discardable_let
                }
            }
        }

        for list in dataManager.reminderLists {
            dataManager.delete(list)
        }

        for template in dataManager.reminderTemplates {
            dataManager.delete(template)
        }

        // deletion cascaded from list/template to reminders and from reminders to subtasks
        XCTAssertEqual(dataManager.reminderLists, [])
        XCTAssertEqual(dataManager.reminderTemplates, [])
        XCTAssertEqual(dataManager.allReminders, [])
        XCTAssertEqual(dataManager.todayReminders, [])
        XCTAssertEqual(dataManager.scheduledReminders, [])
        XCTAssertEqual(dataManager.flaggedReminders, [])
        XCTAssertEqual(dataManager.completedReminders, [])
        XCTAssertEqual(dataManager.subtasks, [])
        XCTAssertEqual(dataManager.pictures, [])
    }
}
