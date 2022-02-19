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

final class GlucoseTrendModelTests: XCTestCase {
    
    // GIVEN: every possible SgTrendValue
    // WHEN: creating a new GlucoseTrendModel instance
    // THEN: the property value must match the inital value
    func testInitGetValue_OK() {
        for trend in SgTrend.allCases {
            let value = trend.rawValue
            let trendModel = GlucoseTrendModel(trend: trend)
            let expected = trendModel.value
            XCTAssertEqual(value, expected)
        }
        
    }
    
    // GIVEN: a specific trend value
    // WHEN: creating a new GlucoseTrendModel instance
    // AND: changing the trend value to a distinct one
    // THEN: the property value must not match the changed trend value
    func testInitGetValueChanges_OK() {
        var trend = SgTrend.NONE
        let trendModel = GlucoseTrendModel(trend: trend)
        trend = SgTrend.DOWN
        let value = trend.rawValue
        let expected = trendModel.value
        XCTAssertNotEqual(value, expected)
    }

    // GIVEN: a normal glucose trend value, and two identical GlucoseTrendModels created from it.
    // WHEN: The equal function is called between them
    // THEN: The result should be true
    func testEqualsSameObject_OK() {
        let trend: SgTrend = .UP_DOUBLE
        let value = GlucoseTrendModel(trend: trend)
        let expected = GlucoseTrendModel(trend: trend)
        let resultTrue = value == expected
        XCTAssertEqual(value, expected)
        XCTAssertTrue(resultTrue)
    }

    // GIVEN: two distinct GlucoseTrendModels.
    // WHEN: The equal function is called between them
    // THEN: The result should be false
    func testEqualsDistinctObject_OK() {
        let value = GlucoseTrendModel(trend: .UP_DOUBLE)
        let expected = GlucoseTrendModel(trend: .DOWN_DOUBLE)
        let resultTrue = value != expected
        XCTAssertNotEqual(value, expected)
        XCTAssertTrue(resultTrue)
    }
}
