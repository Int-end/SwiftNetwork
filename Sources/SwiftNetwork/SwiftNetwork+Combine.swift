//
//  SwiftNetwork+Combine.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation
import Combine

@available(iOS 13.0, macOS 10.15, *)
extension SwiftNetwork {
    /// Perform a network request and return a Combine publisher.
        ///
        /// - Parameters:
        ///   - request: The URLRequest to be performed.
        /// - Returns: A `Future` publisher that emits the result of the network request.
    func perform<T: Decodable>(_ request: URLRequest) -> Future<T, NetworkError> {
        return Future { promise in
            perform(request) { (result: Result<T, NetworkError>) in
                switch result {
                case .success(let item):
                    return promise(.success(item))
                case .failure(let error):
                    return promise(.failure(error))
                }
            }
        }
    }
}
