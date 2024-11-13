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
public protocol Endpoint {
    /// The path of the API endpoint, typically appended to the base URL to form the full URL.
    var path: String { get }
    
    /// The HTTP method to be used for the request (e.g., GET, POST, PUT, DELETE).
    var method: HTTPMethod { get }
    
    /// The headers to be included in the request. Defaults to nil, which means default headers are used.
    var headers: [String: String]? { get }
    
    /// The body parameters to be included in the request, if applicable. Defaults to nil.
    var parameters: [String: QueryStringConvertible]? { get }
    
    /// The environment configuration, including base URL and API key.
    var environment: EnvironmentConfigurable { get }
    
    /// The URL Request
    /// > Warning: If the request has a value, other Endpoint items will not be used. We will directly perform the operation with this request.
    var request: URLRequest? { get }
}

extension Endpoint {
    var method: HTTPMethod { .GET }
    var headers: [String: String]? { nil }
    var parameters: [String: QueryStringConvertible]? { nil }
    var request: URLRequest? { nil }
    
    // The URL Components
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
    
    /// The URL from the base URL and the endpoint path.
    ///
    /// - Returns: A `URL?` representing the complete URL for the endpoint, or `nil` if the URL is invalid.
    var url: URL? {
        components?.url
    }
    
    /// Provides default headers for the request, including the `Authorization` header if an API key is available.
    ///
    /// - Returns: A dictionary of headers to be included in the request.
    func defaultHeaders() -> [String: String]? {
        var defaultHeaders = [String: String]()
        if !environment.apiKey.isEmpty {
            defaultHeaders["Authorization"] = "Bearer \(environment.apiKey)"
        }
        return defaultHeaders
    }
}
