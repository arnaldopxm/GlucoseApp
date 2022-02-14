//
//  File.swift
//
//
//  Created by Arnaldo Quintero on 11/2/22.
//

import Foundation

import XCTest
import SwiftUI
@testable import GlucoseAppHelper

final class GlucoseModelTests: XCTestCase {
    
//    let okGsValue = 80
//    let highGsValue = 300
//    let lowGsValue = 60
//
    // GIVEN: a random int value
    // WHEN: creating a new GlucoseModel instance
    // THEN: the property value must match the inital int value
    func testStaticParseDateFromFormat_OK() {
        let input = "2021-03-01T17:50:10.123Z"
        let gsTime = GlucoseTimeModel.getDate(datetimeString: input)!
        XCTAssertEqual(value, expected)
    }
//
//    // GIVEN: a random int value
//    // WHEN: creating a new GlucoseModel instance
//    // AND: modifiend the original random int value, by adding it up 1
//    // THEN: the property value must not match the value changed
//    func testInitGetValueChanges_OK() {
//        var value = Int.random(in: 0..<999)
//        let gs = GlucoseModel(value: value)
//        value += 1
//        let expected = gs.value
//        XCTAssertNotEqual(value, expected)
//    }
//
//    // GIVEN: a normal glucose value, and two identical Glucose Models created from it.
//    // WHEN: The equal function is called between them
//    // THEN: The result should be true
//    func testEqualsSameObject_OK() {
//        let value = GlucoseModel(value: okGsValue)
//        let expected = GlucoseModel(value: okGsValue)
//        let resultTrue = value == expected
//        XCTAssertEqual(value, expected)
//        XCTAssertTrue(resultTrue)
//    }
//
//    // GIVEN: two distinct Glucose Models.
//    // WHEN: The equal function is called between them
//    // THEN: The result should be false
//    func testEqualsDistinctObject_OK() {
//        let value = GlucoseModel(value: highGsValue)
//        let expected = GlucoseModel(value: okGsValue)
//        let resultTrue = value != expected
//        XCTAssertNotEqual(value, expected)
//        XCTAssertTrue(resultTrue)
//    }
//
//    // GIVEN: a normal glucose value
//    // WHEN: the getColorMethod is called
//    // THEN: the Color("Green") must be returned
//    func testGetColorOkGsValue_OK() {
//        let gs = GlucoseModel(value: okGsValue)
//        let value = gs.getColor()
//        let expected = Color("Green")
//        XCTAssertEqual(value, expected)
//    }
//
//    // GIVEN: a high glucose value
//    // WHEN: the getColorMethod is called
//    // THEN: the Color("Orange") must be returned
//    func testGetColorHighGsValue_OK() {
//        let gs = GlucoseModel(value: highGsValue)
//        let value = gs.getColor()
//        let expected = Color("Orange")
//        XCTAssertEqual(value, expected)
//    }
//
//    // GIVEN: a low glucose value
//    // WHEN: the getColorMethod is called
//    // THEN: the Color("Red") must be returned
//    func testGetColorLowGsValue_OK() {
//        let gs = GlucoseModel(value: lowGsValue)
//        let value = gs.getColor()
//        let expected = Color("Red")
//        XCTAssertEqual(value, expected)
//    }
    
}
