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
    
    func testFetchPostsWithCombine() {
        let environment = Environment(baseURL: "https://jsonplaceholder.typicode.com", apiKey: "")
        
        struct GetPostsEndpoint: Requestable {
            var path: String = "/posts"
            var method: HTTPMethod = .GET
            var parameters: [String: QueryStringConvertible]? = nil
            var environment: EnvironmentConfigurable
            
            init(environment: EnvironmentConfigurable) {
                self.environment = environment
            }
        }
        
        let endpoint = GetPostsEndpoint(environment: environment)
        
        // Perform the network request with Combine
        endpoint.fetch()
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
