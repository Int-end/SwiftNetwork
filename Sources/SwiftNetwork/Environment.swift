//
//  Environment.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// Protocol defining environment configuration properties such as the base URL and API key for the environment.
public protocol EnvironmentConfigurable {
    /// The base URL for all API requests, usually the root URL of the API service.
    var baseURL: String { get }
    
    /// The API key to be included in the request headers for authentication or authorization.
    var apiKey: String { get }
}

/// Represents the environment configuration, which includes the base URL and API key.
public struct Environment: EnvironmentConfigurable {
    public let baseURL: String
    public let apiKey: String
    
    /// Initializes a new `Environment` object with the given base URL and API key.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL for the API.
    ///   - apiKey: The API key for authentication.
    public init(baseURL: String, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
}
