//
//  NetworkManagerCompletion.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 24/01/25.
//

import Foundation


protocol NetworkManagerCompletionProtocol {
    func fetchData<T:Codable>(for endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}



class NetworkManagerCompletion: NetworkManagerCompletionProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    func fetchData<T: Codable>(for endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NetworkErrors.invalidURL))
            return
        }

        let request = URLRequest(url: url)
        session.dataTask(with: request) { [weak self] data, response, error in
            self?.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    
    private func handleResponse<T: Codable>(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NetworkErrors.invalidData))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NetworkErrors.invalidResponse))
            return
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(NetworkErrors.serverError(statusCode: httpResponse.statusCode)))
            return
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data) 
            completion(.success(decodedData))
        } catch {
            completion(.failure(NetworkErrors.decodingError(error)))
        }
    }
}

