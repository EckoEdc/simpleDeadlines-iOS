//
//  Simple_Deadlines_UITests.swift
//  Simple Deadlines UITests
//
//  Created by Edric MILARET on 17-06-28.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import XCTest

class Simple_Deadlines_UITests: XCTestCase {
    
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
        
        //Notification permission alert
        if app.alerts.element.collectionViews.buttons["Allow"].exists {
            app.alerts.element.collectionViews.buttons["Allow"].tap()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func addTask(title: String, category: String) {
        let titleField = app.textFields["Task Title"]
        titleField.tap()
        titleField.typeText(title)
        let categoryField = app.textFields["Task Category"]
        categoryField.tap()
        categoryField.typeText(category)
    }
    
    func test1AddTask() {
        app.navigationBars["All"].buttons["+"].tap()
        addTask(title: "Task Test", category: "Test")
        app.navigationBars["Add Task"].buttons["Done"].tap()
        
        XCTAssert(app.tables.cells.count == 1)
    }
    
    func test2CancelAddTask() {
        let app = XCUIApplication()
        app.navigationBars["All"].buttons["+"].tap()
        app.navigationBars["Add Task"].buttons["Cancel"].tap()
        
        XCTAssert(app.navigationBars["All"].exists)
    }
    
    func test3SetTaskDone() {
        app.tables.cells.allElementsBoundByIndex[0].swipeLeft()
        app.tables.buttons["Done"].tap()
    }
    
    func test4ChangeCategory() {
        
        app.navigationBars["All"].buttons["+"].tap()
        addTask(title: "Task Category Test", category: "Different")
        app.navigationBars["Add Task"].buttons["Done"].tap()
        
        app.navigationBars["All"].buttons["All"].tap()
        app.buttons["Different"].tap()
        
        XCTAssert(app.tables.cells.count == 1)
    }
    
    func test5ArchiveCategory() {

        app.navigationBars["All"].buttons["All"].tap()
        app.buttons["Archive"].tap()

        XCTAssert(app.tables.cells.count == 1)
    }
    
    //Notification Delegate Bug
    func test6AddAndCancel() {
        app.tables.cells.allElementsBoundByIndex[0].tap()
        app.navigationBars["Add Task"].buttons["Cancel"].tap()
        app.navigationBars["All"].buttons["+"].tap()
        app.navigationBars["Add Task"].buttons["Cancel"].tap()
    }
    
    func test7DeleteTask() {
        
        while app.tables.cells.count > 0 {
            let cell = app.tables.cells.allElementsBoundByIndex[0]
            cell.swipeLeft()
            app.tables.buttons["Delete"].tap()
        }
        
        XCTAssert(app.tables.cells.count == 0)
    }
    
}
