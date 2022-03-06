//
//  GlucoseAppUITests.swift
//  GlucoseAppUITests
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import XCTest
import GlucoseAppHelper

class GlucoseAppUITests: XCTestCase {
    
    var app: XCUIApplication { return XCUIApplication() }
    var loginScreenLogo: XCUIElement { return app.images["loginScreenLogo"] }
    var usernameField: XCUIElement { return app.staticTexts["Usuario CareLink™"] }
    var passwordField: XCUIElement { return app.staticTexts["Contraseña"] }
    var forgotPasswordLink: XCUIElement { return app.staticTexts["¿Ha olvidado su contraseña?"] }
    var loginButton: XCUIElement { return app.buttons["Iniciar sesión"] }
    var logoutButton: XCUIElement { return app.buttons["Cerrar sesión"] }
    var contentScreenLogo: XCUIElement { return app.images["dataDripIcon"] }
    var gs: XCUIElement { return app.staticTexts["gsValue"] }
    var gsTrend: XCUIElement { return app.descendants(matching: .any)["gsTrendValue"] }
    var gsTime: XCUIElement { return app.staticTexts["gsTimeValue"] }
    var gsTimeOffset: XCUIElement { return app.staticTexts["gsTimeOffsetValue"] }
    
    override func setUpWithError() throws {
        let app = XCUIApplication()
        app.launchArguments = [TestingConst.TESTING_FLAG]
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Un usuario sin credenciales guardadas introduce credenciales incorrectas en el iPhone,
    // presiona el botón de iniciar sesión y debe mantenerse en la página de inicio de sesión.
    func testLogin_FAIL() throws {
        usernameField.tap()
        app.typeText(TestingConst.TESTING_USERNAME+"123")
        passwordField.tap()
        app.typeText(TestingConst.TESTING_PASSWORD+"123")
        loginButton.tap()
        
        XCTAssertTrue(loginScreenLogo.waitForExistence(timeout: 10))
        XCTAssertTrue(usernameField.exists)
        XCTAssertTrue(passwordField.exists)
        XCTAssertTrue(forgotPasswordLink.exists)
        XCTAssertTrue(loginButton.exists)
    }
    
    //Un usuario sin credenciales guardadas introduce credenciales en el iPhone correctas,
    // presiona el botón de iniciar sesión y debe ser redirigido a la página principal de la aplicación.
    func testLogin_OK() throws {
        usernameField.tap()
        app.typeText(TestingConst.TESTING_USERNAME)
        passwordField.tap()
        app.typeText(TestingConst.TESTING_PASSWORD)
        loginButton.tap()

        XCTAssertTrue(contentScreenLogo.waitForExistence(timeout: 10))
        XCTAssertTrue(logoutButton.exists)
        
    }
    
    // Un usuario con credenciales guardadas presiona el botón de cerrar sesión
    // y debe ser redirigido a la página de inicio de sesión de la aplicación.
    func testLogout_OK() throws {
        try testLogin_OK()
        logoutButton.tap()
        
        XCTAssertTrue(loginScreenLogo.waitForExistence(timeout: 10))
        XCTAssertTrue(usernameField.exists)
        XCTAssertTrue(passwordField.exists)
        XCTAssertTrue(forgotPasswordLink.exists)
        XCTAssertTrue(loginButton.exists)
    }
    
    // Un usuario con credenciales guardadas, sin interacción alguna,
    // debe poder ver los datos de glucosa y tendencia en la pantalla principal.
    func testLoggedInCanViewData_OK() throws {
        try testLogin_OK()

        XCTAssertTrue(gs.exists)
        XCTAssertNotNil(gs.value)
        XCTAssertTrue(gsTime.exists)
        XCTAssertNotNil(gsTime.value)
        XCTAssertTrue(gsTrend.exists)
        XCTAssertNotNil(gsTrend.value)
        XCTAssertTrue(gsTimeOffset.exists)
        XCTAssertNotNil(gsTimeOffset.value)
                                
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
