//
//  NetworkRequest.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import SwiftNetwork

struct NetworkRequest {
    func perform() {
        // 2. Set Up the Environment
        let environment = Environment(baseURL: "https://api.example.com", apiKey: "your-api-key")

        // 3. Perform a Request
        let signIn = SignInEndpoint(environment: environment)

        signIn.performRequest { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let user):
                print("User signed in: \(user)")
            case .failure(let error):
                print("Error occurred: \(error)")
            }
        }
    }
}
