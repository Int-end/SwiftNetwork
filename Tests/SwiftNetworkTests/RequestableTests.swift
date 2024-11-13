//
//  Endpoint+PerformRequest.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class RequestableTests: XCTestCase {
    
    // Example of a requestable endpoint
    struct MockRequestable: Requestable {
        var path: String = "/user"
        var method: HTTPMethod = .GET
        var headers: [String: String]? = ["Authorization": "Bearer token"]
        var parameters: [String: QueryStringConvertible]? = nil
        var environment: EnvironmentConfigurable = EndpointTests.MockEnvironment()
        var request: URLRequest? = nil
    }
    
    func testRequestableRequest() {
        let requestable = MockRequestable()
        let buildRequest = requestable.buildRequest
        switch buildRequest {
        case .success(let request):
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer token")
        case .failure(let error):
            XCTFail("Expected success, but got error: \(error)")
        }
    }
}

struct MockResponse: Decodable {
    let key: String
}

