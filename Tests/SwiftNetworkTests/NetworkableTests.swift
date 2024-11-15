import XCTest
@testable import SwiftNetwork

class NetworkableTests: XCTestCase {}

// MARK: - GET
extension NetworkableTests {
    func testGETPerformNetworkRequest() {
        MockGETRequestable()
            .perform { (result: Result<[Post], NetworkError>) in
                switch result {
                case .success(let posts):
                    // Assert that the post was deleted
                    XCTAssertGreaterThan(posts.count, 0, "Expected to receive posts.")
                case .failure(let error):
                    XCTFail("Request failed with error: \(error.description)")
                }
            }
    }
    
    func testGETNetworkRequest() {
        MockGETRequestable()
            .fetch { (result: Result<[Post], NetworkError>) in
                switch result {
                case .success(let posts):
                    // Assert that the post was deleted
                    XCTAssertGreaterThan(posts.count, 0, "Expected to receive posts.")
                case .failure(let error):
                    XCTFail("Request failed with error: \(error.description)")
                }
            }
    }
}

// MARK: - GET Single Post
extension NetworkableTests {
    func testGETSinglePerformNetworkRequest() {
        MockGETSingleRequestable()
            .perform { (result: Result<Post, NetworkError>) in
                switch result {
                case .success(let post):
                    // Assert that the post was deleted
                    XCTAssertNotNil(post)
                case .failure(let error):
                    XCTFail("Request failed with error: \(error.description)")
                }
            }
    }
    
    func testGETSingleNetworkRequest() {
        MockGETSingleRequestable()
            .fetch { (result: Result<Post, NetworkError>) in
                switch result {
                case .success(let post):
                    // Assert that the post was deleted
                    XCTAssertNotNil(post)
                case .failure(let error):
                    XCTFail("Request failed with error: \(error.description)")
                }
            }
    }
}

// MARK: - POST
extension NetworkableTests {
    func testPOSTPerformNetworkRequest() {
        MockPOSTRequestable()
            .perform { (result: Result<EmptyResponse, NetworkError>) in
                switch result {
                case .success(let empty):
                    // Assert that the post was deleted
                    XCTAssertNotNil(empty)
                case .failure(let error):
                    XCTFail("Request failed with error: \(error.description)")
                }
            }
    }
    
    func testPOSTNetworkRequest() {
        MockPOSTRequestable()
            .sync { (result: Result<EmptyResponse, NetworkError>) in
                switch result {
                case .success(let empty):
                    // Assert that the post was deleted
                    XCTAssertNotNil(empty)
                case .failure(let error):
                    XCTFail("Request failed with error: \(error.description)")
                }
            }
    }
}

// MARK: - PUT
extension NetworkableTests {
    func testPUTPerformNetworkRequest() {
        MockPUTRequestable()
            .perform { (result: Result<EmptyResponse, NetworkError>) in
                switch result {
                case .success(let empty):
                    // Assert that the post was deleted
                    XCTAssertNotNil(empty)
                case .failure(let error):
                    XCTFail("Request failed with error: \(error.description)")
                }
            }
    }
    
    func testPUTNetworkRequest() {
        MockPUTRequestable()
            .update { (result: Result<EmptyResponse, NetworkError>) in
                switch result {
                case .success(let empty):
                    // Assert that the post was deleted
                    XCTAssertNotNil(empty)
                case .failure(let error):
                    XCTFail("Request failed with error: \(error.description)")
                }
            }
    }
}


// MARK: - DELETE
extension NetworkableTests {
    func testDELETEPerformNetworkRequest() {
        MockDELETERequestable()
            .perform { (result: Result<EmptyResponse, NetworkError>) in
                switch result {
                case .success(let empty):
                    // Assert that the post was deleted
                    XCTAssertNotNil(empty)
                case .failure(let error):
                    XCTFail("Request failed with error: \(error.description)")
                }
            }
    }
    
    func testDELETENetworkRequest() {
        MockDELETERequestable()
            .delete() { (result: Result<EmptyResponse, NetworkError>) in
                switch result {
                case .success(let empty):
                    // Assert that the post was deleted
                    XCTAssertNotNil(empty)
                case .failure(let error):
                    XCTFail("Request failed with error: \(error.description)")
                }
            }
    }
}

enum Mock {
    // Setup base URL (JSONPlaceholder)
    static let baseURL = "https://jsonplaceholder.typicode.com"
    
    // Setup environment with base URL (JSONPlaceholder)
    static let environment = TestEnvironment(environment: .init(baseURL: baseURL, apiKey: "API KEY"))
    
    enum Path {
        static let posts = "/posts"
        static let singlePost = "/posts/1"
    }
}

// Define a custom environment with a base URL
struct TestEnvironment: EnvironmentConfigurable {
    let baseURL: String
    let apiKey: String
    
    init(environment: Environment) {
        self.baseURL = environment.baseURL
        self.apiKey = environment.apiKey
    }
}

// Sample Post Model for Decoding (POST request test)
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct EmptyResponse: Decodable {}

class MockGETRequestable: MockGETNetworkable, Requestable {}

class MockGETSingleRequestable: MockGETSingleNetworkable, Requestable {}

class MockPOSTRequestable: MockPOSTNetworkable, Requestable {}

class MockPUTRequestable: MockPUTNetworkable, Requestable {}

class MockDELETERequestable: MockDELETENetworkable,Requestable {}


class MockGETNetworkable: MockGETEndpoint, Networkable {}

class MockGETSingleNetworkable: MockGETSingleEndpoint, Networkable {}

class MockPOSTNetworkable: MockPOSTEndpoint, Networkable {}

class MockPUTNetworkable: MockPUTEndpoint, Networkable {}

class MockDELETENetworkable: MockDELETEEndpoint,Networkable {}
