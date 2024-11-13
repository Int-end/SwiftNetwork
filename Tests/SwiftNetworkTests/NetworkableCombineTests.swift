//
//  EndpointTests+BuildURL.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
import Combine
@testable import SwiftNetwork

class NetworkableCombineTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    func testCombineRequestSuccess() {
        // Create a mock endpoint
        struct MockEndpoint: Networkable {
            var path: String = "/test"
            var method: HTTPMethod = .GET
            var headers: [String: String]? = nil
            var parameters: [String: QueryStringConvertible]? = nil
            var environment: EnvironmentConfigurable = EndpointTests.MockEnvironment()
            var request: URLRequest? = nil
        }
        
        let endpoint = MockEndpoint()
        
        guard case let .success(request) = endpoint.buildRequest else {
            XCTFail("BuildiRequest Failed.")
            return
        }
        
        let publisher: Future<MockResponse, NetworkError> = SwiftNetwork()
            .perform(request)
        
        publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Request failed with error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                XCTAssertEqual(response.key, "value")
            })
            .store(in: &cancellables)
    }
    
    func testCombineRequestFailure() {
        // Create a mock invalid endpoint
        struct MockInvalidEndpoint: Networkable {
            var path: String = "/invalid"
            var method: HTTPMethod = .GET
            var headers: [String: String]? = nil
            var parameters: [String: QueryStringConvertible]? = nil
            var environment: EnvironmentConfigurable = EndpointTests.MockEnvironment()
            var request: URLRequest? = nil
        }
        
        let endpoint = MockInvalidEndpoint()
        
        guard case let .success(request) = endpoint.buildRequest else {
            XCTFail("BuildiRequest Failed.")
            return
        }
        
        let publisher: Future<MockResponse, NetworkError> = SwiftNetwork()
            .perform(request)
        
        publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertNotNil(error)
                case .finished:
                    break
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got success.")
            })
            .store(in: &cancellables)
    }
}
