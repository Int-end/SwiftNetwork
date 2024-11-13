//
//  Endpoint+FailureResponse+NetworkFailure.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class NetworkErrorTests: XCTestCase {
    
    func testNetworkFailure() {
        let error = NSError(domain: "TestError", code: -1, userInfo: nil)
        let networkError = NetworkError.networkFailure(error)
        
        switch networkError {
        case .networkFailure(let error):
            XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (TestError error -1.)", "The network failure error description is incorrect.")
        default:
            XCTFail("Expected networkFailure error, but got: \(networkError)")
        }
    }
    
    func testDecodingError() {
        let error = NSError(domain: "TestDecodingError", code: -1, userInfo: nil)
        let networkError = NetworkError.decodingError(error)
        
        switch networkError {
        case .decodingError(let error):
            XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (TestDecodingError error -1.)", "The decoding error description is incorrect.")
        default:
            XCTFail("Expected decodingError, but got: \(networkError)")
        }
    }
    
    func testNoDataError() {
        let networkError = NetworkError.noData
        
        switch networkError {
        case .noData:
            XCTAssertTrue(true, "The noData error was correctly thrown.")
        default:
            XCTFail("Expected noData error, but got: \(networkError)")
        }
    }
}

