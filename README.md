# ios-qe-portfolio
# Fambly

A multiplatform family task management app built with SwiftUI and SwiftData,
targeting iPhone, iPad, and Mac from a single codebase.

Built as a portfolio project to demonstrate Swift Testing, XCTest UI automation,
and quality engineering practices for Apple platform development.

---

## Platform Support

| Platform | Status |
|----------|--------|
| iPhone (iOS 17+) | Supported |
| iPad (iPadOS 17+) | Supported |
| Mac (macOS 14+) | Supported |

---

## Features

- Add and manage family members with emoji avatars and color identifiers
- Create chores assigned to specific family members with due dates and priority levels
- Dashboard showing overdue tasks, tasks due today, and per-member progress
- Filter chores by All, Pending, or Completed
- Full SwiftData persistence across sessions
- Native navigation patterns per platform: bottom tab bar on iPhone/iPad,
  sidebar navigation on Mac

---

## Testing

This project follows a test-first approach. Tests are written before or
alongside features, not added after.

### Test Stack

| Layer | Framework | Count |
|-------|-----------|-------|
| Unit (Models) | Swift Testing | 13 |
| Integration (ViewModels) | Swift Testing | 12 |
| UI Automation | XCUITest | 13 |
| **Total** | | **38** |

### Running Tests
```bash
# All tests
cmd + U in Xcode

# From Terminal
xcodebuild test \
  -scheme Fambly \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest'
```

### Test Architecture

ViewModel tests use an in-memory `ModelContainer` to ensure full test isolation.
Each test starts with a clean data state and has zero dependency on persistent storage.
```swift
func makeTestContainer() throws -> ModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    return try ModelContainer(
        for: Member.self, ChoreTask.self,
        configurations: config
    )
}
```

### What's Tested

**Model layer**
- Member and ChoreTask initialization and default values
- Priority sort order and label formatting
- Edge cases: invalid raw values, empty states

**ViewModel layer**
- Validation logic: empty names, age range, unassigned tasks
- Error message state management
- Insert and delete operations against in-memory context
- Task filtering by member name
- Priority sort ordering across multiple tasks
- Toggle complete state flipping

**UI layer**
- App launches to Dashboard
- All three tabs are accessible
- Add member sheet opens, accepts input, and dismisses
- Add task sheet opens and dismisses
- Cancel buttons dismiss sheets without saving
- Filter segment control exists and has correct option count
- Full tab navigation flow

---

## CI/CD

GitHub Actions runs the full test suite on every push to `main` and all
`feat/*` branches.
```yaml
on:
  push:
    branches: [ main, feat/* ]
  pull_request:
    branches: [ main ]
```

---

## Project Structure
```
Fambly/
├── Models/
│   ├── Member.swift          # SwiftData model for family members
│   ├── ChoreTask.swift       # SwiftData model for tasks
│   └── Priority.swift        # Enum with sort order and label logic
├── ViewModels/
│   ├── MemberViewModel.swift # Member validation and CRUD
│   └── TaskViewModel.swift   # Task validation, filtering, sorting
├── Views/
│   ├── Dashboard/
│   │   └── DashboardView.swift
│   ├── Members/
│   │   ├── MemberListView.swift
│   │   ├── MemberRowView.swift
│   │   └── AddMemberView.swift
│   └── Tasks/
│       ├── TaskListView.swift
│       ├── TaskRowView.swift
│       └── AddTaskView.swift
├── Utilities/
│   └── Color+Hex.swift       # SwiftUI Color extension for hex support
FamblyTests/
└── FamblyTests.swift         # Swift Testing unit and ViewModel tests
FamblyUITests/
└── FamblyUITests.swift       # XCUITest UI automation suite
```

---

## Tech Stack

| Technology | Usage |
|------------|-------|
| Swift 5.9 | Primary language |
| SwiftUI | UI framework |
| SwiftData | Persistence |
| Swift Testing | Unit and ViewModel tests |
| XCTest / XCUITest | UI automation |
| GitHub Actions | CI/CD pipeline |
| Xcode 15+ | IDE |

---

## Test Philosophy

Testing is not a phase that happens after development. Every ViewModel in
this project has validation logic that was written with testability as the
primary design constraint. Guard statements exist not just to protect the
UI but to give tests clean, predictable failure paths to verify.

Priority is treated as a first-class concept with explicit sort ordering,
reflecting real QE thinking about severity and triage.

---

## Author

Racquel Rolle
[LinkedIn](www.linkedin.com/in/racquel-r-101540195) |
[GitHub](https://github.com/mumsz)
