import Foundation

/// Base protocol defining common network service functionality
protocol NetworkServiceBase {
    // MARK: - Configuration
    typealias Configuration = NetworkConfiguration
    
    // MARK: - Properties
    var configuration: Configuration { get }
    var session: URLSession { get }
    
    // MARK: - Initialization
    init(configuration: Configuration)
    
    // MARK: - Response Handling
    func handleResponse<T: Decodable>(data: Data?, 
                                    response: URLResponse?, 
                                    error: Error?) -> Result<T, NetworkError>
    
    func handleError<T>(_ error: Error) -> Result<T, NetworkError>
    func handleHTTPError<T>(statusCode: Int) -> Result<T, NetworkError>
    func decodeResponse<T: Decodable>(_ data: Data) -> Result<T, NetworkError>
}

/// Protocol for completion handler based network service
protocol NetworkService: NetworkServiceBase {
    func perform<T: Decodable>(_ request: URLRequest, 
                              _ completion: @escaping (Result<T, NetworkError>) -> Void)
}

/// Protocol for async/await based network service
@available(iOS 13.0, macOS 10.15, *)
protocol AsyncNetworkService: NetworkServiceBase, Actor {
    func perform<T: Decodable>(_ request: URLRequest) async -> Result<T, NetworkError>
}

// MARK: - Default Implementation
extension NetworkServiceBase {
    func handleResponse<T: Decodable>(data: Data?, 
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
    
    func handleError<T>(_ error: Error) -> Result<T, NetworkError> {
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
    
    func handleHTTPError<T>(statusCode: Int) -> Result<T, NetworkError> {
        switch statusCode {
        case 400...499:
            return .failure(.clientError(statusCode: statusCode))
        case 500...599:
            return .failure(.serverError(statusCode: statusCode))
        default:
            return .failure(.invalidStatusCode(statusCode))
        }
    }
    
    func decodeResponse<T: Decodable>(_ data: Data) -> Result<T, NetworkError> {
        do {
            let decoded = try configuration.decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(.decodingError(error))
        }
    }
}
