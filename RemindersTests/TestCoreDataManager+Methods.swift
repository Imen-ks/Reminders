//
//  TestCoreDataManager+Methods.swift
//  RemindersTests
//
//  Created by Imen Ksouri on 03/06/2023.
//

import XCTest
@testable import Reminders

extension TestCoreDataManager {
    func test_CoreDataManager_addReminderList() {
        let randomCount = Int.random(in: 1...10)
        for _ in 1...randomCount {
            let title = UUID().uuidString
            let color: UIColor = .random
            dataManager.addReminderList(title: title, color: color)
            let list = dataManager.reminderLists.first(where: { $0.title == title && $0.color == color })
            XCTAssertNotNil(list)
            XCTAssertEqual(list?.title, title)
            XCTAssertNotNil(list?.dateCreated)
            XCTAssertEqual(list?.color, color)
            XCTAssertEqual(list?.order, 0)
            XCTAssertTrue(list?.isTemplate == false)
        }
        XCTAssertEqual(dataManager.reminderLists.count, randomCount)
        XCTAssertEqual(dataManager.reminderTemplates, [])
        XCTAssertEqual(dataManager.allReminders, [])
        XCTAssertEqual(dataManager.todayReminders, [])
        XCTAssertEqual(dataManager.scheduledReminders, [])
        XCTAssertEqual(dataManager.flaggedReminders, [])
        XCTAssertEqual(dataManager.completedReminders, [])
        XCTAssertEqual(dataManager.subtasks, [])
        XCTAssertEqual(dataManager.pictures, [])
    }

    func test_CoreDataManager_updateReminderList() {
        let list = getList()
        dataManager.updateReminderList(reminderList: list, title: "testUpdated", color: .blue)
        XCTAssertEqual(list.title, "testUpdated")
        XCTAssertEqual(list.color, .blue)
        XCTAssertEqual(dataManager.reminderLists.count, 1)
        XCTAssertEqual(dataManager.reminderTemplates, [])
        XCTAssertEqual(dataManager.allReminders, [])
        XCTAssertEqual(dataManager.todayReminders, [])
        XCTAssertEqual(dataManager.scheduledReminders, [])
        XCTAssertEqual(dataManager.flaggedReminders, [])
        XCTAssertEqual(dataManager.completedReminders, [])
        XCTAssertEqual(dataManager.subtasks, [])
        XCTAssertEqual(dataManager.pictures, [])
    }

    func test_CoreDataManager_findList() {
        let list = getList()
        let listIdentifier = list.identifier
        let retrievedList = dataManager.findList(withIdentifier: listIdentifier)
        XCTAssertNotNil(retrievedList)
        XCTAssertEqual(list, retrievedList)
        let retrievedList2 = dataManager.findList(withIdentifier: "Inexisting identifier")
        XCTAssertNil(retrievedList2)
    }

    func test_CoreDataManager_addReminder() {
        let randomCount = Int.random(in: 1...10)
        for _ in 1...randomCount {
            let list = getList()
            let title = UUID().uuidString
            let notes = UUID().uuidString
            let priority = Int16.random(in: 0...2)
            let isFlagged = Bool.random()
            dataManager.addReminder(title: title,
                                    notes: notes,
                                    dueDate: Date(),
                                    dueHour: Date(),
                                    priority: priority,
                                    isFlagged: isFlagged,
                                    list: list,
                                    subtasks: [UUID().uuidString, UUID().uuidString, UUID().uuidString],
                                    pictures: [(id: UUID(), data: Data()), (id: UUID(), data: Data())])
            let reminder = dataManager.allReminders.first(where: { $0.title == title && $0.notes == notes })
            XCTAssertNotNil(reminder)
            XCTAssertEqual(reminder?.title, title)
            XCTAssertEqual(reminder?.notes, notes)
            XCTAssertNotNil(reminder?.dateCreated)
            XCTAssertNotNil(reminder?.dueDate)
            XCTAssertNotNil(reminder?.dueHour)
            XCTAssertEqual(reminder?.priority, priority)
            XCTAssertEqual(reminder?.isCompleted, false)
            XCTAssertEqual(reminder?.isFlagged, isFlagged)
            XCTAssertEqual(reminder?.list, list)
            XCTAssertEqual(reminder?.subtasks?.count, 3)
            XCTAssertEqual(reminder?.pictures?.count, 2)
        }
        let flaggedRemindersCount = dataManager.allReminders.filter { $0.isFlagged }.count
        XCTAssertEqual(dataManager.reminderLists.count, randomCount)
        XCTAssertEqual(dataManager.reminderTemplates, [])
        XCTAssertEqual(dataManager.allReminders.count, randomCount)
        XCTAssertEqual(dataManager.todayReminders.count, randomCount)
        XCTAssertEqual(dataManager.scheduledReminders.count, randomCount)
        XCTAssertEqual(dataManager.flaggedReminders.count, flaggedRemindersCount)
        XCTAssertEqual(dataManager.completedReminders, [])
        XCTAssertEqual(dataManager.subtasks.count, randomCount * 3)
        XCTAssertEqual(dataManager.pictures.count, randomCount * 2)
    }

    func test_CoreDataManager_updateReminder() {
        let priority = Int16.random(in: 0...2)
        let isFlagged = Bool.random()
        let isCompleted = Bool.random()
        let list = getList()
        let reminder = getReminder(priority: priority, isFlagged: isFlagged, isCompleted: isCompleted, list: list)
        dataManager.updateReminder(reminder: reminder,
                                   title: "updated title",
                                   notes: "updated notes",
                                   dueDate: Date(), // adding due Date
                                   dueHour: Date(), // adding due Hour
                                   priority: reminder.priority == 0 ? 1 : reminder.priority - 1,
                                   isFlagged: !reminder.isFlagged, // toggling initial value
                                   list: list,
                                   subtasks: [UUID().uuidString, UUID().uuidString], // adding 2 subtasks
                                   pictures: [(id: UUID(), data: Data())]) // adding 1 picture
        XCTAssertNotNil(reminder)
        XCTAssertEqual(reminder.title, "updated title" )
        XCTAssertEqual(reminder.notes, "updated notes")
        XCTAssertNotNil(reminder.dueDate)
        XCTAssertNotNil(reminder.dueHour)
        if priority == 0 { XCTAssertEqual(reminder.priority, 1) } else {
            XCTAssertEqual(reminder.priority, priority - 1) }
        if isFlagged { XCTAssertFalse(reminder.isFlagged) } else {
            XCTAssertTrue(reminder.isFlagged)
        }
        XCTAssertEqual(reminder.list, list)
        XCTAssertEqual(reminder.subtaskCount, 2)
        XCTAssertEqual(reminder.pictures?.count, 1)
        XCTAssertEqual(dataManager.reminderLists.count, 1)
        XCTAssertEqual(dataManager.reminderTemplates, [])
        XCTAssertEqual(dataManager.allReminders.count, 1)
        XCTAssertEqual(dataManager.todayReminders.count, 1)
        XCTAssertEqual(dataManager.scheduledReminders.count, 1)
        if isFlagged { XCTAssertEqual(dataManager.flaggedReminders.count, 0) } else {
            XCTAssertEqual(dataManager.flaggedReminders.count, 1)
        }
        if isCompleted { XCTAssertEqual(dataManager.completedReminders.count, 1) } else {
            XCTAssertEqual(dataManager.completedReminders.count, 0)
        }
        XCTAssertEqual(dataManager.subtasks.count, 2)
        XCTAssertEqual(dataManager.pictures.count, 1)
    }

    func test_CoreDataManager_updateReminderTitle() {
        let reminder = getReminder()
        dataManager.updateReminder(reminder: reminder,
                                   title: "updated title")
        XCTAssertEqual(reminder.title, "updated title" )
        XCTAssertNil(reminder.dueDate)
        XCTAssertNil(reminder.dueHour)
        XCTAssertEqual(reminder.priority, 0)
        XCTAssertFalse(reminder.isCompleted)
        XCTAssertFalse(reminder.isFlagged)
        XCTAssertEqual(reminder.subtaskCount, 0)
        XCTAssertEqual(reminder.pictures?.count, 0)
        XCTAssertEqual(dataManager.reminderLists.count, 1)
        XCTAssertEqual(dataManager.reminderTemplates, [])
        XCTAssertEqual(dataManager.allReminders.count, 1)
        XCTAssertEqual(dataManager.todayReminders.count, 0)
        XCTAssertEqual(dataManager.scheduledReminders.count, 0)
        XCTAssertEqual(dataManager.flaggedReminders.count, 0)
        XCTAssertEqual(dataManager.completedReminders.count, 0)
        XCTAssertEqual(dataManager.subtasks.count, 0)
        XCTAssertEqual(dataManager.pictures.count, 0)
    }

    func test_CoreDataManager_updateReminderNotes() {
        let reminder = getReminder()
        dataManager.updateReminder(reminder: reminder,
                                   notes: "updated notes")
        XCTAssertEqual(reminder.notes, "updated notes" )
        XCTAssertNil(reminder.dueDate)
        XCTAssertNil(reminder.dueHour)
        XCTAssertEqual(reminder.priority, 0)
        XCTAssertFalse(reminder.isCompleted)
        XCTAssertFalse(reminder.isFlagged)
        XCTAssertEqual(reminder.subtaskCount, 0)
        XCTAssertEqual(reminder.pictures?.count, 0)
        XCTAssertEqual(dataManager.reminderLists.count, 1)
        XCTAssertEqual(dataManager.reminderTemplates, [])
        XCTAssertEqual(dataManager.allReminders.count, 1)
        XCTAssertEqual(dataManager.todayReminders.count, 0)
        XCTAssertEqual(dataManager.scheduledReminders.count, 0)
        XCTAssertEqual(dataManager.flaggedReminders.count, 0)
        XCTAssertEqual(dataManager.completedReminders.count, 0)
        XCTAssertEqual(dataManager.subtasks.count, 0)
        XCTAssertEqual(dataManager.pictures.count, 0)
    }

    func test_CoreDataManager_createSubtasks() {
        let reminder = getReminder()
        let randomCount = Int.random(in: 1...10)
        var subtasks: [String] = []
        for _ in 1...randomCount { subtasks.append(UUID().uuidString) }
        dataManager.create(subtasks: subtasks,
                           in: reminder)
        XCTAssertEqual(reminder.subtaskCount, randomCount)
        XCTAssertEqual(dataManager.reminderLists.count, 1)
        XCTAssertEqual(dataManager.reminderTemplates, [])
        XCTAssertEqual(dataManager.allReminders.count, 1)
        XCTAssertEqual(dataManager.todayReminders.count, 0)
        XCTAssertEqual(dataManager.scheduledReminders.count, 0)
        XCTAssertEqual(dataManager.flaggedReminders.count, 0)
        XCTAssertEqual(dataManager.completedReminders.count, 0)
        XCTAssertEqual(dataManager.subtasks.count, randomCount)
        XCTAssertEqual(dataManager.pictures.count, 0)
    }

    func test_CoreDataManager_updateSubtasks() {
        let reminder = getReminder()
        let subtask = getSubtask(in: reminder)
        dataManager.updateSubtask(subtask: subtask, title: "updated title")
        XCTAssertEqual(subtask.title, "updated title" )
        XCTAssertEqual(dataManager.reminderLists.count, 1)
        XCTAssertEqual(dataManager.reminderTemplates, [])
        XCTAssertEqual(dataManager.allReminders.count, 1)
        XCTAssertEqual(dataManager.todayReminders.count, 0)
        XCTAssertEqual(dataManager.scheduledReminders.count, 0)
        XCTAssertEqual(dataManager.flaggedReminders.count, 0)
        XCTAssertEqual(dataManager.completedReminders.count, 0)
        XCTAssertEqual(dataManager.subtasks.count, 1)
        XCTAssertEqual(dataManager.pictures.count, 0)
    }

    func test_CoreDataManager_createPictures() {
        let reminder = getReminder()
        let randomCount = Int.random(in: 1...10)
        var pictures: [(id: UUID, data: Data)] = []
        for _ in 1...randomCount { pictures.append((id: UUID(), data: Data())) }
        dataManager.create(pictures: pictures,
                           in: reminder)
        XCTAssertEqual(reminder.pictures?.count, randomCount)
        XCTAssertEqual(dataManager.reminderLists.count, 1)
        XCTAssertEqual(dataManager.reminderTemplates, [])
        XCTAssertEqual(dataManager.allReminders.count, 1)
        XCTAssertEqual(dataManager.todayReminders.count, 0)
        XCTAssertEqual(dataManager.scheduledReminders.count, 0)
        XCTAssertEqual(dataManager.flaggedReminders.count, 0)
        XCTAssertEqual(dataManager.completedReminders.count, 0)
        XCTAssertEqual(dataManager.subtasks.count, 0)
        XCTAssertEqual(dataManager.pictures.count, randomCount)
    }

    func test_CoreDataManager_saveAsTemplate() {
        let randomCountReminders = Int.random(in: 1...10)
        let randomCountSubtasks = Int.random(in: 1...10)
        let list = getList()
        var reminders: [Reminder] = []
        var subtasks: [Subtask] = []
        for _ in 1...randomCountReminders {
            let reminder = getReminder(list: list)
            for _ in 1...randomCountSubtasks {
                let subtask = getSubtask(in: reminder)
                subtasks.append(subtask)
            }
            reminders.append(reminder)
        }
        dataManager.saveAsTemplate(reminderList: list,
                                   title: UUID().uuidString,
                                   color: .random,
                                   reminders: reminders,
                                   subtasks: subtasks)
        XCTAssertEqual(dataManager.reminderLists.count, 1) // initial list being saved as template
        XCTAssertEqual(dataManager.reminderTemplates.count, 1) // new template created
        XCTAssertEqual(dataManager.reminderTemplates.first?.reminders?.count,
                       reminders.count) // reminders created into new template
        XCTAssertEqual(dataManager.allReminders.count,
                       randomCountReminders) // only those related to lists, reminders related to templates are excluded
        XCTAssertEqual(dataManager.todayReminders.count, 0)
        XCTAssertEqual(dataManager.scheduledReminders.count, 0)
        XCTAssertEqual(dataManager.flaggedReminders.count, 0)
        XCTAssertEqual(dataManager.completedReminders.count, 0)
        XCTAssertEqual(dataManager.subtasks.count,
                       randomCountReminders * randomCountSubtasks * 2) // subtasks both in initial list & new template
        XCTAssertEqual(dataManager.subtasks
            .filter { $0.reminder.list == dataManager.reminderTemplates.first }.count,
                       subtasks.count) // subtasks created into new template
        XCTAssertEqual(dataManager.pictures.count, 0)
    }

    func test_CoreDataManager_createReminderListFromTemplate() {
        let randomCountReminders = Int.random(in: 1...10)
        let randomCountSubtasks = Int.random(in: 1...10)
        let template = getList(isTemplate: true)
        var reminders: [Reminder] = []
        var subtasks: [Subtask] = []
        for _ in 1...randomCountReminders {
            let reminder = getReminder(list: template)
            for _ in 1...randomCountSubtasks {
                let subtask = getSubtask(in: reminder)
                subtasks.append(subtask)
            }
            reminders.append(reminder)
        }
        dataManager.createReminderListFromTemplate(template: template,
                                                   title: UUID().uuidString,
                                                   reminders: reminders,
                                                   subtasks: subtasks)
        XCTAssertEqual(dataManager.reminderLists.count, 1) // new list being created from template
        XCTAssertEqual(dataManager.reminderTemplates.count, 1) // initial template
        XCTAssertEqual(dataManager.reminderLists.first?.reminders?.count,
                       reminders.count) // reminders duplicated into new list
        XCTAssertEqual(dataManager.allReminders.count,
                       randomCountReminders) // only those related to lists, reminders related to templates are excluded
        XCTAssertEqual(dataManager.todayReminders.count, 0)
        XCTAssertEqual(dataManager.scheduledReminders.count, 0)
        XCTAssertEqual(dataManager.flaggedReminders.count, 0)
        XCTAssertEqual(dataManager.completedReminders.count, 0)
        XCTAssertEqual(dataManager.subtasks.count,
                       randomCountReminders * randomCountSubtasks * 2) // subtasks both in initial template & new list
        XCTAssertEqual(dataManager.subtasks
            .filter { $0.reminder.list == dataManager.reminderLists.first }.count,
                       subtasks.count) // subtasks duplicated into new list
        XCTAssertEqual(dataManager.pictures.count, 0)
    }

    func test_CoreDataManager_createReminderFromTemplate() {
        let title = UUID().uuidString
        let notes = UUID().uuidString
        let priority = Int16.random(in: 0...2)
        let isCompleted = Bool.random()
        let isFlagged = Bool.random()
        let template = getList(isTemplate: true)
        let order = Int16.random(in: 0...20)
        let reminder = dataManager.createReminderFromTemplate(title: title,
                                                              notes: notes,
                                                              dueDate: Date(),
                                                              dueHour: Date(),
                                                              priority: priority,
                                                              isCompleted: isCompleted,
                                                              isFlagged: isFlagged,
                                                              template: template,
                                                              order: order)
        XCTAssertNotNil(reminder)
        XCTAssertEqual(reminder.title, title)
        XCTAssertEqual(reminder.notes, notes)
        XCTAssertNotNil(reminder.dueDate)
        XCTAssertNotNil(reminder.dueHour)
        XCTAssertEqual(reminder.priority, priority)
        XCTAssertEqual(reminder.isCompleted, isCompleted)
        XCTAssertEqual(reminder.isFlagged, isFlagged)
        XCTAssertEqual(reminder.list, template)
        XCTAssertEqual(reminder.order, order)
    }

    func test_CoreDataManager_createSubtaskFromTemplate() {
        let randomCount = Int.random(in: 1...10)
        let list = getList()
        let reminder = getReminder(list: list)
        for _ in 1...randomCount {
            dataManager.createSubtaskFromTemplate(in: reminder, title: UUID().uuidString)
        }
        XCTAssertEqual(dataManager.reminderLists.count, 1)
        XCTAssertEqual(dataManager.reminderTemplates, [])
        XCTAssertEqual(dataManager.allReminders.count, 1)
        XCTAssertEqual(dataManager.todayReminders.count, 0)
        XCTAssertEqual(dataManager.scheduledReminders.count, 0)
        XCTAssertEqual(dataManager.flaggedReminders.count, 0)
        XCTAssertEqual(dataManager.completedReminders.count, 0)
        XCTAssertEqual(dataManager.subtasks.count, randomCount)
        XCTAssertEqual(dataManager.pictures.count, 0)
    }
}
