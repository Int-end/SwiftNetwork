//
//  Endpoint+PerformRequest.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class RequestableTests: XCTestCase {
    
    func testGetRequest() {
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
        
        // Simulate a successful GET request
        endpoint.fetch { (result: Result<[Post], NetworkError>) in
            switch result {
            case .success(let posts):
                XCTAssertTrue(posts.count > 0, "Expected posts but got empty array.")
            case .failure(let error):
                XCTFail("GET request failed with error: \(error.description)")
            }
        }
    }
    
    func testPostRequest() {
        let environment = Environment(baseURL: "https://jsonplaceholder.typicode.com", apiKey: "")
        
        struct CreatePostEndpoint: Requestable {
            var path: String = "/posts"
            var method: HTTPMethod = .POST
            var parameters: [String: QueryStringConvertible]? = ["title": "New Post", "body": "This is a new post.", "userId": 1]
            var environment: EnvironmentConfigurable
            
            init(environment: EnvironmentConfigurable) {
                self.environment = environment
            }
        }
        
        let endpoint = CreatePostEndpoint(environment: environment)
        
        // Simulate a successful POST request
        endpoint.sync { (result: Result<Post, NetworkError>) in
            switch result {
            case .success(let post):
                XCTAssertEqual(post.title, "New Post", "The post title is incorrect.")
            case .failure(let error):
                XCTFail("POST request failed with error: \(error.description)")
            }
        }
    }
    
    func testDeleteRequest() {
        let environment = Environment(baseURL: "https://jsonplaceholder.typicode.com", apiKey: "")
        
        struct DeletePostEndpoint: Requestable {
            var path: String = "/posts/1"
            var method: HTTPMethod = .DELETE
            var parameters: [String: QueryStringConvertible]? = nil
            var environment: EnvironmentConfigurable
            
            init(environment: EnvironmentConfigurable) {
                self.environment = environment
            }
        }
        
        let endpoint = DeletePostEndpoint(environment: environment)
        
        // Simulate a successful DELETE request
        endpoint.delete { (result: Result<EmptyResponse, NetworkError>) in
            switch result {
            case .success:
                XCTAssertTrue(true, "Post deleted successfully.")
            case .failure(let error):
                XCTFail("DELETE request failed with error: \(error.description)")
            }
        }
    }
}
