//
//  Networkable+Actor.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

@available(iOS 13.0, macOS 10.15, *)
public extension Networkable {
    /**
     Performs the network request and decodes the response into a specified type.
     
     This method sends the request to the server, handles the response, and attempts to decode the response into the expected type `T`.
     If an error occurs during the request or decoding, it calls the completion handler with an error result.
     
     - Parameters:
     - completion: A closure that takes a `Result<T, NetworkError>` where `T` is the expected response model type.
     
     - Important: This method uses a background thread for the network request and should be called from the main thread when updating the UI with the results.
     */
    func perform<T: Decodable>() async -> Result<T, NetworkError> {
        if let request = request {
            return await SwiftNetworkActor().perform(request)
        }
        
        return await perform(request: method)
    }
    
    private func perform<T: Decodable>(request method: HTTPMethod) async -> Result<T, NetworkError> {
        switch buildRequest {
        case .success(let request):
            return await SwiftNetworkActor().perform(request)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetch<T: Decodable>() async -> Result<T, NetworkError> {
        await perform(request: .GET)
    }
    
    func sync<T: Decodable>() async -> Result<T, NetworkError> {
        await perform(request: .POST)
    }
    
    func update<T: Decodable>() async -> Result<T, NetworkError> {
        await perform(request: .PUT)
    }
    
    func delete<T: Decodable>() async -> Result<T, NetworkError> {
        await perform(request: .DELETE)
    }
}
