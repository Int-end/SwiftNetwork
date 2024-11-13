//
//  SwiftNetwork+Actor.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

// NetworkManager that works for both iOS 12 and below (class) and iOS 13+ (actor)
@available(iOS 13.0, macOS 12.0, *)
actor SwiftNetworkActor {
    private let session = URLSession.shared
    
    // Asynchronous network request for iOS 13 and above using actor
    func perform<T: Decodable>(_ request: URLRequest) async -> Result<T, NetworkError> {
        do {
            let (data, response) = try await session.data(for: request)
            return await handleResponse(data: data, response: response)
        } catch {
            return .failure(.networkFailure(error))
        }
    }

    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) async -> Result<T, NetworkError> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.networkFailure(NSError(domain: "Invalid Response", code: -1, userInfo: nil)))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorDomain = (400...499).contains(httpResponse.statusCode) ? "Client Error" : "Server Error"
            return .failure(.networkFailure(NSError(domain: errorDomain, code: httpResponse.statusCode, userInfo: nil)))
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedResponse)
        } catch {
            return .failure(.decodingError(error))
        }
    }
}
