//
//  Endpoint+FailureResponse+NoData.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

extension EndpointTests {
    func testPerformRequestFailureNoData() {
        let environment = Environment(baseURL: "https://api.example.com", apiKey: "123456")
        let endpoint = MockEndpoint(path: "/users", environment: environment)
        let expectation = self.expectation(description: "Perform request completes")
        
        endpoint.performRequest { (result: Result<[String: String], NetworkError>) in
            switch result {
            case .success:
                XCTFail("Request should fail due to no data.")
            case .failure(let error):
                if case .noData = error {
                    // Expected no data error
                } else {
                    XCTFail("Expected no data error, got: \(error)")
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
