//
//  SwiftNetwork+Actor.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation
import Combine

/// A networking layer that handles HTTP requests and response processing using async/await.
@available(iOS 13.0, macOS 10.15, *)
actor SwiftNetworkActor: AsyncNetworkService {
    // MARK: - Properties
    nonisolated let configuration: Configuration
    nonisolated let session: URLSession
    
    // MARK: - Initialization
    init(configuration: Configuration = .default) {
        self.configuration = configuration
        self.session = URLSession(configuration: configuration.sessionConfiguration)
    }

    // MARK: - Network Operations
    func perform<T: Decodable>(_ request: URLRequest) async -> Result<T, NetworkError> {
        do {
            let (data, response) = try await session.data(for: request)
            return handleResponse(data: data,
                               response: response,
                               error: nil)
        } catch {
            return .failure(.networkFailure(error))
        }
    }
}

