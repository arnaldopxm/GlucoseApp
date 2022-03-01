//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 11/2/22.
//

import Foundation

import XCTest
@testable import GlucoseAppHelper

final class AppStateTests: XCTestCase {
    
    private static var sampleGs: GlucoseModel {
        let gsValue = GlucoseModel(value: 100)
        return gsValue
    }
    
    private static var sampleGsTrend: GlucoseTrendModel {
        let gsTrendValue = GlucoseTrendModel(trend: .UP_DOUBLE)
        return gsTrendValue
    }
    
    private static var sampleGsTime: GlucoseTimeModel {
        let gsTimeValue = GlucoseTimeModel(dateTime: Date.now)
        return gsTimeValue
    }
    
    private static var sampleState: AppState {
        let state = AppState(gs: sampleGs, gsTrend: sampleGsTrend, gsTime: sampleGsTime)
        return state
    }
    
    // GIVEN: base values for Gs, GsTime and GsTrend
    // WHEN: creating a new GlucoseModel instance
    // THEN: the property values must match the inital base values
    func testInitGetValue_OK() {
        let gsValue = AppStateTests.sampleGs
        let gsTrendValue = AppStateTests.sampleGsTrend
        let gsTimeValue = AppStateTests.sampleGsTime
        let state = AppState(gs: gsValue, gsTrend: gsTrendValue, gsTime: gsTimeValue)
        
        let gsExpected = state.gs
        XCTAssertEqual(gsValue, gsExpected)
        
        let gsTimeExpected = state.gsTime
        XCTAssertEqual(gsTimeValue, gsTimeExpected)
        
        let gsTrendExpected = state.gsTrend
        XCTAssertEqual(gsTrendValue, gsTrendExpected)
    }
    
    // GIVEN: base values for Gs, GsTime and GsTrend
    // WHEN: creating a new GlucoseModel instance
    // AND: modifying the original values
    // THEN: the property values must match the inital base values
    func testInitGetValueChanges_OK() {
        let state = AppStateTests.sampleState
        
        let gsValue = GlucoseModel(value: 101)
        let gsExpected = state.gs
        XCTAssertNotEqual(gsValue, gsExpected)
        
        let gsTimeValue = GlucoseTimeModel(dateTime: Date.now)
        let gsTimeExpected = state.gsTime
        XCTAssertNotEqual(gsTimeValue, gsTimeExpected)
        
        let gsTrendValue = GlucoseTrendModel(trend: .DOWN_TRIPLE)
        let gsTrendExpected = state.gsTrend
        XCTAssertNotEqual(gsTrendValue, gsTrendExpected)
    }
    
    // GIVEN: An AppState model with a GlucoseTimeModel value of less than 5 minutes from "now"
    // WHEN: The isValue function is called
    // THEN: The result should be true
    func testIsValidTrue_OK() {
        let state = AppStateTests.sampleState
        let value = state.isValid()
        let expected = true
        
        XCTAssertEqual(value, expected)
    }
    
    // GIVEN: An AppState model with a GlucoseTimeModel value of more than 5 minutes from "now"
    // WHEN: The isValue function is called
    // THEN: The result should be true
    func testIsValidFalse_OK() {
        let state = AppStateTests.sampleState
        state.gsTime = GlucoseTimeModel(dateTime: Date.now.addingTimeInterval(-10 * 60))
        let value = state.isValid()
        let expected = false
        
        XCTAssertEqual(value, expected)
    }
}
