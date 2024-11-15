//
//  EndpointTests.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class EndpointTests: XCTestCase {
    func testGETURL() {
        let endpoint = MockGETEndpoint()
        XCTAssertEqual(endpoint.url?.absoluteString, "\(Mock.baseURL)\(Mock.Path.posts)", "The URL with parameters is incorrectly formed.")
    }
    
    func testSingleGETURL() {
        XCTAssertEqual(MockGETSingleEndpoint().url?.absoluteString, "\(Mock.baseURL)\(Mock.Path.singlePost)", "The URL with parameters is incorrectly formed.")
    }
    
    func testPOSTURL() {
        XCTAssertEqual(MockPOSTEndpoint().url?.absoluteString, "\(Mock.baseURL)\(Mock.Path.posts)", "The URL is incorrectly formed.")
    }
    
    func testPUTURL() {
        XCTAssertEqual(MockPUTEndpoint().url?.absoluteString, "\(Mock.baseURL)\(Mock.Path.singlePost)", "The URL is incorrectly formed.")
    }
    
    func testDELETEURL() {
        XCTAssertEqual(MockDELETEEndpoint().url?.absoluteString, "\(Mock.baseURL)\(Mock.Path.singlePost)", "The URL is incorrectly formed.")
    }
    
    func testDefaultHeaders() {
        let endpoint = MockGETEndpoint()
        let headers = endpoint.headers
        XCTAssertNotNil(headers)
        XCTAssertEqual(headers["Authorization"], "Bearer \(endpoint.environment.apiKey)")
    }
}

class MockGETEndpoint: Endpoint {
    let path: String
    let environment: EnvironmentConfigurable
    
    init(path: String = Mock.Path.posts, environment: EnvironmentConfigurable = Mock.environment) {
        self.path = path
        self.environment = environment
    }
}

class MockGETSingleEndpoint: Endpoint {
    let path: String
    let environment: EnvironmentConfigurable
    
    init(path: String = Mock.Path.singlePost, environment: EnvironmentConfigurable = Mock.environment) {
        self.path = path
        self.environment = environment
    }
}

class MockPOSTEndpoint: Endpoint {
    let path: String
    let parameters: [String: QueryStringConvertible]?
    let environment: EnvironmentConfigurable
    let method: HTTPMethod = .POST
    
    init(path: String = Mock.Path.posts,
         environment: EnvironmentConfigurable = Mock.environment,
         parameters: [String: QueryStringConvertible]? = ["userId": 1,
                                                          "id": 1,
                                                          "title": "Sit",
                                                          "body": "Back"]) {
        self.path = path
        self.environment = environment
        self.parameters = parameters
    }
}

class MockPUTEndpoint: Endpoint {
    let path: String
    let parameters: [String: QueryStringConvertible]?
    let environment: EnvironmentConfigurable
    let method: HTTPMethod = .PUT
    
    init(path: String = Mock.Path.singlePost,
         environment: EnvironmentConfigurable = Mock.environment,
         parameters: [String: QueryStringConvertible]? = ["userId": 1,
                                                          "title": "Sit",
                                                          "body": "Back"]) {
        self.path = path
        self.environment = environment
        self.parameters = parameters
    }
}

class MockDELETEEndpoint: Endpoint {
    let path: String
    let environment: EnvironmentConfigurable
    let method: HTTPMethod = .DELETE
    
    init(path: String = Mock.Path.singlePost,
         environment: EnvironmentConfigurable = Mock.environment) {
        self.path = path
        self.environment = environment
    }
}
