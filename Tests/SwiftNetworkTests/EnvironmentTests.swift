//
//  EnvironmentTests.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class EnvironmentTests: XCTestCase {
    private var environment: Environment!
    private var testEnvironment: TestEnvironment!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        environment = Environment(baseURL: Mock.baseURL, apiKey: "API KEY")
        testEnvironment = TestEnvironment(environment: .init(baseURL: Mock.baseURL, apiKey: "API KEY"))
    }
    
    override func tearDownWithError() throws {
        environment = nil
        testEnvironment = nil
        try super.tearDownWithError()
    }
}

// MARK: - Base Environment Tests
extension EnvironmentTests {
    func testEnvironmentBaseURL() {
        XCTAssertEqual(environment.baseURL, Mock.baseURL)
    }
    
    func testEnvironmentAPIKey() {
        XCTAssertEqual(environment.apiKey, "API KEY")
    }
}

// MARK: - Test Environment Tests
extension EnvironmentTests {
    func testTestEnvironmentBaseURL() {
        XCTAssertEqual(testEnvironment.baseURL, Mock.baseURL)
    }
    
    func testTestEnvironmentAPIKey() {
        XCTAssertEqual(testEnvironment.apiKey, "API KEY")
    }
}
