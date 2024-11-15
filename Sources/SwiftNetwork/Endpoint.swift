//
//  Endpoint.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// A protocol for defining network endpoints that can perform network requests.
///
/// Conform to this protocol to create custom endpoints with the necessary HTTP method, path, headers, and body parameters.
///
/// Example usage:
/// ```Swift
/// struct SignInEndpoint: Requestable {
///     let path: String = "/auth/signin"
///     let method: HTTPMethod = .POST
///     let parameters: [String: QueryStringConvertible]?
///     let environment: EnvironmentConfigurable
///
///     init(environment: EnvironmentConfigurable, body parameters: [String: QueryStringConvertible]) {
///         self.parameters = parameters
///         self.environment = environment
///     }
/// }
/// ```
public protocol Endpoint {
    /// The path of the API endpoint, typically appended to the base URL to form the full URL.
    var path: String { get }

    /// The HTTP method to be used for the request (e.g., GET, POST, PUT, DELETE).
    var method: HTTPMethod { get }

    /// The headers to be included in the request. Defaults to nil, which means default headers are used.
    var headers: [String: String] { get }

    /// The body parameters to be included in the request, if applicable. Defaults to nil.
    var parameters: [String: QueryStringConvertible]? { get }

    /// The environment configuration, including base URL and API key.
    var environment: EnvironmentConfigurable { get }

    /// The URLRequest
    ///
    /// - Warning: If the request has a value, other Endpoint items will not be used. The request will be performed directly.
    var request: URLRequest? { get }
}

public extension Endpoint {
    /// Default method for GET requests.
    var method: HTTPMethod { .GET }

    /// Default headers are nil, which will be merged with custom headers if provided.
    var headers: [String: String] { defaultHeaders }

    /// Default parameters are nil.
    var parameters: [String: QueryStringConvertible]? { nil }

    /// Default value for request is nil.
    var request: URLRequest? {
        guard case let .success(request) = buildRequest else { return nil }
        return request
    }
    
    /// Constructs URL components based on the endpoint's base URL and the path.
    var components: URLComponents? {
        var components = URLComponents(string: environment.baseURL)
        components?.path += path
        
        if let parameters = parameters, method == .GET {
            components?.queryItems = parameters.compactMap { key, value in
                guard let value = value.toString() else { return nil }
                return URLQueryItem(name: key, value: value)
            }
        }
        
        return components
    }
    
    /// Constructs the full URL from base URL and the endpoint's path.
    ///
    /// - Returns: The complete URL for the endpoint, or `nil` if the URL is invalid.
    var url: URL? {
        components?.url
    }
    
    /// Provides default headers for the request, including the `Authorization` header if an API key is available.
    ///
    /// - Returns: A dictionary of headers to be included in the request.
    var defaultHeaders: [String: String] {
        var defaultHeaders = [String: String]()
        if !environment.apiKey.isEmpty {
            defaultHeaders["Authorization"] = "Bearer \(environment.apiKey)"
        }
        return defaultHeaders
    }

    /// Constructs the `URLRequest` to be performed.
    ///
    /// - Returns: A `Result` containing either a `URLRequest` or a `NetworkError` indicating failure.
    var buildRequest: Result<URLRequest, NetworkError> {
        guard let url = url else {
            // Return an error if the URL is invalid
            return .failure(.networkFailure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = defaultHeaders.merging(headers) { (_, new) in new }
        
        if let parameters = parameters, (method == .POST || method == .PUT) {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        // Check if the httpBody is nil if the HTTP Method is POST OR PUT, skip early.
        if method == .POST || method == .PUT {
            if request.httpBody == nil {
                return .failure(.invalidRequestBody)
            }
        }
        
        return .success(request)
    }
}
