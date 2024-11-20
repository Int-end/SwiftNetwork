//
//  SwiftNetwork.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation
import Combine

/// A networking layer that handles HTTP requests and response processing using completion handlers.
///
/// This struct provides network operations using completion handlers pattern.
/// It implements the `NetworkService` protocol and uses `NetworkOperations` for consistent
/// error handling and response processing across the framework.
///
/// ## Overview
/// SwiftNetwork provides a traditional completion handler-based approach to network operations:
/// ```swift
/// let network = SwiftNetwork()
/// network.perform(request) { result in
///     switch result {
///     case .success(let response):
///         // Handle success
///     case .failure(let error):
///         // Handle error
///     }
/// }
/// ```
///
/// ## Topics
/// ### Creating Network Client
/// - ``init(configuration:)``
///
/// ### Properties
/// - ``configuration``
/// - ``session``
///
/// ### Network Operations
/// - ``perform(_:_:)``
///
/// ## Error Handling
/// The network client handles various types of errors:
/// ```swift
/// switch error {
/// case .networkFailure(let error):
///     // Network connectivity issues
/// case .decodingError(let error):
///     // JSON parsing errors
/// case .invalidResponse:
///     // Invalid HTTP response
/// case .noData:
///     // Empty response
/// case .timeout:
///     // Request timed out
/// case .noConnection:
///     // No internet connection
/// }
/// ```
public struct SwiftNetwork: NetworkOperations, NetworkService {
    // MARK: - Properties
    
    /// Configuration for the network service.
    public let configuration: NetworkConfiguration
    
    /// URLSession instance used for network operations.
    public let session: URLSession
    
    // MARK: - Initialization
    
    /// Creates a new SwiftNetwork instance.
    public init(configuration: NetworkConfiguration = .default) {
        self.configuration = configuration
        self.session = URLSession(configuration: configuration.sessionConfiguration)
    }

    // MARK: - Network Operations
    
    /// Performs a network request with completion handler.
    ///
    /// This method executes the provided URLRequest and calls the completion handler with the result.
    /// It handles all aspects of the network operation including:
    /// - Data fetching
    /// - Response validation
    /// - Error handling
    /// - Response decoding
    ///
    /// - Parameters:
    ///   - request: The URLRequest to perform
    ///   - completion: A closure called with the result of the network operation
    public func perform<T: Decodable>(_ request: URLRequest,
                                   _ completion: @escaping (Result<T, NetworkError>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            let result: Result<T, NetworkError> = self.handleResponse(data: data,
                                                                    response: response,
                                                                    error: error)
            completion(result)
        }
        .resume()
    }
}
