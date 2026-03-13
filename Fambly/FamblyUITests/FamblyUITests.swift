import XCTest

final class FamblyUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI_TESTING"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    // MARK: - Dashboard Tests

    func test_dashboardLoadsOnLaunch() {
        let dashboardTitle = app.navigationBars["Dashboard"]
        XCTAssertTrue(dashboardTitle.waitForExistence(timeout: 3))
    }

    func test_dashboardShowsSummaryCards() {
        XCTAssertTrue(app.staticTexts["Due Today"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Overdue"].exists)
        XCTAssertTrue(app.staticTexts["Done Today"].exists)
    }

    // MARK: - Family Tab Tests

    func test_familyTabIsAccessible() {
        app.tabBars.buttons["Family"].tap()
        let navTitle = app.navigationBars["Family"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 3))
    }

    func test_addMemberSheetOpens() {
        app.tabBars.buttons["Family"].tap()
        app.buttons["person.badge.plus"].tap()
        XCTAssertTrue(app.navigationBars["Add Member"].waitForExistence(timeout: 3))
    }

    func test_addMemberAndVerifyInList() {
        app.tabBars.buttons["Family"].tap()
        app.buttons["person.badge.plus"].tap()

        let nameField = app.textFields["Full name"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 3))
        nameField.tap()
        nameField.typeText("Quel")

        app.buttons["Add"].tap()

        XCTAssertTrue(app.staticTexts["Quel"].waitForExistence(timeout: 3))
    }

    func test_cancelAddMemberDismissesSheet() {
        app.tabBars.buttons["Family"].tap()
        app.buttons["person.badge.plus"].tap()

        XCTAssertTrue(app.navigationBars["Add Member"].waitForExistence(timeout: 3))
        app.buttons["Cancel"].tap()

        XCTAssertFalse(app.navigationBars["Add Member"].exists)
    }

    // MARK: - Chores Tab Tests

    func test_choresTabIsAccessible() {
        app.tabBars.buttons["Chores"].tap()
        XCTAssertTrue(app.navigationBars["Chores"].waitForExistence(timeout: 3))
    }

    func test_addTaskSheetOpens() {
        app.tabBars.buttons["Chores"].tap()
        app.buttons["Add"].tap()
        XCTAssertTrue(app.navigationBars["Add Chore"].waitForExistence(timeout: 3))
    }

    func test_cancelAddTaskDismissesSheet() {
        app.tabBars.buttons["Chores"].tap()
        app.buttons["Add"].tap()

        XCTAssertTrue(app.navigationBars["Add Chore"].waitForExistence(timeout: 3))
        app.buttons["Cancel"].tap()

        XCTAssertFalse(app.navigationBars["Add Chore"].exists)
    }

    func test_filterSegmentControlExists() {
        app.tabBars.buttons["Chores"].tap()
        XCTAssertTrue(app.segmentedControls.firstMatch.waitForExistence(timeout: 3))
    }

    func test_filterSegmentHasThreeOptions() {
        app.tabBars.buttons["Chores"].tap()
        let segControl = app.segmentedControls.firstMatch
        XCTAssertTrue(segControl.waitForExistence(timeout: 3))
        XCTAssertEqual(segControl.buttons.count, 3)
    }

    // MARK: - Navigation Flow Tests

    func test_allThreeTabsAreAccessible() {
        XCTAssertTrue(app.tabBars.buttons["Dashboard"].exists)
        XCTAssertTrue(app.tabBars.buttons["Family"].exists)
        XCTAssertTrue(app.tabBars.buttons["Chores"].exists)
    }

    func test_tabNavigationBetweenScreens() {
        app.tabBars.buttons["Family"].tap()
        XCTAssertTrue(app.navigationBars["Family"].waitForExistence(timeout: 3))

        app.tabBars.buttons["Chores"].tap()
        XCTAssertTrue(app.navigationBars["Chores"].waitForExistence(timeout: 3))

        app.tabBars.buttons["Dashboard"].tap()
        XCTAssertTrue(app.navigationBars["Dashboard"].waitForExistence(timeout: 3))
    }
}
