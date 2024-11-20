//
//  NetworkError.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// Represents errors that can occur during network operations.
///
/// This enum provides a comprehensive set of error cases that can occur during
/// network requests, response handling, and data processing.
///
/// ## Overview
/// NetworkError provides type-safe error handling:
/// ```swift
/// switch error {
/// case .networkFailure(let error):
///     // Handle network connectivity issues
///     print("Network error: \(error)")
/// case .decodingError(let error):
///     // Handle JSON parsing errors
///     print("Decoding error: \(error)")
/// case .invalidResponse:
///     // Handle invalid HTTP responses
///     print("Invalid response received")
/// case .noData:
///     // Handle empty responses
///     print("No data received")
/// case .timeout:
///     // Handle request timeouts
///     print("Request timed out")
/// case .noConnection:
///     // Handle no internet connection
///     print("No internet connection")
/// }
/// ```
///
/// ## Topics
/// ### Network Errors
/// - ``networkFailure(_:)``
/// - ``timeout(_:)``
/// - ``noConnection``
/// - ``cancelled``
///
/// ### Response Errors
/// - ``invalidResponse``
/// - ``noData``
/// - ``invalidStatusCode(_:)``
///
/// ### HTTP Status Errors
/// - ``clientError(statusCode:)``
/// - ``serverError(statusCode:)``
///
/// ### Data Processing Errors
/// - ``decodingError(_:)``
/// - ``invalidRequest``
/// - ``invalidRequestBody``
public enum NetworkError: Error {
    // MARK: - Network Errors
    
    /// A general network error occurred.
    ///
    /// This error indicates issues with the network connection or request.
    /// - Parameter error: The underlying error that caused the network failure
    case networkFailure(Error)
    
    /// The request timed out.
    ///
    /// This error occurs when a request takes longer than the specified timeout interval.
    /// - Parameter error: The URLError containing timeout details
    case timeout(URLError)
    
    /// No internet connection is available.
    ///
    /// This error occurs when the device has no active internet connection.
    case noConnection
    
    /// The request was cancelled.
    ///
    /// This error occurs when the network request is explicitly cancelled.
    case cancelled
    
    // MARK: - Response Errors
    
    /// The server response was invalid.
    ///
    /// This error occurs when the response cannot be parsed as an HTTP response.
    case invalidResponse
    
    /// No data was received in the response.
    ///
    /// This error occurs when the response body is empty when data was expected.
    case noData
    
    /// The response had an unexpected status code.
    ///
    /// This error occurs when the response status code is outside the expected range.
    /// - Parameter code: The unexpected HTTP status code
    case invalidStatusCode(Int)
    
    // MARK: - HTTP Status Errors
    
    /// A client error occurred (4xx status code).
    ///
    /// This error represents HTTP client errors like 400 Bad Request, 401 Unauthorized, etc.
    /// - Parameter statusCode: The specific 4xx status code
    case clientError(statusCode: Int)
    
    /// A server error occurred (5xx status code).
    ///
    /// This error represents HTTP server errors like 500 Internal Server Error, 503 Service Unavailable, etc.
    /// - Parameter statusCode: The specific 5xx status code
    case serverError(statusCode: Int)
    
    // MARK: - Data Processing Errors
    
    /// Failed to decode the response data.
    ///
    /// This error occurs when the response data cannot be decoded into the expected type.
    /// - Parameter error: The underlying decoding error
    case decodingError(Error)
    
    /// The request could not be created.
    ///
    /// This error occurs when a URLRequest cannot be constructed from the endpoint.
    case invalidRequest
    
    /// The request body is invalid.
    ///
    /// This error occurs when the request body cannot be properly encoded.
    case invalidRequestBody
}

// MARK: - CustomStringConvertible
extension NetworkError: CustomStringConvertible {
    /// A human-readable description of the error.
    public var description: String {
        switch self {
        case .networkFailure(let error):
            return "Network error: \(error.localizedDescription)"
        case .timeout(let error):
            return "Request timed out: \(error.localizedDescription)"
        case .noConnection:
            return "No internet connection"
        case .cancelled:
            return "Request was cancelled"
        case .invalidResponse:
            return "Invalid server response"
        case .noData:
            return "No data received"
        case .invalidStatusCode(let code):
            return "Invalid status code: \(code)"
        case .clientError(let code):
            return "Client error with status code: \(code)"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .invalidRequest:
            return "Invalid request"
        case .invalidRequestBody:
            return "Invalid request body"
        }
    }
}

// MARK: - Equatable
extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidRequest, .invalidRequest),
             (.invalidRequestBody, .invalidRequestBody),
             (.noData, .noData),
             (.invalidResponse, .invalidResponse),
             (.noConnection, .noConnection),
             (.cancelled, .cancelled):
            return true
        case (.networkFailure(let lhsError), .networkFailure(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.timeout(let lhsError), .timeout(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        case (.clientError(let lhsCode), .clientError(let rhsCode)):
            return lhsCode == rhsCode
        case (.invalidStatusCode(let lhsCode), .invalidStatusCode(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}
