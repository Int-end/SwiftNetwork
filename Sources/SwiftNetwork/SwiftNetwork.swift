
import Foundation
import Combine

/// A class responsible for executing network requests and processing the responses.
@available(iOS, deprecated: 13.0, message: "Use actor-based NetworkManager for iOS 13+")
struct SwiftNetwork {
    let session = URLSession.shared
    
    func perform<T: Decodable>(_ request: URLRequest, _ completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) -> URLSessionDataTask {
        // Perform the network request asynchronously
        session.dataTask(with: request) { data, response, error in
            self.response(data: data, error: error, response: response, completion: completion)
        }
    }
    
    /// Processes the server's response and decodes the data into the desired model.
    ///
    /// - Parameters:
    ///   - data: The raw response data.
    ///   - response: The URL response.
    ///   - completion: A closure that returns the decoded result or an error.
    func response<T: Decodable>(data: Data?, error: Error?, response: URLResponse?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        if let error = error {
            completion(.failure(.networkFailure(error)))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(.networkFailure(NSError(domain: "Invalid Response", code: -2, userInfo: nil))))
            return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorDomain = (400...499).contains(httpResponse.statusCode) ? "Client Error" : "Server Error"
            completion(.failure(.networkFailure(NSError(domain: errorDomain, code: httpResponse.statusCode, userInfo: nil))))
            return
        }
        
        guard let data = data else {
            completion(.failure(.noData))
            return
        }
        
        // Attempt to decode the response data into the specified model
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedResponse))
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
}
