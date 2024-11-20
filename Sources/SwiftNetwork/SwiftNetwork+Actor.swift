//
//  SwiftNetwork+Actor.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation
import Combine

/// A networking layer that handles HTTP requests and response processing using async/await.
///
/// This actor provides network operations using async/await pattern.
/// It implements the `AsyncNetworkService` protocol and uses `NetworkOperations` for consistent
/// error handling and response processing.
///
/// ## Overview
/// ```swift
/// // Basic usage
/// let actor = SwiftNetworkActor()
/// let result = await actor.perform(request)
/// switch result {
/// case .success(let response):
///     // Handle success
/// case .failure(let error):
///     // Handle error
/// }
///
/// // With custom configuration
/// let config = NetworkConfiguration(
///     timeoutInterval: 60,
///     sessionConfiguration: {
///         let config = URLSessionConfiguration.default
///         config.waitsForConnectivity = true
///         return config
///     }(),
///     decoder: {
///         let decoder = JSONDecoder()
///         decoder.keyDecodingStrategy = .convertFromSnakeCase
///         return decoder
///     }()
/// )
/// let actor = SwiftNetworkActor(configuration: config)
/// ```
///
/// ## Error Handling
/// ```swift
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
///     case .timeout:
///         print("Request timed out")
///     case .noConnection:
///         print("No internet connection")
///     }
/// }
/// ```
@available(iOS 13.0, macOS 10.15, *)
actor SwiftNetworkActor: NetworkOperations, AsyncNetworkService {
    // MARK: - Properties
    
    /// Configuration for the network service.
    nonisolated let configuration: NetworkConfiguration
    
    /// URLSession instance used for network operations.
    nonisolated let session: URLSession
    
    // MARK: - Initialization
    
    /// Creates a new SwiftNetworkActor instance.
    init(configuration: NetworkConfiguration = .default) {
        self.configuration = configuration
        self.session = URLSession(configuration: configuration.sessionConfiguration)
    }

    // MARK: - Network Operations
    
    /// Performs a network request using async/await.
    ///
    /// This method executes the provided URLRequest and returns the result.
    /// It handles all aspects of the network operation including:
    /// - Data fetching
    /// - Response validation
    /// - Error handling
    /// - Response decoding
    ///
    /// - Parameter request: The URLRequest to perform
    /// - Returns: A Result containing either the decoded response or a NetworkError
    func perform<T: Decodable>(_ request: URLRequest) async -> Result<T, NetworkError> {
        do {
            let (data, response) = try await session.data(for: request)
            return handleResponse(data: data,
                               response: response,
                               error: nil)
        } catch let error as URLError {
            return handleError(error)
        } catch {
            return .failure(.networkFailure(error))
        }
    }
}
