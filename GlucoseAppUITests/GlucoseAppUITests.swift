//
//  GlucoseAppUITests.swift
//  GlucoseAppUITests
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import XCTest
import GlucoseAppHelper

class GlucoseAppUITests: XCTestCase {
    
    var app: XCUIApplication {
        return XCUIApplication()
    }
    
    var loginScreenLogo: XCUIElement { return app.images["loginScreenLogo"] }
    var usernameField: XCUIElement { return app.staticTexts["Usuario CareLink™"] }
    var passwordField: XCUIElement { return app.staticTexts["Contraseña"] }
    var forgotPasswordLink: XCUIElement { return app.staticTexts["¿Ha olvidado su contraseña?"] }
    var loginButton: XCUIElement { return app.buttons["Iniciar sesión"] }
    
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test  method in the class.
        let app = XCUIApplication()
        app.launchArguments = [TestingConst.TESTING_FLAG]
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func loginPageElementsTest() throws {
        XCTAssertTrue(loginScreenLogo.exists)
        XCTAssertTrue(usernameField.exists)
        XCTAssertTrue(passwordField.exists)
        XCTAssertTrue(forgotPasswordLink.exists)
        XCTAssertTrue(loginButton.exists)
    }
    
    func login() throws {
        
        usernameField.tap()
        usernameField.typeText(TestingConst.TESTING_USERNAME)
        passwordField.tap()
        passwordField.typeText(TestingConst.TESTING_USERNAME)
    }
    
    func testLaunchPerformance() throws {
        if #available(iOS 15.0, watchOS 8.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
