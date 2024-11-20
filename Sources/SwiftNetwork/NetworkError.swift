//
//  NetworkError.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// Represents various network-related errors that can occur during network operations.
public enum NetworkError: Error {
    /// A generic network failure occurred.
    case networkFailure(Error)
    
    /// The request was invalid.
    case invalidRequest
    
    /// The request body was invalid.
    case invalidRequestBody
    
    /// No data was received in the response.
    case noData
    
    /// The response data could not be decoded.
    case decodingError(Error)
    
    /// The response was invalid or malformed.
    case invalidResponse
    
    /// The request timed out.
    case timeout(Error)
    
    /// No internet connection available.
    case noConnection
    
    /// The request was cancelled.
    case cancelled
    
    /// Server returned an error status code (5xx).
    case serverError(statusCode: Int)
    
    /// Client error occurred (4xx).
    case clientError(statusCode: Int)
    
    /// Invalid HTTP status code received.
    case invalidStatusCode(Int)
}

// MARK: - CustomStringConvertible
extension NetworkError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .networkFailure(let error):
            return "Network failure: \(error.localizedDescription)"
        case .invalidRequest:
            return "Invalid request"
        case .invalidRequestBody:
            return "Invalid request body"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response"
        case .timeout(let error):
            return "Request timed out: \(error.localizedDescription)"
        case .noConnection:
            return "No internet connection"
        case .cancelled:
            return "Request cancelled"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .clientError(let statusCode):
            return "Client error with status code: \(statusCode)"
        case .invalidStatusCode(let code):
            return "Invalid status code: \(code)"
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
