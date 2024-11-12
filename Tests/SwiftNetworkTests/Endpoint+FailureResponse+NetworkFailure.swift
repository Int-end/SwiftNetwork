//
//  Endpoint+FailureResponse+NetworkFailure.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

extension EndpointTests {
    func testPerformRequestFailureNetworkError() {
        let environment = Environment(baseURL: "https://api.example.com", apiKey: "123456")
        let endpoint = MockEndpoint(path: "/users", environment: environment)
        let expectation = self.expectation(description: "Perform request completes")
        
        endpoint.perform { (result: Result<[String: String], NetworkError>) in
            switch result {
            case .success:
                XCTFail("Request should fail with network error.")
            case .failure(let error):
                if case .networkFailure(_) = error {
                    // Expected network failure error
                } else {
                    XCTFail("Expected network failure error, got: \(error)")
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
