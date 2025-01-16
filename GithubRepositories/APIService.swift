//
//  APIService.swift
//  GithubRepositories
//
//  Created by Prudhvi on 1/15/25.
//

import Foundation
import Combine

class APIService {
    static let shared = APIService()
    private init() {}
    
    func fetchRepositories(username: String, page: Int = 1) -> AnyPublisher<[Repository], Error> {
        // Construct URL string
        let urlString = "\(Constants.baseURL)users/\(username)/repos?per_page=20&page=\(page)"
        
        // Guard to create a valid url
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        print("Fetching URL: \(url)") // Debugging line
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                if response.statusCode != 200 {
                    print("HTTP error: \(response.statusCode)")
                    throw URLError(.init(rawValue: response.statusCode))
                }
                return result.data
            }
            .handleEvents(receiveOutput: { data in
                // Debug: Print raw response data
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)") //Debug JSON
                }
            })
            .decode(type: [Repository].self, decoder: JSONDecoder()) // Decode JSON to Repository array
            .mapError { error -> Error in
                // Map decoding errors for better debugging
                return error
            }
            .receive(on: DispatchQueue.main) // Return results on main thread 
            .eraseToAnyPublisher()
    }
}
