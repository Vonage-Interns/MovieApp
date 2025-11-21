//
//  MovieAppUITests.swift
//  MovieAppUITests
//
//  Created by Shreeshailgouda Patil on 21/11/25.
//

import XCTest
@testable import MovieApp

final class MovieAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func test_signInSuccess() throws {
            let app = XCUIApplication()
                    app.launch()
        
            // Find the text fields – update identifiers as needed
            let emailField = app.textFields["emailTextField"]
            let passwordField = app.secureTextFields["passwordTextField"]
            let loginButton = app.buttons["loginButton"]

            // Interact with UI
            emailField.tap()
            emailField.typeText("testuser2@gmail.com")

            passwordField.tap()
            passwordField.typeText("testuser2")

            loginButton.tap()

            // Assert new screen appears or an element exists
                    let homeLabel = app.staticTexts["Movies"]
            XCTAssertTrue(homeLabel.waitForExistence(timeout: 5))
        
                
        }
    
    func test_signInFailure() throws {
        let app = XCUIApplication()
        app.launch()

        app.textFields["emailTextField"].tap()
        app.textFields["emailTextField"].typeText("wrong@example.com")

        app.secureTextFields["passwordTextField"].tap()
        app.secureTextFields["passwordTextField"].typeText("wrongpass")

        app.buttons["loginButton"].tap()

        let alert = app.alerts["Error"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2))
        XCTAssertTrue(alert.staticTexts["Invalid credentials"].exists)

    }

}
