//
//  APIService.swift
//*********** ------------- Api Services implemented in this class  ---------------********//

import Foundation

class APIClient {
    private let baseURL = URL(string: "https://dummy.restapiexample.com/api/v1/employee/1")!
    private let session: URLSession
    private var retryCount = 0
    private let maxRetries = 3
    private let cache = NSCache<NSString, NSData>()

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 120 // 120 seconds timeout
        session = URLSession(configuration: config)
    }

    func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        // Check cache first
        if let cachedData = cache.object(forKey: baseURL.absoluteString as NSString) {
            completion(.success(cachedData as Data))
            return
        }

        // Perform network request
        let request = URLRequest(url: baseURL)
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            // Check for network errors
            if let error = error {
                self.handleFailure(error: error, completion: completion)
                return
            }

            // Ensure we have a valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "https://dummy.restapiexample.com", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                self.handleFailure(error: error, completion: completion)
                return
            }

            // Check the status code
            switch httpResponse.statusCode {
            case 200...299:
                // Successful response
                if let data = data {
                    self.cache.setObject(data as NSData, forKey: self.baseURL.absoluteString as NSString)
                    completion(.success(data))
                } else {
                    let error = NSError(domain: "https://dummy.restapiexample.com", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                    self.handleFailure(error: error, completion: completion)
                }

            case 400...499:
                // Client-side error
                let error = NSError(domain: "https://dummy.restapiexample.com", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Client error: \(httpResponse.statusCode)"])
                self.handleFailure(error: error, completion: completion)

            case 500...599:
                // Server-side error, retry might be appropriate
                let error = NSError(domain: "https://dummy.restapiexample.com", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error: \(httpResponse.statusCode)"])
                self.handleFailure(error: error, completion: completion)

            default:
                // Other cases, e.g., 300-series redirects or unhandled status codes
                let error = NSError(domain: "https://dummy.restapiexample.com", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected response: \(httpResponse.statusCode)"])
                self.handleFailure(error: error, completion: completion)
            }

        }.resume()
    }

    private func handleFailure(error: Error, completion: @escaping (Result<Data, Error>) -> Void) {
        if retryCount < maxRetries {
            retryCount += 1
            let delay = Double(retryCount) * 2.0 // Exponential backoff
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                self.fetchData(completion: completion)
            }
        } else {
            completion(.failure(error))
        }
    }
}
