//
//  HTTPMethod.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// HTTP methods supported by the API. These methods define how data is sent to and from the server.
///
/// Example usage:
/// ```Swift
/// let method = HTTPMethod.GET
/// ```
public enum HTTPMethod: String {
    /// GET request method, typically used for fetching data from the server.
    case GET
    
    /// POST request method, typically used for sending data to the server.
    case POST
    
    /// PUT request method, typically used for updating resources on the server.
    case PUT
    
    /// DELETE request method, typically used for deleting resources on the server.
    case DELETE
}
