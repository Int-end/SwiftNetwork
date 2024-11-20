//
//  NetworkOperations.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// A protocol that defines common network operations.
///
/// This protocol provides shared functionality for handling network responses,
/// errors, and data processing across different networking implementations.
///
/// ## Overview
/// ```swift
/// // Basic implementation
/// struct NetworkClient: NetworkOperations {
///     let configuration: NetworkConfiguration
///     let session: URLSession
///     
///     init(configuration: NetworkConfiguration = .default) {
///         self.configuration = configuration
///         self.session = URLSession(configuration: configuration.sessionConfiguration)
///     }
/// }
/// ```
///
/// ## Response Handling
/// ```swift
/// // Handle network response
/// let result: Result<Response, NetworkError> = handleResponse(
///     data: responseData,
///     response: httpResponse,
///     error: nil
/// )
///
/// // Handle specific error
/// let errorResult: Result<Response, NetworkError> = handleError(someError)
///
/// // Handle HTTP status code
/// let statusResult: Result<Response, NetworkError> = handleHTTPError(404)
///
/// // Decode response data
/// let decodedResult: Result<Response, NetworkError> = decodeResponse(jsonData)
/// ```
///
/// ## Error Handling
/// ```swift
/// switch error {
/// case .networkFailure(let error):
///     print("Network error: \(error)")
/// case .timeout(let error):
///     print("Timeout: \(error)")
/// case .noConnection:
///     print("No internet connection")
/// case .cancelled:
///     print("Request cancelled")
/// case .serverError(let code):
///     print("Server error: \(code)")
/// case .clientError(let code):
///     print("Client error: \(code)")
/// case .invalidResponse:
///     print("Invalid response")
/// case .noData:
///     print("No data received")
/// }
/// ```
public protocol NetworkOperations {
    // MARK: - Properties
    
    /// Configuration for network operations.
    ///
    /// Provides settings for timeouts, session configuration, and response decoding.
    var configuration: NetworkConfiguration { get }
    
    /// URLSession for performing requests.
    ///
    /// The session used to make network requests with the specified configuration.
    var session: URLSession { get }
    
    // MARK: - Response Handling
    
    /// Processes network response data.
    ///
    /// Handles the complete network response including data validation,
    /// error checking, and response decoding.
    ///
    /// - Parameters:
    ///   - data: Response data from the server
    ///   - response: URLResponse from the server
    ///   - error: Any error that occurred
    /// - Returns: A Result containing either the decoded response or a NetworkError
    func handleResponse<T: Decodable>(data: Data?, 
                                    response: URLResponse?, 
                                    error: Error?) -> Result<T, NetworkError>
    
    /// Handles network-related errors.
    ///
    /// Converts various error types into appropriate NetworkError cases.
    ///
    /// - Parameter error: The error to handle
    /// - Returns: A Result containing the error wrapped in a NetworkError
    func handleError<T>(_ error: Error) -> Result<T, NetworkError>
    
    /// Handles HTTP status code errors.
    ///
    /// Converts HTTP status codes into appropriate NetworkError cases.
    ///
    /// - Parameter statusCode: The HTTP status code
    /// - Returns: A Result containing the appropriate NetworkError
    func handleHTTPError<T>(statusCode: Int) -> Result<T, NetworkError>
    
    /// Decodes response data into the specified type.
    ///
    /// Uses the configured decoder to parse the response data.
    ///
    /// - Parameter data: The data to decode
    /// - Returns: A Result containing either the decoded object or a NetworkError
    func decodeResponse<T: Decodable>(_ data: Data) -> Result<T, NetworkError>
}

// MARK: - Default Implementation
public extension NetworkOperations {
    func handleResponse<T: Decodable>(data: Data?, 
                                    response: URLResponse?, 
                                    error: Error?) -> Result<T, NetworkError> {
        if let error = error {
            return handleError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return handleHTTPError(statusCode: httpResponse.statusCode)
        }
        
        guard let data = data else {
            return .failure(.noData)
        }
        
        return decodeResponse(data)
    }
    
    func handleError<T>(_ error: Error) -> Result<T, NetworkError> {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut:
                return .failure(.timeout(urlError))
            case .notConnectedToInternet:
                return .failure(.noConnection)
            case .cancelled:
                return .failure(.cancelled)
            default:
                return .failure(.networkFailure(urlError))
            }
        }
        return .failure(.networkFailure(error))
    }
    
    func handleHTTPError<T>(statusCode: Int) -> Result<T, NetworkError> {
        switch statusCode {
        case 400...499:
            return .failure(.clientError(statusCode: statusCode))
        case 500...599:
            return .failure(.serverError(statusCode: statusCode))
        default:
            return .failure(.invalidStatusCode(statusCode))
        }
    }
    
    func decodeResponse<T: Decodable>(_ data: Data) -> Result<T, NetworkError> {
        do {
            let decoded = try configuration.decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(.decodingError(error))
        }
    }
} 
