//
//  NetworkService.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// A protocol for completion handler based network service.
///
/// This protocol defines the interface for performing network requests
/// using completion handlers.
///
/// ## Overview
/// ```swift
/// // Basic usage
/// let network = SwiftNetwork()
/// network.perform(request) { (result: Result<Response, NetworkError>) in
///     switch result {
///     case .success(let response):
///         print("Success: \(response)")
///     case .failure(let error):
///         print("Error: \(error)")
///     }
/// }
///
/// // With error handling
/// network.perform(request) { result in
///     switch result {
///     case .success(let response):
///         // Handle success
///     case .failure(let error):
///         switch error {
///         case .networkFailure(let error):
///             print("Network error: \(error)")
///         case .decodingError(let error):
///             print("Decoding error: \(error)")
///         case .invalidResponse:
///             print("Invalid response")
///         case .noData:
///             print("No data received")
///         }
///     }
/// }
/// ```
public protocol NetworkService: NetworkOperations {
    /// Performs a network request with completion handler.
    ///
    /// - Parameters:
    ///   - request: The URLRequest to perform
    ///   - completion: A closure called with the result
    func perform<T: Decodable>(_ request: URLRequest, 
                              _ completion: @escaping (Result<T, NetworkError>) -> Void)
}

/// A protocol for async/await based network service.
///
/// This protocol defines the interface for performing network requests
/// using async/await pattern.
///
/// ## Overview
/// ```swift
/// // Basic usage
/// let actor = SwiftNetworkActor()
/// let result = await actor.perform(request)
/// switch result {
/// case .success(let response):
///     print("Success: \(response)")
/// case .failure(let error):
///     print("Error: \(error)")
/// }
///
/// // With error handling
/// let result = await actor.perform(request)
/// switch result {
/// case .success(let response):
///     // Handle success
/// case .failure(let error):
///     switch error {
///     case .networkFailure(let error):
///         print("Network error: \(error)")
///     case .decodingError(let error):
///         print("Decoding error: \(error)")
///     case .invalidResponse:
///         print("Invalid response")
///     case .noData:
///         print("No data received")
///     }
/// }
/// ```
@available(iOS 13.0, macOS 10.15, *)
public protocol AsyncNetworkService: NetworkOperations {
    /// Performs a network request using async/await.
    ///
    /// - Parameter request: The URLRequest to perform
    /// - Returns: A Result containing either the decoded response or a NetworkError
    func perform<T: Decodable>(_ request: URLRequest) async -> Result<T, NetworkError>
}
