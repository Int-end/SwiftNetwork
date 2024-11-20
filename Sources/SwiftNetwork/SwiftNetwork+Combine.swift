//
//  SwiftNetwork+Combine.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation
import Combine

/// Combine extension for SwiftNetwork.
///
/// This extension provides Combine publishers for performing network requests.
/// It converts completion handler-based methods into Combine publishers.
///
/// ## Overview
/// ```swift
/// // Basic usage
/// let network = SwiftNetwork()
/// network.perform(request)
///     .sink(
///         receiveCompletion: { completion in
///             switch completion {
///             case .finished:
///                 print("Request completed")
///             case .failure(let error):
///                 print("Error: \(error)")
///             }
///         },
///         receiveValue: { (response: Response) in
///             print("Success: \(response)")
///         }
///     )
///     .store(in: &cancellables)
///
/// // With error handling
/// network.perform(request)
///     .catch { error -> AnyPublisher<Response, NetworkError> in
///         print("Error: \(error)")
///         return Empty().eraseToAnyPublisher()
///     }
///     .sink(
///         receiveCompletion: { _ in },
///         receiveValue: { response in
///             print("Success: \(response)")
///         }
///     )
///     .store(in: &cancellables)
/// ```
@available(iOS 13.0, macOS 10.15, *)
extension SwiftNetwork {
    /// Performs a network request and returns a Combine publisher.
    ///
    /// This method wraps the completion handler-based network request
    /// in a Combine Future publisher.
    ///
    /// - Parameter request: The URLRequest to perform
    /// - Returns: A Future publisher that emits the decoded response or a NetworkError
    public func perform<T: Decodable>(_ request: URLRequest) -> Future<T, NetworkError> {
        Future { promise in
            perform(request) { (result: Result<T, NetworkError>) in
                promise(result)
            }
        }
    }
}
