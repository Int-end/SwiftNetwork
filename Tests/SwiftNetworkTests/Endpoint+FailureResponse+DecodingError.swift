//
//  Endpoint+FailureResponse+DecodingError.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

extension EndpointTests {
    func testPerformRequestFailureDecodingError() {
        let environment = Environment(baseURL: "https://api.example.com", apiKey: "123456")
        let endpoint = MockEndpoint(path: "/users", environment: environment)
        let expectation = self.expectation(description: "Perform request completes")
        
        endpoint.perform { (result: Result<[String: String], NetworkError>) in
            switch result {
            case .success:
                XCTFail("Request should fail due to decoding error.")
            case .failure(let error):
                if case .decodingError(_) = error {
                    // Expected decoding error
                } else {
                    XCTFail("Expected decoding error, got: \(error)")
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
