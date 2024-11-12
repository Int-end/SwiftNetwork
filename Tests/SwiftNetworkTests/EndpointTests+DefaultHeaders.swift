//
//  EndpointTests+DefaultHeaders.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

extension EndpointTests {

    func testDefaultHeadersWithAPIKey() {
        let environment = Environment(baseURL: "https://api.example.com", apiKey: "123456")
        let endpoint = MockEndpoint(path: "/users", environment: environment)
        
        let expectedHeaders = ["Authorization": "Bearer 123456"]
        let actualHeaders = endpoint.defaultHeaders()
        
        XCTAssertEqual(expectedHeaders, actualHeaders, "Headers should include Authorization with API key.")
    }

    func testDefaultHeadersWithoutAPIKey() {
        let environment = Environment(baseURL: "https://api.example.com", apiKey: "")
        let endpoint = MockEndpoint(path: "/users", environment: environment)
        
        let actualHeaders = endpoint.defaultHeaders()
        
        XCTAssertNil(actualHeaders?["Authorization"], "Headers should not include Authorization without API key.")
    }
}
