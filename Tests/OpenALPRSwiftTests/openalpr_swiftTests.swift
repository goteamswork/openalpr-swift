//
//  openalpr_swiftTests.swift
//  openalpr-swiftTests
//
//  Created by Yasir M Turk on 05/01/2018.
//  Copyright © 2018 Yasir M Türk. All rights reserved.
//

import XCTest
@testable import OpenALPRSwift

class OpenALPRSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOAScannerInitialization() {
        // Test that OAScanner can be initialized with country
        let scanner = OAScanner(country: "us")
        XCTAssertNotNil(scanner, "OAScanner should initialize successfully")
    }
    
    func testOATypesExist() {
        // Test that the types are accessible
        let character = OACharacter()
        XCTAssertNotNil(character, "OACharacter should be accessible")
        
        let results = OAResults()
        XCTAssertNotNil(results, "OAResults should be accessible")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
