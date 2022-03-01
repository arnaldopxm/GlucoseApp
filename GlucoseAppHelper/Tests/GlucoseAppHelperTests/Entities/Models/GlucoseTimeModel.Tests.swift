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

final class GlucoseTimeModelTests: XCTestCase {

    let dateConstString = "2000-01-01T10:11:55.123Z"

    // GIVEN: the current date value
    // WHEN: creating a new GlucoseTimeModel instance
    // THEN: the property value must match the inital int value
    func testInitGetValue_OK() {
        let value = Date.now
        let gsTime = GlucoseTimeModel(dateTime: value)
        let expected = gsTime.value
        XCTAssertEqual(value, expected)
    }

    // GIVEN: the current date value
    // WHEN: creating a new GlucoseTimeModel instance
    // AND: modifiend the original date value, by adding it up 1
    // THEN: the property value must not match the value changed
    func testInitGetValueChanges_OK() {
        var value = Date.now
        let gsTime = GlucoseTimeModel(dateTime: value)
        value.addTimeInterval(10)
        let expected = gsTime.value
        XCTAssertNotEqual(value, expected)
    }
    
    // GIVEN: the current date value
    // WHEN: creating a new GlucoseTimeModel instance using the string representation of the date
    // THEN: the property value must match the inital int value
    func testInitStringGetValue_OK() {
        let format = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = Date.now
        let value = DateTimeService.dateToString(date: date, format: format)
        let gsTime = GlucoseTimeModel(dateTime: value)
        let expected = DateTimeService.dateToString(date: gsTime.value!, format: format)
        XCTAssertEqual(value, expected)
    }
    
    // GIVEN: the current date value
    // WHEN: creating a new GlucoseTimeModel instance using the string representation of the date
    // AND: modifiend the original date value, by adding it up 1
    // THEN: the property value must not match the value changed
    func testInitStringGetValueChanges_OK() {
        var value = Date.now
        let stringValue = DateTimeService.dateToString(date: value)
        let gsTime = GlucoseTimeModel(dateTime: stringValue)
        value.addTimeInterval(10)
        let expected = gsTime.value
        XCTAssertNotEqual(value, expected)
    }

    // GIVEN: a date value, and two identical Glucose Models created from it.
    // WHEN: The equal function is called between them
    // THEN: The result should be true
    func testEqualsSameObject_OK() {
        let date = Date.now
        let value = GlucoseTimeModel(dateTime: date)
        let expected = GlucoseTimeModel(dateTime: date)
        let resultTrue = value == expected
        XCTAssertEqual(value, expected)
        XCTAssertTrue(resultTrue)
    }

    // GIVEN: two distinct GlucoseTimeModels.
    // WHEN: The equal function is called between them
    // THEN: The result should be false
    func testEqualsDistinctObject_OK() {
        let value = GlucoseTimeModel(dateTime: Date.now)
        let expected = GlucoseTimeModel(dateTime: Date.now)
        let resultTrue = value != expected
        XCTAssertNotEqual(value, expected)
        XCTAssertTrue(resultTrue)
    }

    // GIVEN: a GlucoseTimeModel with value "2000.01.01-10.11.00"
    // WHEN: the getFormattedHour is called
    // THEN: the response should be "10:11 h"
    func testGetFormattedHour_OK() {
        let date = DateTimeService.stringToDateTime(stringValue: dateConstString)!
        let gsTime = GlucoseTimeModel(dateTime: date)
        let expected = "10:11 h"
        let value = gsTime.getFormattedHourTime()
        XCTAssertEqual(value, expected)
    }
    
    // GIVEN: a GlucoseTimeModel with value "2000.01.01-10.11.00"
    // WHEN: the getFormattedHour is called
    // THEN: the response should be "10:11 h"
    func testGetFormattedHourNull_OK() {
        let gsTime = GlucoseTimeModel(dateTime: nil)
        let expected = "---"
        let value = gsTime.getFormattedHourTime()
        XCTAssertEqual(value, expected)
    }
    
    // GIVEN: a GlucoseTimeModel with the current time + offset in min
    // WHEN: the getPastTimeSinceNow is called
    // THEN: the response should be the offset sued
    func testPastTimeSinceNow_OK() {
        let offset = -10 * 60.0
        let date = Date.now.addingTimeInterval(offset)
        let gsTime = GlucoseTimeModel(dateTime: date)
        let expected = Int(-offset / 60)
        let value = gsTime.getPastTimeSinceNow()
        XCTAssertEqual(value, expected)
    }
    
    // GIVEN: a GlucoseTimeModel with the current time + offset in min
    // WHEN: the getPastTimeSinceNow is called
    // THEN: the response should be the offset sued
    func testPastTimeSinceNowNull_OK() {
        let gsTime = GlucoseTimeModel(dateTime: nil)
        let expected: Int? = nil
        let value = gsTime.getPastTimeSinceNow()
        XCTAssertEqual(value, expected)
    }
    
    // GIVEN: a GlucoseTimeModel with the current time + offset in min
    // WHEN: the getPastTimeSinceNowString is called
    // THEN: the response should be the "Hace <<offset> min."
    func testPastTimeSinceNowString_OK() {
        let offset = -10 * 60.0
        let date = Date.now.addingTimeInterval(offset)
        let gsTime = GlucoseTimeModel(dateTime: date)
        let expected = "Hace \(Int(-offset / 60)) min."
        let value = gsTime.getPastTimeSinceNowString()
        XCTAssertEqual(value, expected)
    }
    
    // GIVEN: a GlucoseTimeModel with the current time + offset in min
    // WHEN: the getPastTimeSinceNow is called
    // THEN: the response should be the offset sued
    func testPastTimeSinceNowStringNull_OK() {
        let gsTime = GlucoseTimeModel(dateTime: nil)
        let expected: String = "---"
        let value = gsTime.getPastTimeSinceNowString()
        XCTAssertEqual(value, expected)
    }
}
