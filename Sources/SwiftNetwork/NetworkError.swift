//
//  NetworkError.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

/// Represents network errors that can occur during an API request.
///
/// - timeout: The request took too long to complete. This could be due to network issues or server slowness.
/// - networkFailure: A network error occurred, such as a lost connection or DNS failure.
/// - invalidRequestBody: The request body was malformed or could not be serialized.
/// - noData: The server did not send any data in response to the request.
/// - decodingError: The server's response could not be decoded into the expected model.
///
public enum NetworkError: Error {
    /// A network timeout occurred, which happens when the request takes longer than the `timeoutInterval` and the server does not respond within the specified time frame.
    /// This can be caused by slow network speeds, server unresponsiveness, or excessive server load.
    ///
    /// Example scenario: A user tries to fetch data from the server, but the request exceeds the timeout due to slow connectivity or a server bottleneck.
    case timeout(Error)

    /// A generic network failure occurred, and the error includes additional details about the failure, such as the underlying error (e.g., connectivity issues).
    case networkFailure(Error)
    
    /// Invalid request.
    case invalidRequest

    /// The request body is invalid and could not be serialized, potentially due to malformed JSON or missing required fields.
    case invalidRequestBody

    /// The server returned no data in the response. This might occur if the requested resource does not exist or the server failed to send a response.
    case noData

    /// There was an issue decoding the server's response into the expected model. This could be due to an unexpected response format.
    case decodingError(Error)
    
    case serverError(statusCode: Int)
    case clientError(statusCode: Int)

    /// Returns a human-readable description for the error, useful for logging or debugging.
    public var description: String {
        switch self {
        case .timeout(let error):
            return "Request timed out. \(error.localizedDescription)"
        case .invalidRequest:
            return "Invalid request."
        case .networkFailure(let error):
            return "Network Failure: \(error.localizedDescription)"
        case .invalidRequestBody:
            return "The request body was invalid or could not be serialized."
        case .noData:
            return "No data was received from the server."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .serverError(statusCode: let statusCode): return "Client Error StatusCode: \(statusCode)."
        case .clientError(statusCode: let statusCode): return "Server Error StatusCode: \(statusCode)."
        }
    }
}
