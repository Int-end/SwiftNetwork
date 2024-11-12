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
    var bodyParameters: [String: Any]? { get }
    
    /// The environment configuration, including base URL and API key.
    var environment: EnvironmentConfigurable { get }

    /// Performs the network request and decodes the response into a specified type.
    ///
    /// - Parameters:
    ///   - completion: A closure that returns a `Result` containing the decoded object or an error.
    func perform<T: Decodable>(request completion: @escaping @Sendable (Result<T, NetworkError>) -> Void)
}

/// Default Implementation for Endpoint to simplify endpoint creation and network request handling.
public extension Endpoint {
    
    /// Builds the complete URL from the base URL and the endpoint path.
    ///
    /// - Returns: A `URL?` representing the complete URL for the endpoint, or `nil` if the URL is invalid.
    func buildURL() -> URL? {
        return URL(string: environment.baseURL + path)
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

    /**
     Performs the network request and decodes the response into a specified type.
     
     This method sends the request to the server, handles the response, and attempts to decode the response into the expected type `T`.
     If an error occurs during the request or decoding, it calls the completion handler with an error result.
     
     - Parameters:
         - completion: A closure that takes a `Result<T, NetworkError>` where `T` is the expected response model type.
     
     - Important: This method uses a background thread for the network request and should be called from the main thread when updating the UI with the results.
     */
    func perform<T: Decodable>(request completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        guard let url = buildURL() else {
            // Return an error if the URL is invalid
            completion(.failure(.networkFailure(NSError(domain: "Invalid URL", code: -1, userInfo: nil))))
            return
        }

        // Creating the request object inside a closure for immutability
        let request: URLRequest = {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers ?? defaultHeaders()
            
            // Set body parameters if available
            if let bodyParameters = bodyParameters {
                request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            }
            
            return request
        }()

        // Check if the httpBody is nil, and return early if so
        if request.httpBody == nil {
            completion(.failure(.invalidRequestBody))
            return
        }
        
        // Perform the network request asynchronously
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkFailure(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.networkFailure(NSError(domain: "Invalid Response",
                                                              code: -1,
                                                          userInfo: nil))))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 400...499:
                completion(.failure(.networkFailure(NSError(domain: "Client Error",
                                                            code: httpResponse.statusCode,
                                                            userInfo: nil))))
                return
            case 500...599:
                completion(.failure(.networkFailure(NSError(domain: "Server Error",
                                                            code: httpResponse.statusCode,
                                                            userInfo: nil))))
                return
            default:
                completion(.failure(.networkFailure(NSError(domain: "Unknown Error",
                                                            code: httpResponse.statusCode,
                                                            userInfo: nil))))
                return
            }
            
            // Check if data was received, otherwise return an error
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
        }.resume()
    }
}
