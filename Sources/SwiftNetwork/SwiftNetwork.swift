
import Foundation
import Combine

import Foundation
import Combine

/// A networking layer that handles HTTP requests and response processing using completion handlers.
struct SwiftNetwork {
    // MARK: - Configuration
    struct Configuration {
        let timeoutInterval: TimeInterval
        let sessionConfiguration: URLSessionConfiguration
        let decoder: JSONDecoder
        
        static var `default`: Configuration {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 30
            
            return Configuration(
                timeoutInterval: 30,
                sessionConfiguration: config,
                decoder: JSONDecoder()
            )
        }
    }
    
    // MARK: - Properties
    private let configuration: Configuration
    private let session: URLSession
    
    // MARK: - Initialization
    init(configuration: Configuration = .default) {
        self.configuration = configuration
        self.session = URLSession(configuration: configuration.sessionConfiguration)
    }

    // MARK: - Network Operations
    func perform<T: Decodable>(_ request: URLRequest,
                              _ completion: @escaping (Result<T, NetworkError>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            let result: Result<T, NetworkError> = self.handleResponse(data: data,
                                                                    response: response,
                                                                    error: error)
            completion(result)
        }
        .resume()
    }
    
    // MARK: - Response Handling
    private func handleResponse<T: Decodable>(data: Data?,
                                            response: URLResponse?,
                                            error: Error?) -> Result<T, NetworkError> {
        if let error = error {
            return handleError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return handleHTTPError(statusCode: httpResponse.statusCode)
        }
        
        guard let data = data else {
            return .failure(.noData)
        }
        
        return decodeResponse(data)
    }
    
    // MARK: - Helper Methods
    private func handleError<T>(_ error: Error) -> Result<T, NetworkError> {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut:
                return .failure(.timeout(urlError))
            case .notConnectedToInternet:
                return .failure(.noConnection)
            case .cancelled:
                return .failure(.cancelled)
            default:
                return .failure(.networkFailure(urlError))
            }
        }
        return .failure(.networkFailure(error))
    }
    
    private func handleHTTPError<T>(statusCode: Int) -> Result<T, NetworkError> {
        switch statusCode {
        case 400...499:
            return .failure(.clientError(statusCode: statusCode))
        case 500...599:
            return .failure(.serverError(statusCode: statusCode))
        default:
            return .failure(.invalidStatusCode(statusCode))
        }
    }
    
    private func decodeResponse<T: Decodable>(_ data: Data) -> Result<T, NetworkError> {
        do {
            let decoded = try configuration.decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(.decodingError(error))
        }
    }
}
