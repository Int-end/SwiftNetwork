//
//  NetworkRequest.swift
//  SwiftNetwork
//
//  Created by Sijo Thomas on 13/11/24.
//

import SwiftNetwork

struct NetworkRequest {
    var cancellables = Set<AnyCancellable>()
    
    mutating func perform() {
        // 2. Set Up the Environment
        let environment = Environment(baseURL: "https://api.example.com", apiKey: "your-api-key")

        // 3.1 Perform a Request
        let signIn = SignInEndpoint(environment: environment, body: ["username": "", "password: ******"])
        
        signIn.perform { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let user):
                print("User signed in: \(user)")
            case .failure(let error):
                print("Error occurred: \(error)")
            }
        }
        
        // 3.2 Perform a Request More Readable Way
        signIn.fetch { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let user):
                print("User signed in: \(user)")
            case .failure(let error):
                print("Error occurred: \(error)")
            }
        }
        
        // 3.3 Perform a Request in Combine Way
        signIn.fetch()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Request completed successfully.")
                case .failure(let error):
                    print("Request failed with error: \(error.description)")
                }
            }, receiveValue: { (users: [User]) in
                print("Received users: \(users)")
            })
            .store(in: &cancellables)
        
        // 3.3 Perform a Request in Actor
        if #available(iOS 13.0, macOS 12.0, *) {
            // Use the actor-based version
            Task {
                let result: Result<User, NetworkError> = await signIn.fetch(request)
                // Handle result
            }
        }
    }
}
