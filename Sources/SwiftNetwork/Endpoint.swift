//
//  Endpoint.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// A protocol for defining network endpoints.
///
/// Provides a type-safe way to define API endpoints with their associated
/// HTTP methods, paths, headers, and parameters.
///
/// ## Example
/// ```swift
/// struct UserEndpoint: Endpoint {
///     // Required
///     let path = "/users"
///     let environment: EnvironmentConfigurable
///     
///     // Optional with custom implementation
///     let method: HTTPMethod = .GET
///     
///     var parameters: [String: QueryStringConvertible]? {
///         [
///             "page": page,
///             "limit": limit,
///             "sort": sortOrder
///         ]
///     }
///     
///     private let page: Int
///     private let limit: Int
///     private let sortOrder: String
///     
///     init(environment: EnvironmentConfigurable,
///          page: Int = 1,
///          limit: Int = 20,
///          sortOrder: String = "desc") {
///         self.environment = environment
///         self.page = page
///         self.limit = limit
///         self.sortOrder = sortOrder
///     }
/// }
/// ```
public protocol Endpoint {
    // MARK: - Required
    var path: String { get }
    var environment: EnvironmentConfigurable { get }
    
    // MARK: - Optional
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: QueryStringConvertible]? { get }
    var request: URLRequest? { get }
}

// MARK: - Default Implementation
public extension Endpoint {
    var method: HTTPMethod { .GET }
    var headers: [String: String] { defaultHeaders }
    var parameters: [String: QueryStringConvertible]? { nil }
    var request: URLRequest? { try? makeRequest() }
}

// MARK: - Private Helpers
private extension Endpoint {
    var defaultHeaders: [String: String] {
        var headers = ["Content-Type": "application/json"]
        if !environment.apiKey.isEmpty {
            headers["Authorization"] = "Bearer \(environment.apiKey)"
        }
        return headers
    }
    
    var components: URLComponents? {
        var components = URLComponents(string: environment.baseURL)
        components?.path += path
        
        if let parameters = parameters, method == .GET {
            components?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value.toString())
            }
        }
        
        return components
    }
    
    var url: URL? { components?.url }
}

// MARK: - Request Building
public extension Endpoint {
    /// Builds a URLRequest from the endpoint's properties.
    ///
    /// - Returns: A Result containing either the constructed URLRequest or a NetworkError
    var buildRequest: Result<URLRequest, NetworkError> {
        do {
            return .success(try makeRequest())
        } catch {
            return .failure(error as? NetworkError ?? .invalidRequest)
        }
    }
    
    /// Creates a URLRequest from the endpoint's properties.
    ///
    /// - Throws: NetworkError if the request cannot be created
    /// - Returns: The constructed URLRequest
    private func makeRequest() throws -> URLRequest {
        guard let url = url else {
            throw NetworkError.invalidRequest
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let parameters = parameters, method != .GET {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
        
        return request
    }
}
