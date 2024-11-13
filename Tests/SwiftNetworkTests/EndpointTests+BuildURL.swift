//
//  EndpointTests+BuildURL.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class EndpointTests: XCTestCase {

    struct MockEndpoint: Requestable {
        var path: String
        var method: HTTPMethod = .GET
        var environment: EnvironmentConfigurable
        
        init(path: String, environment: EnvironmentConfigurable) {
            self.path = path
            self.environment = environment
        }
    }

    func testBuildURL() {
        let environment = Environment(baseURL: "https://api.example.com", apiKey: "123456")
        let endpoint = MockEndpoint(path: "/users", environment: environment)
        
        let expectedURL = URL(string: "https://api.example.com/users")
        let actualURL = endpoint.url
        
        XCTAssertEqual(expectedURL, actualURL, "URL should be correctly constructed.")
    }

    func testBuildInvalidURL() {
        let environment = Environment(baseURL: "invalid-url", apiKey: "123456")
        let endpoint = MockEndpoint(path: "/users", environment: environment)
        
        let actualURL = endpoint.url
        
        XCTAssertNil(actualURL, "Invalid base URL should return nil.")
    }
}
