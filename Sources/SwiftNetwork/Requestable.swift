//
//  Requestable.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// A protocol that provides a simplified interface for network requests.
///
/// This protocol extends `Networkable` to provide a clean and consistent way
/// to create endpoints and handle network requests.
///
/// ## Overview
/// ```swift
/// // Basic endpoint
/// struct UserEndpoint: Requestable {
///     let path = "/users"
///     let environment: EnvironmentConfigurable
///     
///     init(environment: EnvironmentConfigurable) {
///         self.environment = environment
///     }
/// }
///
/// // Parameterized endpoint
/// struct SearchEndpoint: Requestable {
///     let path = "/search"
///     let environment: EnvironmentConfigurable
///     
///     var parameters: [String: QueryStringConvertible]? {
///         [
///             "query": query,
///             "page": page,
///             "limit": limit
///         ]
///     }
///     
///     private let query: String
///     private let page: Int
///     private let limit: Int
///     
///     init(environment: EnvironmentConfigurable,
///          query: String,
///          page: Int = 1,
///          limit: Int = 20) {
///         self.environment = environment
///         self.query = query
///         self.page = page
///         self.limit = limit
///     }
/// }
/// ```
///
/// ## Usage
/// ```swift
/// // Using completion handlers
/// let endpoint = UserEndpoint(environment: .development)
/// endpoint.perform { (result: Result<[User], NetworkError>) in
///     switch result {
///     case .success(let users):
///         print("Users: \(users)")
///     case .failure(let error):
///         print("Error: \(error)")
///     }
/// }
///
/// // Using async/await
/// let result = await endpoint.perform()
/// switch result {
/// case .success(let users):
///     print("Users: \(users)")
/// case .failure(let error):
///     print("Error: \(error)")
/// }
///
/// // Using Combine
/// endpoint.perform()
///     .sink(
///         receiveCompletion: { completion in
///             if case .failure(let error) = completion {
///                 print("Error: \(error)")
///             }
///         },
///         receiveValue: { users in
///             print("Users: \(users)")
///         }
///     )
///     .store(in: &cancellables)
/// ```
public protocol Requestable: Networkable {}

// MARK: - Default Implementation
public extension Requestable {}
