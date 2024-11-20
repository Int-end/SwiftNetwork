//
//  NetworkConfiguration.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// Configuration settings for network operations.
///
/// This struct provides a centralized way to configure network behavior including
/// timeout intervals, session configuration, and response decoding.
///
/// ## Overview
/// ```swift
/// // Basic configuration
/// let config = NetworkConfiguration()
///
/// // Custom configuration
/// let config = NetworkConfiguration(
///     timeoutInterval: 60,
///     sessionConfiguration: {
///         let config = URLSessionConfiguration.default
///         config.waitsForConnectivity = true
///         config.requestCachePolicy = .returnCacheDataElseLoad
///         return config
///     }(),
///     decoder: {
///         let decoder = JSONDecoder()
///         decoder.keyDecodingStrategy = .convertFromSnakeCase
///         decoder.dateDecodingStrategy = .iso8601
///         return decoder
///     }()
/// )
/// ```
///
/// ## Topics
/// ### Creating Configuration
/// - ``init(timeoutInterval:sessionConfiguration:decoder:)``
/// - ``default``
///
/// ### Properties
/// - ``timeoutInterval``
/// - ``sessionConfiguration``
/// - ``decoder``
///
/// ## Session Configuration
/// You can customize various URLSession behaviors:
/// ```swift
/// let sessionConfig = URLSessionConfiguration.default
/// sessionConfig.timeoutIntervalForRequest = 30
/// sessionConfig.timeoutIntervalForResource = 300
/// sessionConfig.waitsForConnectivity = true
/// sessionConfig.httpMaximumConnectionsPerHost = 5
/// sessionConfig.requestCachePolicy = .returnCacheDataElseLoad
/// sessionConfig.httpAdditionalHeaders = [
///     "Accept": "application/json",
///     "User-Agent": "MyApp/1.0"
/// ]
///
/// let config = NetworkConfiguration(
///     sessionConfiguration: sessionConfig
/// )
/// ```
///
/// ## Decoder Configuration
/// You can customize JSON decoding behavior:
/// ```swift
/// let decoder = JSONDecoder()
/// decoder.keyDecodingStrategy = .convertFromSnakeCase
/// decoder.dateDecodingStrategy = .iso8601
/// decoder.nonConformingFloatDecodingStrategy = .convertFromString(
///     positiveInfinity: "+infinity",
///     negativeInfinity: "-infinity",
///     nan: "nan"
/// )
///
/// let config = NetworkConfiguration(
///     decoder: decoder
/// )
/// ```
public struct NetworkConfiguration {
    // MARK: - Properties
    
    /// The timeout interval for network requests.
    ///
    /// This value determines how long a request can take before timing out.
    /// The default value is 30 seconds.
    public let timeoutInterval: TimeInterval
    
    /// The URLSession configuration used for network requests.
    ///
    /// This configuration determines the behavior of network requests including:
    /// - Cache policy
    /// - Timeout values
    /// - Connection limits
    /// - Additional headers
    public let sessionConfiguration: URLSessionConfiguration
    
    /// The JSON decoder used to parse network responses.
    ///
    /// This decoder is used to convert JSON responses into Swift types.
    /// You can customize its behavior for special cases like:
    /// - Key decoding strategy
    /// - Date decoding strategy
    /// - Data decoding strategy
    public let decoder: JSONDecoder
    
    // MARK: - Default Configuration
    
    /// The default configuration for network services.
    ///
    /// This configuration includes:
    /// - 30 second timeout interval
    /// - Default URLSession configuration
    /// - Standard JSON decoder
    ///
    /// ```swift
    /// let network = SwiftNetwork(configuration: .default)
    /// ```
    public static var `default`: NetworkConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.waitsForConnectivity = true
        
        return NetworkConfiguration(
            timeoutInterval: 30,
            sessionConfiguration: config,
            decoder: JSONDecoder()
        )
    }
    
    // MARK: - Initialization
    
    /// Creates a new NetworkConfiguration instance.
    ///
    /// - Parameters:
    ///   - timeoutInterval: The timeout interval for requests. Defaults to 30 seconds.
    ///   - sessionConfiguration: The URLSession configuration to use. Defaults to `.default`.
    ///   - decoder: The JSON decoder for parsing responses. Defaults to a standard `JSONDecoder`.
    ///
    /// Example:
    /// ```swift
    /// let config = NetworkConfiguration(
    ///     timeoutInterval: 60,
    ///     sessionConfiguration: .default,
    ///     decoder: JSONDecoder()
    /// )
    /// ```
    public init(timeoutInterval: TimeInterval = 30,
               sessionConfiguration: URLSessionConfiguration = .default,
               decoder: JSONDecoder = JSONDecoder()) {
        self.timeoutInterval = timeoutInterval
        self.sessionConfiguration = sessionConfiguration
        self.decoder = decoder
    }
}
