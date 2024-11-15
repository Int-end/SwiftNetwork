
import Foundation
import Combine

/// A class responsible for executing network requests and processing the responses.
struct SwiftNetwork {
    func perform<T: Decodable>(_ request: URLRequest, _ completion: @escaping (Result<T, NetworkError>) -> Void) {
        // Perform the network request asynchronously
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.response(data: data, error: error, response: response, completion: completion)
        }
        .resume()
    }
    
    /// Processes the server's response and decodes the data into the desired model.
    ///
    /// - Parameters:
    ///   - data: The raw response data.
    ///   - response: The URL response.
    ///   - completion: A closure that returns the decoded result or an error.
    func response<T: Decodable>(data: Data?, error: Error?, response: URLResponse?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        if let error = error {
            if let error = error as? URLError,
               error.code == .timedOut {
                completion(.failure(.timeout(error)))
                return
            }
            
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
