//
//  EndpointTests.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class EndpointTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
}

// MARK: - GET Tests
extension EndpointTests {
    func testGETEndpoint() {
        let mock = MockGETEndpoint()
        
        XCTAssertEqual(mock.method, .GET)
        XCTAssertEqual(mock.path, Mock.Path.posts)
        XCTAssertNotNil(mock.request)
    }
    
    func testGETSingleEndpoint() {
        let mock = MockGETSingleEndpoint()
        
        XCTAssertEqual(mock.method, .GET)
        XCTAssertEqual(mock.path, Mock.Path.singlePost)
        XCTAssertNotNil(mock.request)
    }
}

// MARK: - POST Tests
extension EndpointTests {
    func testPOSTEndpoint() {
        let mock = MockPOSTEndpoint()
        
        XCTAssertEqual(mock.method, .POST)
        XCTAssertEqual(mock.path, Mock.Path.posts)
        XCTAssertNotNil(mock.request)
    }
}

// MARK: - PUT Tests
extension EndpointTests {
    func testPUTEndpoint() {
        let mock = MockPUTEndpoint()
        
        XCTAssertEqual(mock.method, .PUT)
        XCTAssertEqual(mock.path, Mock.Path.singlePost)
        XCTAssertNotNil(mock.request)
    }
}

// MARK: - DELETE Tests
extension EndpointTests {
    func testDELETEEndpoint() {
        let mock = MockDELETEEndpoint()
        
        XCTAssertEqual(mock.method, .DELETE)
        XCTAssertEqual(mock.path, Mock.Path.singlePost)
        XCTAssertNotNil(mock.request)
    }
}
