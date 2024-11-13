import XCTest
@testable import SwiftNetwork

class NetworkableTests: XCTestCase {

    func testNetworkable() {
        // Setup environment with base URL (JSONPlaceholder)
        let environment = Environment(baseURL: "https://jsonplaceholder.typicode.com", apiKey: "")

        // Define the endpoint for deleting a post
        struct DeletePostEndpoint: Networkable {
            var path: String = "/posts/1"  // Post ID = 1
            var method: HTTPMethod = .DELETE
            var parameters: [String: QueryStringConvertible]? = nil
            var environment: EnvironmentConfigurable

            init(environment: EnvironmentConfigurable) {
                self.environment = environment
            }
        }

        let deletePostEndpoint = DeletePostEndpoint(environment: environment)

        // Perform the request
        deletePostEndpoint.delete { (result: Result<EmptyResponse, NetworkError>) in
            switch result {
            case .success:
                // Assert that the post was deleted
                XCTAssertTrue(true, "Post deleted successfully.")
            case .failure(let error):
                XCTFail("Request failed with error: \(error.description)")
            }
        }
    }
}

struct EmptyResponse: Decodable {}
