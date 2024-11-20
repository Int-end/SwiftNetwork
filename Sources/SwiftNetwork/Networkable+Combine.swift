//
//  Networkable+Combine.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation
import Combine

/// Combine extension for Networkable protocol.
///
/// This extension provides Combine publishers for performing network requests
/// using different HTTP methods.
///
/// ## Overview
/// ```swift
/// struct UserEndpoint: Networkable {
///     let path = "/users"
///     let method: HTTPMethod = .GET
///     let environment: EnvironmentConfigurable
/// }
///
/// // Basic usage
/// let endpoint = UserEndpoint(environment: Environment.development)
/// endpoint.perform()
///     .sink(
///         receiveCompletion: { completion in
///             switch completion {
///             case .finished:
///                 print("Request completed")
///             case .failure(let error):
///                 print("Error: \(error)")
///             }
///         },
///         receiveValue: { (users: [User]) in
///             print("Users: \(users)")
///         }
///     )
///     .store(in: &cancellables)
/// ```
///
/// ## HTTP Methods
/// ```swift
/// // GET request
/// let users: AnyPublisher<[User], NetworkError> = endpoint.fetch()
///
/// // POST request
/// let newUser: AnyPublisher<User, NetworkError> = endpoint.sync()
///
/// // PUT request
/// let updatedUser: AnyPublisher<User, NetworkError> = endpoint.update()
///
/// // DELETE request
/// let result: AnyPublisher<Void, NetworkError> = endpoint.delete()
/// ```
@available(iOS 13.0, macOS 10.15, *)
public extension Networkable {
    /// Performs a network request using Combine.
    ///
    /// - Returns: A Future publisher that emits the decoded response or a NetworkError
    func perform<T: Decodable>() -> Future<T, NetworkError> {
        if let request = request {
            return SwiftNetwork().perform(request)
        }
        return perform(request: method)
    }
    
    /// Performs a GET request using Combine.
    ///
    /// - Returns: A Future publisher that emits the decoded response or a NetworkError
    func fetch<T: Decodable>() -> Future<T, NetworkError> {
        perform(request: .GET)
    }
    
    /// Performs a POST request using Combine.
    ///
    /// - Returns: A Future publisher that emits the decoded response or a NetworkError
    func sync<T: Decodable>() -> Future<T, NetworkError> {
        perform(request: .POST)
    }
    
    /// Performs a PUT request using Combine.
    ///
    /// - Returns: A Future publisher that emits the decoded response or a NetworkError
    func update<T: Decodable>() -> Future<T, NetworkError> {
        perform(request: .PUT)
    }
    
    /// Performs a DELETE request using Combine.
    ///
    /// - Returns: A Future publisher that emits the decoded response or a NetworkError
    func delete<T: Decodable>() -> Future<T, NetworkError> {
        perform(request: .DELETE)
    }
    
    // MARK: - Private Helpers
    private func perform<T: Decodable>(request method: HTTPMethod) -> Future<T, NetworkError> {
        switch buildRequest {
        case .success(let request):
            return SwiftNetwork().perform(request)
        case .failure(let error):
            return Future { promise in
                promise(.failure(error))
            }
        }
    }
}
