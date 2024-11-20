import Foundation

/// Configuration for network services
public struct NetworkConfiguration {
    let timeoutInterval: TimeInterval
    let sessionConfiguration: URLSessionConfiguration
    let decoder: JSONDecoder
    
    static var `default`: NetworkConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        
        return NetworkConfiguration(
            timeoutInterval: 30,
            sessionConfiguration: config,
            decoder: JSONDecoder()
        )
    }
}
