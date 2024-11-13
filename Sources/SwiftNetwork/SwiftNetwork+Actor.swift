//
//  SwiftNetwork+Actor.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation

/// A class responsible for executing network requests and processing the responses.
///
/// This class performs network requests using `URLSession` and processes the responses to decode the data into the desired model. It supports both synchronous and asynchronous requests.
@available(iOS 13.0, macOS 12.0, *)
actor SwiftNetworkActor {
    private let session = URLSession.shared

    /// Performs the network request and returns a Combine `Future` publisher.
    ///
    /// - Parameters:
    ///   - request: The URLRequest to be performed.
    /// - Returns: A `Future` publisher that emits the result of the network request.
    func perform<T: Decodable>(_ request: URLRequest) async -> Result<T, NetworkError> {
        do {
            let (data, response) = try await session.data(for: request)
            return await handleResponse(data: data, response: response)
        } catch {
            return .failure(.networkFailure(error))
        }
    }

    /// Handles the response and attempts to decode the data into the desired model.
    ///
    /// - Parameters:
    ///   - data: The data returned from the server.
    ///   - response: The URL response.
    /// - Returns: A result containing either the decoded response or a network error.
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
