//
//  EndpointTests.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class EndpointTests: XCTestCase {
    
    // Mock Environment to use in tests
    struct MockEnvironment: EnvironmentConfigurable {
        let baseURL: String
        let apiKey: String
        
        init(baseURL: String = "https://api.example.com", apiKey: String = "test_api_key") {
            self.baseURL = baseURL
            self.apiKey = apiKey
        }
    }
    
    // Test valid URL and request generation
    func testValidRequest() {
        struct TestEndpoint: Endpoint {
            var path: String = "/test"
            var method: HTTPMethod = .GET
            var headers: [String: String]? = nil
            var parameters: [String: QueryStringConvertible]? = nil
            var environment: EnvironmentConfigurable = MockEnvironment()
            var request: URLRequest? = nil
        }
        
        let endpoint = TestEndpoint()
        
        // The URL should be valid and properly formed
        let requestResult = endpoint.buildRequest
        switch requestResult {
        case .success(let request):
            XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/test")
            XCTAssertEqual(request.httpMethod, "GET")
        case .failure(let error):
            XCTFail("Expected success, but got error: \(error)")
        }
    }
    
    // Test invalid URL and request generation
    func testInvalidRequest() {
        struct TestEndpoint: Endpoint {
            var path: String = "/test"
            var method: HTTPMethod = .GET
            var headers: [String: String]? = nil
            var parameters: [String: QueryStringConvertible]? = nil
            var environment: EnvironmentConfigurable = MockEnvironment(baseURL: "invalid_url")
            var request: URLRequest? = nil
        }
        
        let endpoint = TestEndpoint()
        
        let requestResult = endpoint.buildRequest
        switch requestResult {
        case .success(_):
            XCTFail("Expected failure, but got a valid request.")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
}
