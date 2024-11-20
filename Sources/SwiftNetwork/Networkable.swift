//
//  Networkable.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// A protocol that extends `Endpoint` to provide network request functionality.
///
/// This protocol adds convenience methods for performing network requests using
/// different HTTP methods and request styles.
///
/// ## Overview
/// ```swift
/// struct UserEndpoint: Networkable {
///     let path = "/users"
///     let method: HTTPMethod = .GET
///     let environment: EnvironmentConfigurable
///     
///     init(environment: EnvironmentConfigurable) {
///         self.environment = environment
///     }
/// }
///
/// // Using completion handlers
/// let endpoint = UserEndpoint(environment: Environment.development)
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
/// ```
///
/// ## HTTP Methods
/// ```swift
/// // GET request
/// endpoint.fetch { (result: Result<[User], NetworkError>) in }
///
/// // POST request
/// endpoint.sync { (result: Result<User, NetworkError>) in }
///
/// // PUT request
/// endpoint.update { (result: Result<User, NetworkError>) in }
///
/// // DELETE request
/// endpoint.delete { (result: Result<Void, NetworkError>) in }
/// ```
public protocol Networkable: Endpoint {}

// MARK: - Completion Handler Methods
public extension Networkable {
    /// Performs a network request with the specified HTTP method.
    ///
    /// - Parameters:
    ///   - method: The HTTP method to use
    ///   - completion: A closure called with the result
    func perform<T: Decodable>(request method: HTTPMethod,
                              _ completion: @escaping (Result<T, NetworkError>) -> Void) {
        switch buildRequest {
        case .success(let request):
            SwiftNetwork().perform(request, completion)
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    /// Performs a network request using the endpoint's configuration.
    ///
    /// - Parameter completion: A closure called with the result
    func perform<T: Decodable>(completion: @escaping (Result<T, NetworkError>) -> Void) {
        if let request = request {
            SwiftNetwork().perform(request, completion)
            return
        }
        perform(request: method, completion)
    }
    
    /// Performs a GET request.
    ///
    /// - Parameter completion: A closure called with the result
    func fetch<T: Decodable>(_ completion: @escaping (Result<T, NetworkError>) -> Void) {
        perform(request: .GET, completion)
    }
    
    /// Performs a POST request.
    ///
    /// - Parameter completion: A closure called with the result
    func sync<T: Decodable>(_ completion: @escaping (Result<T, NetworkError>) -> Void) {
        perform(request: .POST, completion)
    }
    
    /// Performs a PUT request.
    ///
    /// - Parameter completion: A closure called with the result
    func update<T: Decodable>(_ completion: @escaping (Result<T, NetworkError>) -> Void) {
        perform(request: .PUT, completion)
    }
    
    /// Performs a DELETE request.
    ///
    /// - Parameter completion: A closure called with the result
    func delete<T: Decodable>(_ completion: @escaping (Result<T, NetworkError>) -> Void) {
        perform(request: .DELETE, completion)
    }
}
