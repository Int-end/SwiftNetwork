//
//  HTTPMethod.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// HTTP methods for network requests.
///
/// Represents standard HTTP methods used in RESTful APIs.
///
/// ## Overview
/// ```swift
/// // Basic usage
/// struct UserEndpoint: Endpoint {
///     let method: HTTPMethod = .GET
///     let path = "/users"
///     let environment: EnvironmentConfigurable
/// }
///
/// // Different HTTP methods
/// let getUsers = HTTPMethod.GET      // Fetch users
/// let createUser = HTTPMethod.POST   // Create user
/// let updateUser = HTTPMethod.PUT    // Update user
/// let deleteUser = HTTPMethod.DELETE // Delete user
/// ```
///
/// ## Common Use Cases
/// ```swift
/// // GET: Fetch resources
/// struct FetchUsersEndpoint: Endpoint {
///     let method: HTTPMethod = .GET
///     let path = "/users"
/// }
///
/// // POST: Create resource
/// struct CreateUserEndpoint: Endpoint {
///     let method: HTTPMethod = .POST
///     let path = "/users"
///     let parameters: [String: QueryStringConvertible]?
/// }
///
/// // PUT: Update resource
/// struct UpdateUserEndpoint: Endpoint {
///     let method: HTTPMethod = .PUT
///     let path = "/users/123"
///     let parameters: [String: QueryStringConvertible]?
/// }
///
/// // DELETE: Remove resource
/// struct DeleteUserEndpoint: Endpoint {
///     let method: HTTPMethod = .DELETE
///     let path = "/users/123"
/// }
/// ```
public enum HTTPMethod: String {
    /// GET method for retrieving resources.
    ///
    /// Use for:
    /// - Fetching data
    /// - Reading resources
    /// - Search operations
    case GET
    
    /// POST method for creating resources.
    ///
    /// Use for:
    /// - Creating new resources
    /// - Submitting data
    /// - Complex operations
    case POST
    
    /// PUT method for updating resources.
    ///
    /// Use for:
    /// - Updating existing resources
    /// - Replacing data
    /// - Full updates
    case PUT
    
    /// DELETE method for removing resources.
    ///
    /// Use for:
    /// - Removing resources
    /// - Deleting data
    /// - Cleanup operations
    case DELETE
}

// MARK: - CustomStringConvertible
extension HTTPMethod: CustomStringConvertible {
    public var description: String { rawValue }
}

// MARK: - Equatable & Hashable
extension HTTPMethod: Equatable, Hashable {}
