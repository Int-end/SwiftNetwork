//
//  TestUtilities.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import XCTest
@testable import SwiftNetwork

// MARK: - Mock Data
enum Mock {
    static let baseURL = "https://jsonplaceholder.typicode.com"
    static let environment = TestEnvironment(environment: .init(baseURL: baseURL, apiKey: "API KEY"))
    
    enum Path {
        static let posts = "/posts"
        static let singlePost = "/posts/1"
        static let invalidPath = "/invalid"
    }
    
    enum TestData {
        static let post = Post(userId: 1, id: 1, title: "Test Post", body: "Test Body")
        static let posts = [post]
        static let invalidJSON = "invalid json".data(using: .utf8)!
        
        static let postParameters: [String: QueryStringConvertible] = [
            "userId": 1,
            "id": 1,
            "title": "Test Post",
            "body": "Test Body"
        ]
        
        static let invalidParameters: [String: Any] = [
            "invalid": Date() // Non-QueryStringConvertible type
        ]
    }
    
    enum Error {
        static let network = NSError(domain: "TestError", code: -1, userInfo: nil)
        static let decoding = NSError(domain: "TestDecodingError", code: -1, userInfo: nil)
        static let timeout = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: nil)
        static let invalidResponse = NSError(domain: "Invalid Response", code: -2, userInfo: nil)
        static let noInternet = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        static let cancelled = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
    }
    
    enum StatusCode {
        static let success = 200
        static let created = 201
        static let badRequest = 400
        static let unauthorized = 401
        static let notFound = 404
        static let serverError = 500
    }
    
    enum Header {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
        static let accept = "Accept"
        
        static let jsonValue = "application/json"
        static let formValue = "application/x-www-form-urlencoded"
    }
}

// MARK: - Test Models
struct TestEnvironment: EnvironmentConfigurable {
    let baseURL: String
    let apiKey: String
    
    init(environment: Environment) {
        self.baseURL = environment.baseURL
        self.apiKey = environment.apiKey
    }
}

struct Post: Codable, Equatable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct EmptyResponse: Decodable {}

// MARK: - Test Helpers
extension XCTestCase {
    func expectSuccess<T: Equatable>(_ result: Result<T, NetworkError>, 
                                   expectedValue: T, 
                                   file: StaticString = #file, 
                                   line: UInt = #line) {
        switch result {
        case .success(let value):
            XCTAssertEqual(value, expectedValue, file: file, line: line)
        case .failure(let error):
            XCTFail("Expected success with \(expectedValue) but got error: \(error)", file: file, line: line)
        }
    }
    
    func expectFailure<T>(_ result: Result<T, NetworkError>, 
                         expectedError: NetworkError, 
                         file: StaticString = #file, 
                         line: UInt = #line) {
        switch result {
        case .success(let value):
            XCTFail("Expected \(expectedError) but got success with: \(value)", file: file, line: line)
        case .failure(let error):
            XCTAssertEqual(error.description, expectedError.description, file: file, line: line)
        }
    }
    
    func expectErrorType<T>(_ result: Result<T, NetworkError>, 
                          errorType: NetworkError.Type, 
                          file: StaticString = #file, 
                          line: UInt = #line) {
        switch result {
        case .success(let value):
            XCTFail("Expected error of type \(errorType) but got success with: \(value)", file: file, line: line)
        case .failure(let error):
            XCTAssertTrue(type(of: error) == errorType, "Expected error of type \(errorType) but got \(type(of: error))", file: file, line: line)
        }
    }
    
    func validateRequest(_ request: URLRequest?,
                        method: HTTPMethod,
                        path: String,
                        headers: [String: String]? = nil,
                        file: StaticString = #file,
                        line: UInt = #line) {
        guard let request = request else {
            XCTFail("Request should not be nil", file: file, line: line)
            return
        }
        
        XCTAssertEqual(request.httpMethod, method.rawValue, file: file, line: line)
        XCTAssertEqual(request.url?.path, path, file: file, line: line)
        
        headers?.forEach { key, value in
            XCTAssertEqual(request.value(forHTTPHeaderField: key), value, file: file, line: line)
        }
    }
}

// MARK: - Mock Response Helpers
extension URLResponse {
    static func mockHTTP(url: URL = URL(string: Mock.baseURL)!, 
                        statusCode: Int = Mock.StatusCode.success,
                        headers: [String: String]? = nil) -> HTTPURLResponse {
        return HTTPURLResponse(url: url,
                             statusCode: statusCode,
                             httpVersion: nil,
                             headerFields: headers)!
    }
}

// MARK: - Mock Data Helpers
extension Data {
    static func mockJSON<T: Encodable>(_ value: T) throws -> Data {
        return try JSONEncoder().encode(value)
    }
} 