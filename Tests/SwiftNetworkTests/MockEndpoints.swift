//
//  MockEndpoints.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation
@testable import SwiftNetwork

// MARK: - Mock Endpoints
class MockGETEndpoint: Endpoint {
    let path: String
    let environment: EnvironmentConfigurable
    let method: HTTPMethod = .GET
    
    init(path: String = Mock.Path.posts, environment: EnvironmentConfigurable = Mock.environment) {
        self.path = path
        self.environment = environment
    }
}

class MockGETSingleEndpoint: Endpoint {
    let path: String
    let environment: EnvironmentConfigurable
    let method: HTTPMethod = .GET
    
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
         parameters: [String: QueryStringConvertible]? = ["userId": 1, "id": 1, "title": "Test", "body": "Test"]) {
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
         parameters: [String: QueryStringConvertible]? = ["userId": 1, "title": "Test", "body": "Test"]) {
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

// MARK: - Mock Requestables
class MockGETRequestable: MockGETEndpoint, Requestable {}
class MockGETSingleRequestable: MockGETSingleEndpoint, Requestable {}
class MockPOSTRequestable: MockPOSTEndpoint, Requestable {}
class MockPUTRequestable: MockPUTEndpoint, Requestable {}
class MockDELETERequestable: MockDELETEEndpoint, Requestable {} 