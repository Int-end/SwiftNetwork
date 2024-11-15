//
//  Networkable+Combine.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import Foundation
import Combine

@available(iOS 13.0, macOS 10.15, *)
public extension Networkable {
    func perform<T: Decodable>() -> Future<T, NetworkError> {
        if let request = request {
            return SwiftNetwork().perform(request)
        }
        
        return perform(request: method)
    }
    
    func perform<T: Decodable>(request method: HTTPMethod) -> Future<T, NetworkError> {
        switch buildRequest {
        case .success(let request):
            return SwiftNetwork()
                .perform(request)
        case .failure(let error):
            return Future { promise in
                promise(.failure(error))
            }
        }
    }
    
    func fetch<T: Decodable>() -> Future<T, NetworkError> {
        perform(request: .GET)
    }
    
    func sync<T: Decodable>() -> Future<T, NetworkError> {
        perform(request: .POST)
    }
    
    func update<T: Decodable>() -> Future<T, NetworkError> {
        perform(request: .PUT)
    }
    
    func delete<T: Decodable>() -> Future<T, NetworkError> {
        perform(request: .DELETE)
    }
}
