//
//  SwiftNetworkTests.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class SwiftNetworkTests: XCTestCase {
    fileprivate func build(from mock: Requestable, completion: @escaping (URLRequest) -> Void) {
        switch mock.buildRequest {
        case .success(let request): completion(request)
        case .failure(let error):
            XCTFail("Request failed with error: \(error.description)")
        }
    }
}

// MARK: - GET
extension SwiftNetworkTests {
    func testGETPerformNetworkRequest() {
        build(from: MockGETRequestable()) { request in
            SwiftNetwork()
                .perform(request) { (result: Result<[Post], NetworkError>) in
                    switch result {
                    case .success(let posts):
                        // Assert that the post was deleted
                        XCTAssertGreaterThan(posts.count, 0, "Expected to receive posts.")
                    case .failure(let error):
                        XCTFail("Request failed with error: \(error.description)")
                    }
                }
        }
    }
}

// MARK: - GET Single Post
extension SwiftNetworkTests {
    func testGETSinglePerformNetworkRequest() {
        build(from: MockGETSingleRequestable()) { request in
            SwiftNetwork()
                .perform(request) { (result: Result<Post, NetworkError>) in
                    switch result {
                    case .success(let post):
                        // Assert that the post was deleted
                        XCTAssertNotNil(post)
                    case .failure(let error):
                        XCTFail("Request failed with error: \(error.description)")
                    }
                }
        }
    }
}

// MARK: - POST
extension SwiftNetworkTests {
    func testPOSTPerformNetworkRequest() {
        build(from: MockPOSTRequestable()) { request in
            SwiftNetwork()
                .perform(request) { (result: Result<EmptyResponse, NetworkError>) in
                    switch result {
                    case .success(let empty):
                        // Assert that the post was deleted
                        XCTAssertNotNil(empty)
                    case .failure(let error):
                        XCTFail("Request failed with error: \(error.description)")
                    }
                }
        }
    }
}

// MARK: - PUT
extension SwiftNetworkTests {
    func testPUTPerformNetworkRequest() {
        build(from: MockPUTRequestable()) { request in
            SwiftNetwork()
                .perform(request) { (result: Result<EmptyResponse, NetworkError>) in
                    switch result {
                    case .success(let empty):
                        // Assert that the post was deleted
                        XCTAssertNotNil(empty)
                    case .failure(let error):
                        XCTFail("Request failed with error: \(error.description)")
                    }
                }
        }
    }
}

// MARK: - DELETE
extension SwiftNetworkTests {
    func testDELETEPerformNetworkRequest() {
        build(from: MockDELETERequestable()) { request in
            SwiftNetwork()
                .perform(request) { (result: Result<EmptyResponse, NetworkError>) in
                    switch result {
                    case .success(let empty):
                        // Assert that the post was deleted
                        XCTAssertNotNil(empty)
                    case .failure(let error):
                        XCTFail("Request failed with error: \(error.description)")
                    }
                }
        }
    }
}
