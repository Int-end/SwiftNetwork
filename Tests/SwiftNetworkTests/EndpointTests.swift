//
//  EndpointTests.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class EndpointTests: XCTestCase {
    
    func testValidRequestURL() {
        let environment = Environment(baseURL: "https://jsonplaceholder.typicode.com", apiKey: "")
        
        struct PostsEndpoint: Endpoint {
            var path: String = "/posts"
            var method: HTTPMethod = .GET
            var parameters: [String: QueryStringConvertible]? = nil
            var environment: EnvironmentConfigurable
            
            init(environment: EnvironmentConfigurable) {
                self.environment = environment
            }
        }
        
        let endpoint = PostsEndpoint(environment: environment)
        let url = endpoint.url
        
        XCTAssertEqual(url?.absoluteString, "https://jsonplaceholder.typicode.com/posts", "The URL is incorrectly formed.")
    }
    
    func testRequestWithParameters() {
        let environment = Environment(baseURL: "https://jsonplaceholder.typicode.com", apiKey: "")
        
        struct PostsEndpointWithParams: Endpoint {
            var path: String = "/posts"
            var method: HTTPMethod = .GET
            var parameters: [String: QueryStringConvertible]? = ["userId": 1]
            var environment: EnvironmentConfigurable
            
            init(environment: EnvironmentConfigurable) {
                self.environment = environment
            }
        }
        
        let endpoint = PostsEndpointWithParams(environment: environment)
        let url = endpoint.url
        
        XCTAssertEqual(url?.absoluteString, "https://jsonplaceholder.typicode.com/posts?userId=1", "The URL with parameters is incorrectly formed.")
    }
}

// Sample Post Model for Decoding (POST request test)
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
