# SwiftNetwork

A modern, protocol-oriented networking library for Swift that provides a clean, type-safe API with support for multiple request styles.

## Version History

### Version 0.0.2 (Current)
- 🔄 Added unified `NetworkOperations` protocol
- ⚡️ Added actor-based implementation for thread safety
- 🎯 Enhanced type-safe endpoint configuration
- 🌍 Added environment-based configuration
- 📝 Added comprehensive DocC documentation

### Version 0.0.1 (Initial)
- ✅ Basic networking functionality
- ✅ Multiple request styles support
- ✅ Protocol-oriented architecture
- ✅ Error handling
- ✅ Response decoding

## Key Features

- **Multiple Request Styles**
  - Completion handlers for traditional usage
  - Async/await for modern Swift concurrency
  - Combine publishers for reactive programming

- **Type Safety & Architecture**
  - Protocol-oriented design
  - Type-safe endpoints
  - Thread-safe operations with actors
  - Comprehensive error handling

- **Configuration & Flexibility**
  - Environment-based configuration
  - Customizable request/response processing
  - Automatic response decoding

## Quick Start

### Define an Endpoint

```swift
struct UserEndpoint: Endpoint {
    let path = "/users"
    let environment: EnvironmentConfigurable
    
    var parameters: [String: QueryStringConvertible]? {
        ["page": page, "limit": limit]
    }
    
    private let page: Int
    private let limit: Int
    
    init(environment: EnvironmentConfigurable = Environment.development,
         page: Int = 1,
         limit: Int = 20) {
        self.environment = environment
        self.page = page
        self.limit = limit
    }
}
```

### Make Requests

```swift
// Using completion handlers
endpoint.perform { (result: Result<[User], NetworkError>) in
    switch result {
    case .success(let users):
        print("Users: \(users)")
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Using async/await
let result = await endpoint.perform()
switch result {
case .success(let users):
    print("Users: \(users)")
case .failure(let error):
    print("Error: \(error)")
}

// Using Combine
endpoint.perform()
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("Error: \(error)")
            }
        },
        receiveValue: { users in
            print("Users: \(users)")
        }
    )
    .store(in: &cancellables)
```

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SwiftNetwork.git", from: "0.0.2")
]
```

## Advanced Usage

### Custom Configuration

```swift
let config = NetworkConfiguration(
    timeoutInterval: 60,
    sessionConfiguration: {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return config
    }(),
    decoder: {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
)
```

### Environment Configuration

```swift
struct ProductionEnvironment: EnvironmentConfigurable {
    let baseURL = "https://api.example.com"
    let apiKey: String
}

let endpoint = UserEndpoint(
    environment: ProductionEnvironment(apiKey: "YOUR_API_KEY")
)
```

## Requirements

- iOS 13.0+ / macOS 10.15+
- Swift 5.5+
- Xcode 13.0+

## Documentation

For detailed API documentation and examples, visit our [API Reference](docs/API.md).

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md).

## License

SwiftNetwork is available under the MIT license. See the [LICENSE](LICENSE) file.
