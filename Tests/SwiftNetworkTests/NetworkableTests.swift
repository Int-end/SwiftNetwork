//
//  NetworkableTests.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class NetworkableTests: XCTestCase {
    private let timeout: TimeInterval = 5
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    private func performTest<T: Decodable>(_ mock: Requestable,
                                         expectation: XCTestExpectation,
                                         validateSuccess: @escaping (T) -> Void) {
        mock.perform { (result: Result<T, NetworkError>) in
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
extension NetworkableTests {
    func testGETPerformNetworkRequest() {
        let expectation = expectation(description: "GET request")
        performTest(MockGETRequestable(), expectation: expectation) { (posts: [Post]) in
            XCTAssertGreaterThan(posts.count, 0, "Expected posts to be returned")
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testGETSinglePerformNetworkRequest() {
        let expectation = expectation(description: "GET single request")
        performTest(MockGETSingleRequestable(), expectation: expectation) { (post: Post) in
            XCTAssertNotNil(post)
            XCTAssertEqual(post.id, Mock.TestData.post.id)
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testGETNetworkRequest() {
        let expectation = expectation(description: "GET request")
        performTest(MockGETRequestable(), expectation: expectation) { (posts: [Post]) in
            XCTAssertGreaterThan(posts.count, 0, "Expected posts to be returned")
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testGETSingleNetworkRequest() {
        let expectation = expectation(description: "GET single request")
        performTest(MockGETSingleRequestable(), expectation: expectation) { (post: Post) in
            XCTAssertNotNil(post)
            XCTAssertEqual(post.id, Mock.TestData.post.id)
        }
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: - POST Tests
extension NetworkableTests {
    func testPOSTPerformNetworkRequest() {
        let expectation = expectation(description: "POST request")
        performTest(MockPOSTRequestable(), expectation: expectation) { (_: EmptyResponse) in
            // Success case
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testPOSTNetworkRequest() {
        let expectation = expectation(description: "POST request")
        performTest(MockPOSTRequestable(), expectation: expectation) { (_: EmptyResponse) in
            // Success case
        }
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: - PUT Tests
extension NetworkableTests {
    func testPUTPerformNetworkRequest() {
        let expectation = expectation(description: "PUT request")
        performTest(MockPUTRequestable(), expectation: expectation) { (_: EmptyResponse) in
            // Success case
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testPUTNetworkRequest() {
        let expectation = expectation(description: "PUT request")
        performTest(MockPUTRequestable(), expectation: expectation) { (_: EmptyResponse) in
            // Success case
        }
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: - DELETE Tests
extension NetworkableTests {
    func testDELETEPerformNetworkRequest() {
        let expectation = expectation(description: "DELETE request")
        performTest(MockDELETERequestable(), expectation: expectation) { (_: EmptyResponse) in
            // Success case
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testDELETENetworkRequest() {
        let expectation = expectation(description: "DELETE request")
        performTest(MockDELETERequestable(), expectation: expectation) { (_: EmptyResponse) in
            // Success case
        }
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: - Error Tests
extension NetworkableTests {
    func testInvalidResponseFormat() {
        let expectation = expectation(description: "Invalid response format")
        let mock = MockGETRequestable()
        
        mock.perform { (result: Result<Post, NetworkError>) in
            if case .failure(.decodingError) = result {
                expectation.fulfill()
            } else {
                XCTFail("Expected decodingError but got \(result)")
            }
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}
