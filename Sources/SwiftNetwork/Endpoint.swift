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
    var parameters: [String: Any]? { get }
    
    /// The environment configuration, including base URL and API key.
    var environment: EnvironmentConfigurable { get }
    
    /// The URL from the base URL and the endpoint path.
    var url: URL? { get }
    
    /// The URL Request
    /// > Warning: If the request has a value, other Endpoint items will not be used. We will directly perform the operation with this request.
    var request: URLRequest? { get }
    
    /// Configures URLComponents with base URL and path
    /// > Warning: If components has a value, the URL will be built from it. You can override this using the url property.
    var components: URLComponents? { get }
}

/// Default Implementation for Endpoint to simplify endpoint creation and network request handling.
public extension Endpoint {
    var method: HTTPMethod { .GET }
    var headers: [String: String]? { nil }
    var parameters: [String: Any]? { nil }
    
    /// The URL from the base URL and the endpoint path.
    ///
    /// - Returns: A `URL?` representing the complete URL for the endpoint, or `nil` if the URL is invalid.
    var url: URL? {
        components?.url
    }
    
    // The URL Components
    var components: URLComponents? {
        var components = URLComponents(string: environment.baseURL)
        components?.path += path
        return components
    }
    
    var request: URLRequest? { nil }
    
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
    
    /**
     Performs the network request and decodes the response into a specified type.
     
     This method sends the request to the server, handles the response, and attempts to decode the response into the expected type `T`.
     If an error occurs during the request or decoding, it calls the completion handler with an error result.
     
     - Parameters:
     - completion: A closure that takes a `Result<T, NetworkError>` where `T` is the expected response model type.
     
     - Important: This method uses a background thread for the network request and should be called from the main thread when updating the UI with the results.
     */
    func perform<T: Decodable>(request completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        if let request = request {
            perform(request, completion)
                .resume()
            return
        }
        
        perform(request: method, completion)
    }
    
    func perform<T: Decodable>(request method: HTTPMethod, _ completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        guard let url = url else {
            // Return an error if the URL is invalid
            completion(.failure(.networkFailure(NSError(domain: "Invalid URL", code: -1, userInfo: nil))))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = defaultHeaders()?.merging(headers ?? [:]) { (_, new) in new }
        
        if let parameters = parameters, (method == .POST || method == .PUT) {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        // Check if the httpBody is nil if the HTTP Method is POST OR PUT, skip early.
        if method == .POST || method == .PUT {
            if request.httpBody == nil {
                completion(.failure(.invalidRequestBody))
                return
            }
        }
        
        perform(request, completion)
            .resume()
    }
    
    func perform<T: Decodable>(_ request: URLRequest, _ completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) -> URLSessionDataTask {
        // Perform the network request asynchronously
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkFailure(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.networkFailure(NSError(domain: "Invalid Response", code: -1, userInfo: nil))))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorDomain = (400...499).contains(httpResponse.statusCode) ? "Client Error" : "Server Error"
                completion(.failure(.networkFailure(NSError(domain: errorDomain, code: httpResponse.statusCode, userInfo: nil))))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Attempt to decode the response data into the specified model
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
    }
    
    func fetch<T: Decodable>( _ completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        perform(request: .GET, completion)
    }
    
    func sync<T: Decodable>( _ completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        perform(request: .POST, completion)
    }
    
    func update<T: Decodable>( _ completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        perform(request: .PUT, completion)
    }
    
    func delete<T: Decodable>( _ completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        perform(request: .DELETE, completion)
    }
}
