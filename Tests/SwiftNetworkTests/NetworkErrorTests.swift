//
//  Endpoint+FailureResponse+NetworkFailure.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class NetworkErrorTests: XCTestCase {
    
    // Test handling of network failure
    func testNetworkFailure() {
        let error = NetworkError.networkFailure(NSError(domain: "TestDomain", code: 500, userInfo: nil))
        
        switch error {
        case .networkFailure(let underlyingError):
            XCTAssertEqual((underlyingError as NSError).domain, "TestDomain")
            XCTAssertEqual((underlyingError as NSError).code, 500)
        default:
            XCTFail("Expected network failure error")
        }
    }
    
    // Test invalid request body error
    func testInvalidRequestBody() {
        let error = NetworkError.invalidRequestBody
        switch error {
        case .invalidRequestBody:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected invalid request body error")
        }
    }
    
    // Test decoding error
    func testDecodingError() {
        let underlyingError = NSError(domain: "TestDecoding", code: 1, userInfo: nil)
        let error = NetworkError.decodingError(underlyingError)
        
        switch error {
        case .decodingError(let decodingError):
            XCTAssertEqual((decodingError as NSError).domain, "TestDecoding")
        default:
            XCTFail("Expected decoding error")
        }
    }
}

