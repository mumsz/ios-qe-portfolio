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
// MARK: - Test Helpers

@MainActor
func makeTestContainer() throws -> ModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    return try ModelContainer(
        for: Member.self, ChoreTask.self,
        configurations: config
    )
}

// MARK: - MemberViewModel Tests

@Suite("MemberViewModel Validation")
struct MemberViewModelTests {

    @Test("Adding valid member inserts into context")
    @MainActor
    func addValidMember() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = MemberViewModel()

        viewModel.addMember(
            name: "Quel",
            age: 30,
            colorHex: "#5856D6",
            emoji: "👩🏽",
            context: context
        )

        let members = try context.fetch(FetchDescriptor<Member>())
        #expect(members.count == 1)
        #expect(members.first?.name == "Quel")
    }

    @Test("Empty name sets error message")
    @MainActor
    func emptyNameSetsError() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = MemberViewModel()

        viewModel.addMember(
            name: "   ",
            age: 30,
            colorHex: "#5856D6",
            emoji: "👩🏽",
            context: context
        )

        #expect(viewModel.errorMessage == "Name cannot be empty")
        let members = try context.fetch(FetchDescriptor<Member>())
        #expect(members.isEmpty)
    }

    @Test("Age below 1 sets error message")
    @MainActor
    func ageBelowMinimumSetsError() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = MemberViewModel()

        viewModel.addMember(
            name: "Quel",
            age: 0,
            colorHex: "#5856D6",
            emoji: "👩🏽",
            context: context
        )

        #expect(viewModel.errorMessage == "Age must be between 1 and 100")
        let members = try context.fetch(FetchDescriptor<Member>())
        #expect(members.isEmpty)
    }

    @Test("Age above 100 sets error message")
    @MainActor
    func ageAboveMaximumSetsError() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = MemberViewModel()

        viewModel.addMember(
            name: "Quel",
            age: 101,
            colorHex: "#5856D6",
            emoji: "👩🏽",
            context: context
        )

        #expect(viewModel.errorMessage == "Age must be between 1 and 100")
    }

    @Test("Deleting member removes from context")
    @MainActor
    func deleteMemberRemovesFromContext() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = MemberViewModel()

        viewModel.addMember(
            name: "Quel",
            age: 30,
            colorHex: "#5856D6",
            emoji: "👩🏽",
            context: context
        )

        let members = try context.fetch(FetchDescriptor<Member>())
        #expect(members.count == 1)

        viewModel.deleteMember(members[0], context: context)
        let remaining = try context.fetch(FetchDescriptor<Member>())
        #expect(remaining.isEmpty)
    }

    @Test("Valid member clears error message")
    @MainActor
    func validMemberClearsError() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = MemberViewModel()

        viewModel.addMember(name: "", age: 30, colorHex: "#5856D6", emoji: "👩🏽", context: context)
        #expect(viewModel.errorMessage != nil)

        viewModel.addMember(name: "Quel", age: 30, colorHex: "#5856D6", emoji: "👩🏽", context: context)
        #expect(viewModel.errorMessage == nil)
    }
}

// MARK: - TaskViewModel Tests

@Suite("TaskViewModel Validation")
struct TaskViewModelTests {

    @Test("Adding valid task inserts into context")
    @MainActor
    func addValidTask() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = TaskViewModel()

        viewModel.addTask(
            title: "Wash dishes",
            assignedMemberName: "Quel",
            dueDate: Date(),
            priority: .high,
            context: context
        )

        let tasks = try context.fetch(FetchDescriptor<ChoreTask>())
        #expect(tasks.count == 1)
        #expect(tasks.first?.title == "Wash dishes")
        #expect(tasks.first?.priority == Priority.high.rawValue)
    }

    @Test("Empty title sets error message")
    @MainActor
    func emptyTitleSetsError() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = TaskViewModel()

        viewModel.addTask(
            title: "   ",
            assignedMemberName: "Quel",
            dueDate: Date(),
            priority: .medium,
            context: context
        )

        #expect(viewModel.errorMessage == "Task title cannot be empty")
        let tasks = try context.fetch(FetchDescriptor<ChoreTask>())
        #expect(tasks.isEmpty)
    }

    @Test("Empty member name sets error message")
    @MainActor
    func emptyMemberNameSetsError() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = TaskViewModel()

        viewModel.addTask(
            title: "Vacuum",
            assignedMemberName: "",
            dueDate: Date(),
            priority: .medium,
            context: context
        )

        #expect(viewModel.errorMessage == "Task must be assigned to a member")
    }

    @Test("Toggle complete flips isComplete")
    @MainActor
    func toggleCompleteFlipsState() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = TaskViewModel()

        viewModel.addTask(
            title: "Sweep floors",
            assignedMemberName: "Quel",
            dueDate: Date(),
            priority: .low,
            context: context
        )

        let tasks = try context.fetch(FetchDescriptor<ChoreTask>())
        let task = try #require(tasks.first)

        #expect(task.isComplete == false)
        viewModel.toggleComplete(task)
        #expect(task.isComplete == true)
        viewModel.toggleComplete(task)
        #expect(task.isComplete == false)
    }

    @Test("Tasks sorted by priority orders high before low")
    @MainActor
    func tasksSortedByPriorityOrdersCorrectly() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = TaskViewModel()

        viewModel.addTask(title: "Low task", assignedMemberName: "Quel", dueDate: Date(), priority: .low, context: context)
        viewModel.addTask(title: "High task", assignedMemberName: "Quel", dueDate: Date(), priority: .high, context: context)
        viewModel.addTask(title: "Medium task", assignedMemberName: "Quel", dueDate: Date(), priority: .medium, context: context)

        let allTasks = try context.fetch(FetchDescriptor<ChoreTask>())
        viewModel.tasks = allTasks
        let sorted = viewModel.tasksSortedByPriority()

        #expect(sorted[0].title == "High task")
        #expect(sorted[1].title == "Medium task")
        #expect(sorted[2].title == "Low task")
    }

    @Test("Filter tasks by member name returns correct tasks")
    @MainActor
    func filterTasksByMemberName() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = TaskViewModel()

        viewModel.addTask(title: "Quel task", assignedMemberName: "Quel", dueDate: Date(), priority: .high, context: context)
        viewModel.addTask(title: "Other task", assignedMemberName: "Other", dueDate: Date(), priority: .low, context: context)

        let allTasks = try context.fetch(FetchDescriptor<ChoreTask>())
        viewModel.tasks = allTasks

        let quelTasks = viewModel.tasksForMember(named: "Quel")
        #expect(quelTasks.count == 1)
        #expect(quelTasks.first?.title == "Quel task")
    }

    @Test("Deleting task removes from context")
    @MainActor
    func deleteTaskRemovesFromContext() throws {
        let container = try makeTestContainer()
        let context = container.mainContext
        let viewModel = TaskViewModel()

        viewModel.addTask(
            title: "Take out trash",
            assignedMemberName: "Quel",
            dueDate: Date(),
            priority: .medium,
            context: context
        )

        let tasks = try context.fetch(FetchDescriptor<ChoreTask>())
        #expect(tasks.count == 1)

        viewModel.deleteTask(tasks[0], context: context)
        let remaining = try context.fetch(FetchDescriptor<ChoreTask>())
        #expect(remaining.isEmpty)
    }
}
