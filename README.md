# SwiftNetwork

SwiftNetwork is a lightweight, easy-to-use framework for making network requests in iOS, macOS, watchOS, and tvOS applications. It simplifies the process of sending HTTP requests, managing headers, body parameters, and handling responses. It supports Swift 5.5 and is compatible with iOS 12+.

In future releases, **macOS**, **tvOS**, and **watchOS** support will be enhanced for better integration and usability across all platforms.

## What's New?

- **Test cases have been added** to ensure the robustness and reliability of the framework. These tests validate key features such as network requests, error handling, and response decoding.
- **Network requests** are now available via multiple methods: **Wrapper**, **Combine**, and **Actor-based** approaches, giving you flexibility depending on your app’s architecture and concurrency model.

## Why This Library?

Choosing the right way to perform network requests in iOS can be tricky, especially when dealing with multiple versions of iOS and varying app architectures. **SwiftNetwork** simplifies this process by **encapsulating the decision-making** around which network request method to use based on the iOS version and your app's specific context.

This library is designed to **seamlessly adapt to your app architecture**, whether you're targeting **iOS 12 and below** or **iOS 13 and above**. **SwiftNetwork** supports multiple approaches for network requests, allowing you to use **completion blocks**, **reactive programming** with **Combine**, or **modern async/await syntax**, all with the same API.

### Key Benefits:
- **Adaptability**: The library automatically adapts to the app's architecture, whether it uses legacy syntax (e.g., completion blocks), modern **decorative syntax** with **Combine**, or **inline syntax** with **async/await**. 
  - For apps targeting **iOS 12 and below**, it defaults to the **Wrapper** approach (completion-based).
  - For **iOS 13 and above**, it offers support for **Combine** and **Actor-based async/await**.
- **Unified API**: Regardless of which approach you choose, the API remains the same. This means you don't need to learn multiple ways to use the same functionality. Whether you're calling **Fetch**, **Sync**, **Update**, or **Delete**, the method names are consistent with standard HTTP methods (`GET`, `POST`, `PUT`, and `DELETE`), making the API **more readable** and intuitive.

### Example:
- **Fetch** for **GET** requests
- **Sync** for **POST** requests
- **Update** for **PUT** requests
- **Delete** for **DELETE** requests

These symbolic method names make the code more **human-readable** and **self-documenting**, reducing cognitive load and improving developer experience. You can use the same API syntax, regardless of whether you're dealing with legacy or modern approaches.

By using **SwiftNetwork**, you eliminate the risk of choosing the wrong method for your app's network requests and ensure that the architecture will evolve smoothly as your app grows and as iOS evolves.

## Features

- Supports `GET`, `POST`, `PUT`, and `DELETE` HTTP methods.
- Easy-to-use protocol for defining API endpoints.
- Built-in handling for headers, body parameters, and authentication.
- Decoding responses into custom model objects.
- Handles common network errors, including network failure, decoding failure, and invalid request bodies.
- Configurable environment with support for different base URLs and API keys.
- **Test cases** to ensure proper functionality and reliability.
- **Support for network requests via Wrapper, Combine, and Actor-based** approaches.

## Test Cases

Test cases have been added to ensure that the core functionality of the SwiftNetwork framework works as expected. These tests validate the network request handling, error management, and response decoding.

### Running the Tests

To run the test cases, follow the steps below:

1. **Install dependencies** (if using a package manager like Swift Package Manager):
    - If you're using Xcode, open the `.xcodeproj` or `.xcworkspace` file.
    - If you're using a terminal, make sure you have all dependencies set up:
    ```bash
    swift package update
    ```

2. **Run the tests**:
   - In Xcode, simply press `Cmd + U` to run the tests.
   - Alternatively, you can run tests using the command line with Swift Package Manager:
     ```bash
     swift test
     ```

These tests cover various components, such as:
- Sending network requests with different HTTP methods.
- Handling successful and failed responses.
- Decoding JSON into custom model objects.
- Managing request errors (e.g., invalid URLs, missing data, etc.).

## Installation

### Swift Package Manager (SPM)

To integrate SwiftNetwork into your project, you can use Swift Package Manager.

1. Open your Xcode project.
2. Navigate to `File` -> `Add Packages`.
3. Paste the following URL into the search bar:  
   `https://github.com/your-username/SwiftNetwork.git`
4. Select the version you want to integrate (you can choose the latest release).
5. Add the package to your project.

Alternatively, you can add the package manually to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/SwiftNetwork.git", from: "1.0.0")
]
```

## Usage

### 1. Create a Custom Endpoint

You can create a custom API endpoint by conforming to the `Requestable` protocol. Define your endpoint's HTTP method, path, headers, and body parameters.

```swift
import SwiftNetwork

struct SignInEndpoint: Requestable {
    var path: String = "/auth/signin"
    var method: HTTPMethod = .POST
    var headers: [String: String]? = nil
    var parameters: [String: Any]? = [
        "username": "user",
        "password": "password123"
    ]
    
    var environment: EnvironmentConfigurable
    
    init(environment: EnvironmentConfigurable) {
        self.environment = environment
    }
}
```

### 2. Set Up the Environment

The `Environment` struct provides the base URL and API key for your network requests. You can create different environments for different stages of your app (e.g., development, production).

```swift
let environment = Environment(baseURL: "https://api.example.com", apiKey: "your-api-key")
```

### 3. Perform a Request

Once you have defined your endpoint and environment, you can call the `perform` method to make the network request and decode the response. SwiftNetwork now supports three approaches for performing network requests, each suited for different iOS versions and use cases:

#### 3.1 **Wrapper-Based Network Request**

This method is ideal for **iOS versions below 13** and uses a closure-based approach for simple network requests.

```swift
let signIn = SignInEndpoint(environment: environment, body: ["username": "", "password: ******"])

signIn.perform { (result: Result<User, NetworkError>) in
    switch result {
    case .success(let user):
        print("User signed in: \(user)")
    case .failure(let error):
        print("Error occurred: \(error)")
    }
}
```

#### 3.2 **Combine-Based Network Request** (Recommended for **iOS 13+**)

For **iOS 13+**, you can use **Combine** to handle network responses reactively. This approach is perfect for **decorative syntax** and when you want to leverage reactive patterns.

```swift
import Combine

var cancellables = Set<AnyCancellable>()

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
```

#### 3.3 **Actor-Based Network Request** (Thread-safe, **iOS 13+** and **macOS 10.15+**)

For **iOS 13+** and **macOS 10.15+**, use the **Actor-based** approach to ensure thread safety. This approach is perfect for **concurrent tasks** and modern async/await workflows.

```swift
if #available(iOS 13.0, macOS 10.15, *) {
    // Use the actor-based version
    Task {
        let result: Result<User, NetworkError> = await signIn.fetch(request)
        // Handle result
    }
}
```

### 4. Handling Response Data

The `perform` method will automatically decode the response into the specified model type (`T` in this case). If the response is invalid or the network request fails, the completion handler will return a `NetworkError`.

Example model for decoding a response:

```swift
struct User: Decodable {
    let id: String
    let name: String
    let email: String
}
```

### 5. Customizing Headers

You can customize the headers for each request. If no headers are provided, the default headers will be used, including the `Authorization` header if the `apiKey` is set in the environment.

```swift
var customHeaders: [String: String] = [
    "Custom-Header": "CustomValue"
]
```

### 6. Error Handling

`NetworkError` is used to handle different types

 of errors:

- `.networkFailure`: There was a problem with the network request (e.g., no internet connection).
- `.invalidRequestBody`: The body parameters could not be serialized into JSON.
- `.noData`: No data was returned from the server.
- `.decodingError`: The response data could not be decoded into the expected model.

You can handle errors as shown in the sample above by checking the `Result` returned from `perform`.

## Sample Project

Check out the sample project in the `Sample/` folder to see how the framework works in a real iOS project.

## Documentation

You can find the full documentation for this framework [here](https://github.com/your-username/SwiftNetwork/docs).

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature/YourFeature`).
6. Create a new Pull Request.

## License

SwiftNetwork is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
