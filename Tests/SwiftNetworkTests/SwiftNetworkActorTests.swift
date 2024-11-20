//
//  SwiftNetworkActorTests.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

@available(iOS 13.0, macOS 10.15, *)
class SwiftNetworkActorTests: XCTestCase {
    private var actor: SwiftNetworkActor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        actor = SwiftNetworkActor()
    }
    
    override func tearDownWithError() throws {
        actor = nil
        try super.tearDownWithError()
    }
    
    private func performTest<T: Decodable>(_ mock: Endpoint,
                                         validateSuccess: @escaping (T) -> Void) async {
        guard let request = mock.request else {
            XCTFail("Failed to create request")
            return
        }
        
        let result: Result<T, NetworkError> = await actor.perform(request)
        switch result {
        case .success(let value):
            validateSuccess(value)
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
}

// MARK: - GET Tests
@available(iOS 13.0, macOS 10.15, *)
extension SwiftNetworkActorTests {
    func testGETPerformNetworkRequest() async {
        await performTest(MockGETEndpoint()) { (posts: [Post]) in
            XCTAssertGreaterThan(posts.count, 0, "Expected posts to be returned")
        }
    }
    
    func testGETSinglePerformNetworkRequest() async {
        await performTest(MockGETSingleEndpoint()) { (post: Post) in
            XCTAssertNotNil(post)
            XCTAssertEqual(post.id, 1)
        }
    }
}

// MARK: - POST Tests
@available(iOS 13.0, macOS 10.15, *)
extension SwiftNetworkActorTests {
    func testPOSTPerformNetworkRequest() async {
        await performTest(MockPOSTEndpoint()) { (_: EmptyResponse) in
            // Success case
        }
    }
}

// MARK: - PUT Tests
@available(iOS 13.0, macOS 10.15, *)
extension SwiftNetworkActorTests {
    func testPUTPerformNetworkRequest() async {
        await performTest(MockPUTEndpoint()) { (_: EmptyResponse) in
            // Success case
        }
    }
}

// MARK: - DELETE Tests
@available(iOS 13.0, macOS 10.15, *)
extension SwiftNetworkActorTests {
    func testDELETEPerformNetworkRequest() async {
        await performTest(MockDELETEEndpoint()) { (_: EmptyResponse) in
            // Success case
        }
    }
}

// MARK: - Error Tests
@available(iOS 13.0, macOS 10.15, *)
extension SwiftNetworkActorTests {
    func testInvalidResponseFormat() async {
        let mock = MockGETEndpoint()
        
        guard let request = mock.request else {
            XCTFail("Failed to create request")
            return
        }
        
        let result: Result<Post, NetworkError> = await actor.perform(request)
        if case .failure(.decodingError) = result {
            // Expected error
            return
        } else {
            XCTFail("Expected decodingError but got \(result)")
        }
    }
}
