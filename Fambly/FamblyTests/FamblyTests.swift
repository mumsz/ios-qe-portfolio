import Testing
import Foundation
import SwiftData
@testable import Fambly

// MARK: - Member Tests

@Suite("Member Validation")
struct MemberTests {

    @Test("Valid member is created successfully")
    func validMemberCreation() {
        let member = Member(name: "Quel", age: 30, colorHex: "#FF5733", emoji: "👩🏽")
        #expect(member.name == "Quel")
        #expect(member.age == 30)
        #expect(!member.colorHex.isEmpty)
    }

    @Test("Member name is not empty")
    func memberNameNotEmpty() {
        let member = Member(name: "Quel", age: 30, colorHex: "#FF5733", emoji: "👩🏽")
        #expect(!member.name.isEmpty)
    }

    @Test("Member age is within valid range")
    func memberAgeValidRange() {
        let member = Member(name: "Quel", age: 30, colorHex: "#FF5733", emoji: "👩🏽")
        #expect(member.age >= 1)
        #expect(member.age <= 100)
    }
}

// MARK: - Priority Tests

@Suite("Priority Logic")
struct PriorityTests {

    @Test("High priority has lowest sort order")
    func highPriorityFirst() {
        #expect(Priority.high.sortOrder < Priority.medium.sortOrder)
        #expect(Priority.medium.sortOrder < Priority.low.sortOrder)
    }

    @Test("Priority label is capitalized")
    func priorityLabelCapitalized() {
        #expect(Priority.high.label == "High")
        #expect(Priority.medium.label == "Medium")
        #expect(Priority.low.label == "Low")
    }

    @Test("Priority initializes from raw value")
    func priorityFromRawValue() {
        #expect(Priority(rawValue: "high") == .high)
        #expect(Priority(rawValue: "medium") == .medium)
        #expect(Priority(rawValue: "low") == .low)
    }

    @Test("Invalid raw value returns nil")
    func invalidPriorityRawValue() {
        #expect(Priority(rawValue: "critical") == nil)
    }

    @Test("All cases are present")
    func allPriorityCasesExist() {
        #expect(Priority.allCases.count == 3)
    }
}

// MARK: - ChoreTask Tests

@Suite("ChoreTask Validation")
struct ChoreTaskTests {

    @Test("New task is incomplete by default")
    func newTaskIsIncomplete() {
        let task = ChoreTask(
            title: "Wash dishes",
            assignedMemberName: "Quel",
            dueDate: Date()
        )
        #expect(task.isComplete == false)
    }

    @Test("Task default priority is medium")
    func taskDefaultPriorityIsMedium() {
        let task = ChoreTask(
            title: "Sweep floors",
            assignedMemberName: "Quel",
            dueDate: Date()
        )
        #expect(task.priority == Priority.medium.rawValue)
    }

    @Test("Task title is not empty")
    func taskTitleNotEmpty() {
        let task = ChoreTask(
            title: "Take out trash",
            assignedMemberName: "Quel",
            dueDate: Date()
        )
        #expect(!task.title.isEmpty)
    }

    @Test("Task can be marked complete")
    func taskCanBeMarkedComplete() {
        let task = ChoreTask(
            title: "Vacuum",
            assignedMemberName: "Quel",
            dueDate: Date()
        )
        task.isComplete = true
        #expect(task.isComplete == true)
    }

    @Test("High priority task sorts before low priority")
    func highPriorityTaskSortsFirst() {
        let highTask = ChoreTask(
            title: "Urgent chore",
            assignedMemberName: "Quel",
            dueDate: Date(),
            priority: Priority.high.rawValue
        )
        let lowTask = ChoreTask(
            title: "Low chore",
            assignedMemberName: "Quel",
            dueDate: Date(),
            priority: Priority.low.rawValue
        )
        let highOrder = Priority(rawValue: highTask.priority)?.sortOrder ?? 99
        let lowOrder = Priority(rawValue: lowTask.priority)?.sortOrder ?? 99
        #expect(highOrder < lowOrder)
    }
}
