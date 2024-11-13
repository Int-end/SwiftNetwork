//
//  SignInEndpoint.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

// 1. Create a Custom Endpoint
// You can create a custom API endpoint by conforming to the `Endpoint` protocol. Define your endpoint's HTTP method, path, headers, and body parameters.
struct SignInEndpoint: Requestable {
    let path: String = "/auth/signin"
    let method: HTTPMethod = .POST
    let parameters: [String: Any]?
    
    let environment: EnvironmentConfigurable
    
    init(environment: EnvironmentConfigurable, body parameters: [String: QueryStringConvertible]) {
        self.parameters = parameters
        self.environment = environment
    }
}
