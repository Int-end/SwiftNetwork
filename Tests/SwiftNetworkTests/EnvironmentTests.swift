//
//  EnvironmentTests.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class EnvironmentTests: XCTestCase {
    func testEnvironment() {
        // Ensure the environment has the correct base URL
        XCTAssertEqual(Mock.environment.baseURL, Mock.baseURL)
        XCTAssertEqual(Mock.environment.apiKey, "API KEY")
    }
}
