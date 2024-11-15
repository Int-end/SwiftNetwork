//
//  EndpointTests+DefaultHeaders.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class ActorNetworkTests: XCTestCase {}

// MARK: - GET
extension ActorNetworkTests {
    func testGETPerformNetworkRequest() async {
        let result: Result<[Post], NetworkError> = await MockGETRequestable().perform()
        switch result {
        case .success(let posts):
            XCTAssertGreaterThan(posts.count, 0, "Expected posts to be returned.")
        case .failure(let error):
            XCTFail("Request failed with error: \(error.description)")
        }
    }
    
    func testGETNetworkRequest() async {
        let result: Result<[Post], NetworkError> = await MockGETRequestable().fetch()
        switch result {
        case .success(let posts):
            XCTAssertGreaterThan(posts.count, 0, "Expected posts to be returned.")
        case .failure(let error):
            XCTFail("Request failed with error: \(error.description)")
        }
    }
}

// MARK: - GET Single Post
extension ActorNetworkTests {
    func testGETSinglePerformNetworkRequest() async {
        let result: Result<Post, NetworkError> = await MockGETSingleRequestable().perform()
        switch result {
        case .success(let post):
            XCTAssertNotNil(post)
        case .failure(let error):
            XCTFail("Request failed with error: \(error.description)")
        }
    }
    
    func testGETSingleNetworkRequest() async {
        let result: Result<Post, NetworkError> = await MockGETSingleRequestable().fetch()
        switch result {
        case .success(let (post)):
            XCTAssertNotNil(post)
        case .failure(let error):
            XCTFail("Request failed with error: \(error.description)")
        }
    }
}

// MARK: - POST
extension ActorNetworkTests {
    func testPOSTPerformNetworkRequest() async {
        let result: Result<EmptyResponse, NetworkError> = await MockPOSTRequestable().perform()
        switch result {
        case .success(let empty):
            XCTAssertNotNil(empty)
        case .failure(let error):
            XCTFail("Request failed with error: \(error.description)")
        }
    }
    
    func testPOSTNetworkRequest() async {
        let result: Result<EmptyResponse, NetworkError> = await MockPOSTRequestable().fetch()
        switch result {
        case .success(let empty):
            XCTAssertNotNil(empty)
        case .failure(let error):
            XCTFail("Request failed with error: \(error.description)")
        }
    }
}

// MARK: - PUT
extension ActorNetworkTests {
    func testPUTPerformNetworkRequest() async {
        let result: Result<EmptyResponse, NetworkError> = await MockPUTRequestable().perform()
        switch result {
        case .success(let empty):
            XCTAssertNotNil(empty)
        case .failure(let error):
            XCTFail("Request failed with error: \(error.description)")
        }
    }
    
    func testPUTNetworkRequest() async {
        let result: Result<EmptyResponse, NetworkError> = await MockPUTRequestable().update()
        switch result {
        case .success(let empty):
            XCTAssertNotNil(empty)
        case .failure(let error):
            XCTFail("Request failed with error: \(error.description)")
        }
    }
}

// MARK: - DELETE
extension ActorNetworkTests {
    func testDELETEPerformNetworkRequest() async {
        let result: Result<EmptyResponse, NetworkError> = await MockDELETERequestable().perform()
        switch result {
        case .success(let empty):
            XCTAssertNotNil(empty)
        case .failure(let error):
            XCTFail("Request failed with error: \(error.description)")
        }
    }
    
    func testDELETENetworkRequest() async {
        let result: Result<EmptyResponse, NetworkError> = await MockDELETERequestable().delete()
        switch result {
        case .success(let empty):
            XCTAssertNotNil(empty)
        case .failure(let error):
            XCTFail("Request failed with error: \(error.description)")
        }
    }
}
