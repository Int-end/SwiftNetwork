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
        // Define a custom environment with a base URL
        struct TestEnvironment: EnvironmentConfigurable {
            var baseURL: String = "https://jsonplaceholder.typicode.com"
            var apiKey: String = "dummyApiKey"
        }

        let environment = TestEnvironment()
        
        // Ensure the environment has the correct base URL
        XCTAssertEqual(environment.baseURL, "https://jsonplaceholder.typicode.com")
        XCTAssertEqual(environment.apiKey, "dummyApiKey")
    }
}
