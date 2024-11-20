//
//  Environment.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// A protocol for defining network environments.
///
/// Provides a standardized way to configure different environments
/// (development, staging, production) with their base URLs and authentication.
///
/// ## Overview
/// ```swift
/// // Basic environment
/// struct DevelopmentEnvironment: EnvironmentConfigurable {
///     let baseURL = "https://dev-api.example.com"
///     let apiKey = "DEV_API_KEY"
/// }
///
/// // Custom environment
/// struct ProductionEnvironment: EnvironmentConfigurable {
///     let baseURL: String
///     let apiKey: String
///     
///     init(baseURL: String = "https://api.example.com",
///          apiKey: String) {
///         self.baseURL = baseURL
///         self.apiKey = apiKey
///     }
/// }
/// ```
///
/// ## Usage with Endpoints
/// ```swift
/// struct UserEndpoint: Endpoint {
///     let environment: EnvironmentConfigurable
///     let path = "/users"
///     
///     init(environment: EnvironmentConfigurable) {
///         self.environment = environment
///     }
/// }
///
/// // Using different environments
/// let devEndpoint = UserEndpoint(environment: DevelopmentEnvironment())
/// let prodEndpoint = UserEndpoint(environment: ProductionEnvironment(apiKey: "PROD_KEY"))
/// ```
public protocol EnvironmentConfigurable {
    /// The base URL for API requests.
    var baseURL: String { get }

    /// The API key for authentication.
    var apiKey: String { get }
}

/// A concrete implementation of EnvironmentConfigurable.
///
/// This struct provides a basic environment configuration that can be used
/// directly or as a base for more specific environments.
///
/// ## Example
/// ```swift
/// // Basic usage
/// let environment = Environment(
///     baseURL: "https://api.example.com",
///     apiKey: "YOUR_API_KEY"
/// )
///
/// // With custom configuration
/// let config = Environment(
///     baseURL: "https://custom-api.example.com",
///     apiKey: String(format: "key_%@", UUID().uuidString)
/// )
/// ```
public struct Environment: EnvironmentConfigurable {
    public let baseURL: String
    public let apiKey: String

    public init(baseURL: String, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
}

// MARK: - Predefined Environments
public extension Environment {
    /// Development environment configuration.
    static var development: Environment {
        Environment(
            baseURL: "https://dev-api.example.com",
            apiKey: "DEV_API_KEY"
        )
    }
    
    /// Staging environment configuration.
    static var staging: Environment {
        Environment(
            baseURL: "https://staging-api.example.com",
            apiKey: "STAGING_API_KEY"
        )
    }
    
    /// Production environment configuration.
    static var production: Environment {
        Environment(
            baseURL: "https://api.example.com",
            apiKey: "PROD_API_KEY"
        )
    }
}
