//
//  EndpointTests+DefaultHeaders.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

@available(iOS 13.0, *)
class SwiftNetworkActorTests: XCTestCase {
    
    var actor: SwiftNetworkActor!
    
    override func setUp() {
        super.setUp()
        actor = SwiftNetworkActor()
    }
    
    // Test successful network request with actor
    func testActorNetworkRequestSuccess() async {
        // Create a mock URLRequest
        let url = URL(string: "https://api.example.com/test")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Mock URLSession response (Replace with actual mock or stub in real testing)
        let result: Result<MockResponse, NetworkError> = await actor.perform(request)
        
        switch result {
        case .success(let decodedResponse):
            XCTAssertEqual(decodedResponse.key, "value")
        case .failure(let error):
            XCTFail("Expected success, but got error: \(error)")
        }
    }
    
    // Test network request failure in actor
    func testActorNetworkRequestFailure() async {
        // Create a mock invalid URLRequest
        let url = URL(string: "https://invalid_url")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let result: Result<MockResponse, NetworkError> = await actor.perform(request)
        
        switch result {
        case .success(_):
            XCTFail("Expected failure, but got success.")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
}
