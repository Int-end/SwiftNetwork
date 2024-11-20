//
//  NetworkableCombineTests.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
import Combine
@testable import SwiftNetwork

@available(iOS 13.0, macOS 10.15, *)
class NetworkableCombineTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private let timeout: TimeInterval = 5
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
        try super.tearDownWithError()
    }
    
    private func performTest<T: Decodable>(_ mock: Requestable,
                                         expectation: XCTestExpectation,
                                         validateSuccess: @escaping (T) -> Void) {
        mock.perform()
            .sink(receiveCompletion: handleCompletion(expectation),
                 receiveValue: validateSuccess)
            .store(in: &cancellables)
    }
}

// MARK: - GET Tests
@available(iOS 13.0, macOS 10.15, *)
extension NetworkableCombineTests {
    func testGETPerformNetworkRequest() {
        let expectation = expectation(description: "GET request")
        performTest(MockGETRequestable(), expectation: expectation) { (posts: [Post]) in
            XCTAssertGreaterThan(posts.count, 0, "Expected posts to be returned")
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
    
    func testGETSinglePerformNetworkRequest() {
        let expectation = expectation(description: "GET single request")
        performTest(MockGETSingleRequestable(), expectation: expectation) { (post: Post) in
            XCTAssertNotNil(post)
            XCTAssertEqual(post.id, Mock.TestData.post.id)
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
@available(iOS 13.0, macOS 10.15, *)
extension NetworkableCombineTests {
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
@available(iOS 13.0, macOS 10.15, *)
extension NetworkableCombineTests {
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
@available(iOS 13.0, macOS 10.15, *)
extension NetworkableCombineTests {
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
@available(iOS 13.0, macOS 10.15, *)
extension NetworkableCombineTests {
    func testInvalidResponseFormat() {
        let expectation = expectation(description: "Invalid response format")
        let mock = MockGETRequestable()
        
        mock.perform()
            .sink { completion in
                if case .failure(.decodingError) = completion {
                    expectation.fulfill()
                }
            } receiveValue: { (post: Post) in
                XCTFail("Expected error but got success")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: - Helpers
@available(iOS 13.0, macOS 10.15, *)
private extension NetworkableCombineTests {
    func handleCompletion(_ expectation: XCTestExpectation) -> ((Subscribers.Completion<NetworkError>) -> Void) {
        return { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }
    }
}
