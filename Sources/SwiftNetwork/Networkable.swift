//
//  Networkable.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

public protocol Networkable: Endpoint {}
public extension Networkable {
    /**
     Performs the network request and decodes the response into a specified type.
     
     This method sends the request to the server, handles the response, and attempts to decode the response into the expected type `T`.
     If an error occurs during the request or decoding, it calls the completion handler with an error result.
     
     - Parameters:
     - completion: A closure that takes a `Result<T, NetworkError>` where `T` is the expected response model type.
     
     - Important: This method uses a background thread for the network request and should be called from the main thread when updating the UI with the results.
     */
    func perform<T: Decodable>(request completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        if let request = request {
            SwiftNetwork()
                .perform(request, completion)
                .resume()
            return
        }
        
        perform(request: method, completion)
    }
    
    func perform<T: Decodable>(request method: HTTPMethod, _ completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        guard let url = url else {
            // Return an error if the URL is invalid
            completion(.failure(.networkFailure(NSError(domain: "Invalid URL", code: -1, userInfo: nil))))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = defaultHeaders()?.merging(headers ?? [:]) { (_, new) in new }
        
        if let parameters = parameters, (method == .POST || method == .PUT) {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        // Check if the httpBody is nil if the HTTP Method is POST OR PUT, skip early.
        if method == .POST || method == .PUT {
            if request.httpBody == nil {
                completion(.failure(.invalidRequestBody))
                return
            }
        }
        
        SwiftNetwork()
            .perform(request, completion)
            .resume()
    }
    
    func fetch<T: Decodable>( _ completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        perform(request: .GET, completion)
    }
    
    func sync<T: Decodable>( _ completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        perform(request: .POST, completion)
    }
    
    func update<T: Decodable>( _ completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        perform(request: .PUT, completion)
    }
    
    func delete<T: Decodable>( _ completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        perform(request: .DELETE, completion)
    }
}
