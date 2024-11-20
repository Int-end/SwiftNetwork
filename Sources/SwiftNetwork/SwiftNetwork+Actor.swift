//
//  SwiftNetwork+Actor.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation
import Combine

/// A networking layer that handles HTTP requests and response processing using async/await.
///
/// This actor provides a modern interface for making network requests and handling responses
/// using Swift's structured concurrency, available on iOS 13 and above.
///
/// Example usage:
/// ```swift
/// let actor = SwiftNetworkActor()
/// let result: Result<User, NetworkError> = await actor.perform(request)
///
/// switch result {
/// case .success(let user):
///     print("User: \(user)")
/// case .failure(let error):
///     print("Error: \(error)")
/// }
/// ```
@available(iOS 13.0, macOS 10.15, *)
actor SwiftNetworkActor {
    /// The maximum time interval to wait for a network request to complete.
    private let timeoutInterval: TimeInterval
    
    /// The URLSession instance configured with the specified timeout interval.
    private let session: URLSession
    
    /// Initializes a new SwiftNetworkActor instance.
    ///
    /// - Parameter timeoutInterval: The maximum duration (in seconds) to wait for a network request
    ///                             to complete before timing out. Defaults to 30 seconds.
    init(timeoutInterval: TimeInterval = 30) {
        self.timeoutInterval = timeoutInterval
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        self.session = URLSession(configuration: configuration)
    }

    /// Performs a network request and decodes the response into the specified type.
    ///
    /// - Parameter request: The URLRequest to be performed.
    /// - Returns: A Result containing either the decoded response or an error.
    func perform<T: Decodable>(_ request: URLRequest) async -> Result<T, NetworkError> {
        do {
            let (data, response) = try await session.data(for: request)
            return await self.response(data: data, 
                                     error: nil, 
                                     response: response)
        } catch {
            return .failure(.networkFailure(error))
        }
    }
    
    /// Processes the network response and attempts to decode it into the specified type.
    ///
    /// - Parameters:
    ///   - data: The response data from the server.
    ///   - error: Any error that occurred during the network request.
    ///   - response: The URLResponse from the server.
    /// - Returns: A Result containing either the decoded response or an error.
    private func response<T: Decodable>(data: Data?, 
                                      error: Error?, 
                                      response: URLResponse?) async -> Result<T, NetworkError> {
        if let error = error {
            if let error = error as? URLError,
               error.code == .timedOut {
                return .failure(.timeout(error))
            }
            
            return .failure(.networkFailure(error))
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.networkFailure(NSError(domain: "Invalid Response", 
                                                  code: -2, 
                                                  userInfo: nil)))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorDomain = (400...499).contains(httpResponse.statusCode) ? "Client Error" : "Server Error"
            return .failure(.networkFailure(NSError(domain: errorDomain, 
                                                  code: httpResponse.statusCode, 
                                                  userInfo: nil)))
        }
        
        guard let data = data else {
            return .failure(.noData)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedResponse)
        } catch {
            return .failure(.decodingError(error))
        }
    }
}
