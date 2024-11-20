//
//  QueryStringConvertible.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// A protocol for types that can be converted to query string parameters.
///
/// This protocol enables types to be used as values in URL query parameters
/// or request body parameters.
///
/// ## Overview
/// ```swift
/// // Basic usage
/// let parameters: [String: QueryStringConvertible] = [
///     "page": 1,
///     "limit": 20,
///     "search": "query",
///     "active": true
/// ]
///
/// // Custom type conformance
/// struct Filter: QueryStringConvertible {
///     let value: String
///     
///     func toString() -> String? {
///         value
///     }
/// }
///
/// let params: [String: QueryStringConvertible] = [
///     "filter": Filter(value: "active")
/// ]
/// ```
///
/// ## Built-in Conformance
/// The following types automatically conform to QueryStringConvertible:
/// - String
/// - Int
/// - Double
/// - Bool
///
/// ## Usage with Endpoints
/// ```swift
/// struct SearchEndpoint: Endpoint {
///     let path = "/search"
///     let environment: EnvironmentConfigurable
///     
///     var parameters: [String: QueryStringConvertible]? {
///         [
///             "query": searchTerm,
///             "page": page,
///             "limit": limit,
///             "sort": sortOrder
///         ]
///     }
///     
///     private let searchTerm: String
///     private let page: Int
///     private let limit: Int
///     private let sortOrder: String
///     
///     init(environment: EnvironmentConfigurable,
///          searchTerm: String,
///          page: Int = 1,
///          limit: Int = 20,
///          sortOrder: String = "desc") {
///         self.environment = environment
///         self.searchTerm = searchTerm
///         self.page = page
///         self.limit = limit
///         self.sortOrder = sortOrder
///     }
/// }
/// ```
public protocol QueryStringConvertible {
    /// Converts the value to a string for use in query parameters.
    ///
    /// - Returns: String representation of the value, or nil if conversion fails
    func toString() -> String?
}

// MARK: - Standard Type Conformance
extension String: QueryStringConvertible {
    public func toString() -> String? { self }
}

extension Int: QueryStringConvertible {
    public func toString() -> String? { String(self) }
}

extension Double: QueryStringConvertible {
    public func toString() -> String? { String(self) }
}

extension Bool: QueryStringConvertible {
    public func toString() -> String? { String(self) }
}
