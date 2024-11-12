//
//  Endpoint+PerformRequest.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

extension EndpointTests {
    func testPerformRequestSuccess() {
        let environment = Environment(baseURL: "https://api.example.com", apiKey: "123456")
        let endpoint = MockEndpoint(path: "/users", environment: environment)
        let expectation = self.expectation(description: "Perform request completes")
        
        endpoint.performRequest { (result: Result<[String: String], NetworkError>) in
            switch result {
            case .success(let data):
                XCTAssertEqual(data["name"], "John Doe", "Response should be decoded correctly.")
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}

