//
//  SignInEndpoint.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

// 1. Create a Custom Endpoint
// You can create a custom API endpoint by conforming to the `Endpoint` protocol. Define your endpoint's HTTP method, path, headers, and body parameters.
struct SignInEndpoint: Endpoint {
    var path: String = "/auth/signin"
    var method: HTTPMethod = .POST
    var headers: [String: String]? = nil
    var bodyParameters: [String: Any]? = [
        "username": "user",
        "password": "password123"
    ]
    
    var environment: EnvironmentConfigurable
    
    init(environment: EnvironmentConfigurable) {
        self.environment = environment
    }
}
