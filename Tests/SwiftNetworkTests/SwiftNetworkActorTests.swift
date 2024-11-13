//
//  EndpointTests+DefaultHeaders.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

@available(iOS 13.0, macOS 12.0, *)
actor TestActor {
    func performNetworkRequest() async throws -> [Post] {
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
        let result: Result<[Post], NetworkError> = await endpoint.fetch()
        
        switch result {
        case .success(let success): return success
        case .failure: return []
        }
    }
}

class ActorNetworkTests: XCTestCase {
    
    func testAsyncRequestWithActor() async throws {
        let actor = TestActor()
        let posts = try await actor.performNetworkRequest()
        XCTAssertGreaterThan(posts.count, 0, "Expected posts to be returned.")
    }
}
