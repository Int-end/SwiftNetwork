//
//  QueryStringConvertibleTests.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

class QueryStringConvertibleTests: XCTestCase {

    func testQueryStringConvertible() {
        // Test conversion of different types to query strings
        let intQuery: QueryStringConvertible = 42
        let stringQuery: QueryStringConvertible = "Hello"
        let boolQuery: QueryStringConvertible = true

        XCTAssertEqual(intQuery.toString(), "42")
        XCTAssertEqual(stringQuery.toString(), "Hello")
        XCTAssertEqual(boolQuery.toString(), "true")
    }
}
