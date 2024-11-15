//
//  Networkable.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// A protocol that extends `Endpoint` to allow networkable requests to be performed.
///
/// Example usage:
/// ```Swift
/// struct MyNetworkable: Networkable {
///     var path: String = "/user/profile"
///     var method: HTTPMethod = .GET
///     var environment: EnvironmentConfigurable
///     var request: URLRequest? = nil
/// }
/// ```
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
    func perform<T: Decodable>(request completion: @escaping (Result<T, NetworkError>) -> Void) {
        if let request = request {
            SwiftNetwork()
                .perform(request, completion)
            return
        }
        
        perform(request: method, completion)
    }
    
    func perform<T: Decodable>(request method: HTTPMethod, _ completion: @escaping (Result<T, NetworkError>) -> Void) {
        switch buildRequest {
        case .success(let request):
            SwiftNetwork()
                .perform(request, completion)
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func fetch<T: Decodable>( _ completion: @escaping (Result<T, NetworkError>) -> Void) {
        perform(request: .GET, completion)
    }
    
    func sync<T: Decodable>( _ completion: @escaping (Result<T, NetworkError>) -> Void) {
        perform(request: .POST, completion)
    }
    
    func update<T: Decodable>( _ completion: @escaping (Result<T, NetworkError>) -> Void) {
        perform(request: .PUT, completion)
    }
    
    func delete<T: Decodable>( _ completion: @escaping (Result<T, NetworkError>) -> Void) {
        perform(request: .DELETE, completion)
    }
}
