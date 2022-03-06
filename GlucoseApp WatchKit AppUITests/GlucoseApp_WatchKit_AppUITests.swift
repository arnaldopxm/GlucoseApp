//
//  GlucoseApp_WatchKit_AppUITests.swift
//  GlucoseApp WatchKit AppUITests
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import XCTest
import GlucoseAppHelper

class GlucoseApp_WatchKit_AppUITests: XCTestCase {
    
    var app: XCUIApplication { return XCUIApplication() }
    var gs: XCUIElement { return app.descendants(matching: .any)["gsValue"] }
    var gsTrend: XCUIElement { return app.descendants(matching: .any)["gsTrendValue"] }
    var gsTime: XCUIElement { return app.staticTexts["gsTimeValue"] }
    var gsTimeOffset: XCUIElement { return app.staticTexts["gsTimeOffsetValue"] }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    private func launchUserNotLoggedIn() {
        let app = XCUIApplication()
        app.launchArguments = [TestingConst.TESTING_FLAG]
        app.launch()
    }
    
    private func launchUserLoggedIn() {
        let app = XCUIApplication()
        app.launchArguments = [TestingConst.TESTING_FLAG, TestingConst.TESTING_FLAG_WATCH_LOGGED_IN]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //Un usuario sin credenciales guardadas, al abrir la aplicación en el Apple Watch
    //no debe ser capaz de ver los datos de glucosa y tendencia en la pantalla principal.
    func testAppData_FAIL() throws {
        launchUserNotLoggedIn()
        XCTAssertTrue(gs.exists)
        XCTAssertEqual(gs.label, "---")
        XCTAssertTrue(gsTime.exists)
        XCTAssertEqual(gsTime.label, "---")
        XCTAssertTrue(gsTimeOffset.exists)
        XCTAssertEqual(gsTimeOffset.label, "Hace X min.")
        XCTAssertTrue(gsTrend.exists)
    }
    
    //Un usuario con credenciales guardadas, al abrir la aplicación en el Apple Watch
    //debe poder ver los datos de glucosa y tendencia en la pantalla principal.
    func testAppData_OK() throws {
        launchUserLoggedIn()
        XCTAssertTrue(gs.exists)
        XCTAssertNotEqual(gs.label, "---")
        XCTAssertTrue(gsTime.exists)
        XCTAssertNotEqual(gsTime.label, "---")
        XCTAssertTrue(gsTimeOffset.exists)
        XCTAssertNotEqual(gsTimeOffset.label, "Hace X min.")
        XCTAssertTrue(gsTrend.exists)
    }

    func testLaunchPerformance() throws {
        if #available(watchOS 8.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
