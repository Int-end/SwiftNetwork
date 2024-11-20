//
//  Networkable+Actor.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// Async/await extension for Networkable protocol.
///
/// This extension provides async/await methods for performing network requests
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
/// let result = await endpoint.perform()
/// switch result {
/// case .success(let users):
///     print("Users: \(users)")
/// case .failure(let error):
///     print("Error: \(error)")
/// }
/// ```
///
/// ## HTTP Methods
/// ```swift
/// // GET request
/// let users: Result<[User], NetworkError> = await endpoint.fetch()
///
/// // POST request
/// let newUser: Result<User, NetworkError> = await endpoint.sync()
///
/// // PUT request
/// let updatedUser: Result<User, NetworkError> = await endpoint.update()
///
/// // DELETE request
/// let result: Result<Void, NetworkError> = await endpoint.delete()
/// ```
@available(iOS 13.0, macOS 10.15, *)
public extension Networkable {
    /// Performs a network request using async/await.
    ///
    /// - Returns: A Result containing either the decoded response or a NetworkError
    func perform<T: Decodable>() async -> Result<T, NetworkError> {
        if let request = request {
            return await SwiftNetworkActor().perform(request)
        }
        return await perform(request: method)
    }
    
    /// Performs a GET request using async/await.
    ///
    /// - Returns: A Result containing either the decoded response or a NetworkError
    func fetch<T: Decodable>() async -> Result<T, NetworkError> {
        await perform(request: .GET)
    }
    
    /// Performs a POST request using async/await.
    ///
    /// - Returns: A Result containing either the decoded response or a NetworkError
    func sync<T: Decodable>() async -> Result<T, NetworkError> {
        await perform(request: .POST)
    }
    
    /// Performs a PUT request using async/await.
    ///
    /// - Returns: A Result containing either the decoded response or a NetworkError
    func update<T: Decodable>() async -> Result<T, NetworkError> {
        await perform(request: .PUT)
    }
    
    /// Performs a DELETE request using async/await.
    ///
    /// - Returns: A Result containing either the decoded response or a NetworkError
    func delete<T: Decodable>() async -> Result<T, NetworkError> {
        await perform(request: .DELETE)
    }
    
    // MARK: - Private Helpers
    private func perform<T: Decodable>(request method: HTTPMethod) async -> Result<T, NetworkError> {
        switch buildRequest {
        case .success(let request):
            return await SwiftNetworkActor().perform(request)
        case .failure(let error):
            return .failure(error)
        }
    }
}
