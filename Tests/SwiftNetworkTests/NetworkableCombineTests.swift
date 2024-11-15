//
//  EndpointTests+BuildURL.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
import Combine
@testable import SwiftNetwork

class CombineNetworkTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
}

// MARK: - GET
extension CombineNetworkTests {
    func testGETPerformNetworkRequest() {
        // Perform the network request with Combine
        MockGETRequestable()
            .perform()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Network request failed with error: \(error.description)")
                case .finished:
                    break
                }
            } receiveValue: { (posts: [Post]) in
                XCTAssertGreaterThan(posts.count, 0, "Expected to receive posts.")
            }
            .store(in: &cancellables)
    }
    
    func testGETNetworkRequest() {
        // Perform the network request with Combine
        MockGETRequestable()
            .fetch()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Network request failed with error: \(error.description)")
                case .finished:
                    break
                }
            } receiveValue: { (posts: [Post]) in
                XCTAssertGreaterThan(posts.count, 0, "Expected to receive posts.")
            }
            .store(in: &cancellables)
    }
}

// MARK: - GET Single Post
extension CombineNetworkTests {
    func testGETSinglePerformNetworkRequest() {
        // Perform the network request with Combine
        MockGETSingleRequestable()
            .perform()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Network request failed with error: \(error.description)")
                case .finished:
                    break
                }
            } receiveValue: { (post: Post) in
                XCTAssertNotNil(post)
            }
            .store(in: &cancellables)
    }
    
    func testGETSingleNetworkRequest() {
        // Perform the network request with Combine
        MockGETSingleRequestable()
            .fetch()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Network request failed with error: \(error.description)")
                case .finished:
                    break
                }
            } receiveValue: { (post: Post) in
                XCTAssertNotNil(post)
            }
            .store(in: &cancellables)
    }
}

// MARK: - POST
extension CombineNetworkTests {
    func testPOSTPerformNetworkRequest() {
        // Perform the network request with Combine
        MockPOSTRequestable()
            .perform()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Network request failed with error: \(error.description)")
                case .finished:
                    break
                }
            } receiveValue: { (empty: EmptyResponse) in
                XCTAssertNotNil(empty)
            }
            .store(in: &cancellables)
    }
    
    func testPOSTNetworkRequest() {
        // Perform the network request with Combine
        MockPOSTRequestable()
            .sync()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Network request failed with error: \(error.description)")
                case .finished:
                    break
                }
            } receiveValue: { (empty: EmptyResponse) in
                XCTAssertNotNil(empty)
            }
            .store(in: &cancellables)
    }
}

// MARK: - PUT
extension CombineNetworkTests {
    func testPUTPerformNetworkRequest() {
        // Perform the network request with Combine
        MockPUTRequestable()
            .perform()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Network request failed with error: \(error.description)")
                case .finished:
                    break
                }
            } receiveValue: { (empty: EmptyResponse) in
                XCTAssertNotNil(empty)
            }
            .store(in: &cancellables)
    }
    
    func testPUTNetworkRequest() {
        // Perform the network request with Combine
        MockPUTRequestable()
            .update()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Network request failed with error: \(error.description)")
                case .finished:
                    break
                }
            } receiveValue: { (empty: EmptyResponse) in
                XCTAssertNotNil(empty)
            }
            .store(in: &cancellables)
    }
}

// MARK: - DELETE
extension CombineNetworkTests {
    func testDELETEPerformNetworkRequest() {
        // Perform the network request with Combine
        MockDELETERequestable()
            .perform()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Network request failed with error: \(error.description)")
                case .finished:
                    break
                }
            } receiveValue: { (empty: EmptyResponse) in
                XCTAssertNotNil(empty)
            }
            .store(in: &cancellables)
    }
    
    func testDELETENetworkRequest() {
        // Perform the network request with Combine
        MockDELETERequestable()
            .delete()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Network request failed with error: \(error.description)")
                case .finished:
                    break
                }
            } receiveValue: { (empty: EmptyResponse) in
                XCTAssertNotNil(empty)
            }
            .store(in: &cancellables)
    }
}
