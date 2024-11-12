//
//  NetworkError.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// Represents network errors that can occur during an API request.
public enum NetworkError: Error {
    /// A network failure occurred, containing the underlying error.
    case networkFailure(Error)
    
    /// Invalid request body. This occurs when the request body is malformed or cannot be serialized.
    case invalidRequestBody
    
    /// No data was received from the server. This occurs when the server response does not contain any data.
    case noData
    
    /// Failed to decode the response data into the expected model.
    case decodingError(Error)
}
