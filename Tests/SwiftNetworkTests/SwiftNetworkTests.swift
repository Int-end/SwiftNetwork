//
//  SwiftNetworkTests.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class SwiftNetworkTests: XCTestCase {
    private var network: SwiftNetwork!
    private let timeout: TimeInterval = 5
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        network = SwiftNetwork()
    }
    
    override func tearDownWithError() throws {
        network = nil
        try super.tearDownWithError()
    }
    
    private func performTest<T: Decodable>(_ mock: Endpoint,
                                         expectation: XCTestExpectation,
                                         validateSuccess: @escaping (T) -> Void) {
        guard let request = mock.request else {
            XCTFail("Failed to create request")
            return
        }
        
        network.perform(request) { (result: Result<T, NetworkError>) in
            switch result {
            case .success(let value):
                validateSuccess(value)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }
    }
}

// MARK: - GET Tests
extension SwiftNetworkTests {
    func testGETPerformNetworkRequest() {
        let expectation = expectation(description: "GET request")
        performTest(MockGETEndpoint(), expectation: expectation) { (posts: [Post]) in
            XCTAssertGreaterThan(posts.count, 0, "Expected posts to be returned")
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testGETSinglePerformNetworkRequest() {
        let expectation = expectation(description: "GET single request")
        performTest(MockGETSingleEndpoint(), expectation: expectation) { (post: Post) in
            XCTAssertNotNil(post)
            XCTAssertEqual(post.id, 1)
        }
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: - POST Tests
extension SwiftNetworkTests {
    func testPOSTPerformNetworkRequest() {
        let expectation = expectation(description: "POST request")
        performTest(MockPOSTEndpoint(), expectation: expectation) { (_: EmptyResponse) in
            // Success case
        }
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: - PUT Tests
extension SwiftNetworkTests {
    func testPUTPerformNetworkRequest() {
        let expectation = expectation(description: "PUT request")
        performTest(MockPUTEndpoint(), expectation: expectation) { (_: EmptyResponse) in
            // Success case
        }
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: - DELETE Tests
extension SwiftNetworkTests {
    func testDELETEPerformNetworkRequest() {
        let expectation = expectation(description: "DELETE request")
        performTest(MockDELETEEndpoint(), expectation: expectation) { (_: EmptyResponse) in
            // Success case
        }
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: - Error Tests
extension SwiftNetworkTests {
    func testInvalidResponseFormat() {
        let expectation = expectation(description: "Invalid response format")
        let mock = MockGETEndpoint()
        
        guard let request = mock.request else {
            XCTFail("Failed to create request")
            return
        }
        
        network.perform(request) { (result: Result<Post, NetworkError>) in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                if case .decodingError = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected decodingError but got \(error)")
                }
            }
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}
