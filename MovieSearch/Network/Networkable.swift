//
//  Networkable.swift
//  MovieSearch
//
//  Created by RAJEEV MAHAJAN on 27/02/25.
//

import Foundation

protocol Networkable {
    func sendRequest<T: Decodable> (endpoint: Endpoint, completion: @escaping ((Result<T,Error>) -> Void))
}

public final class NetworkManager: Networkable {
    private init() {}
    public static let shared = NetworkManager()
    func sendRequest<T: Decodable>(endpoint: Endpoint, completion: @escaping ((Result<T, Error>) -> Void)) {
        guard let request = makeRequest(endpoint: endpoint) else {
            return completion(.failure(NSError(domain: "Invalid URL", code: 100, userInfo: nil)))
        }
        let task = URLSession.shared.dataTask(with: request) { data, respose, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            guard let response = respose as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                return
            }
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                if let result = try? decoder.decode(T.self, from: data) {
                    return completion(.success(result))
                }
            } catch {
                print("Error Decoding")
            }
        }
        task.resume()
    }
}

extension NetworkManager {
    private func makeRequest(endpoint: Endpoint) -> URLRequest?{
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.baseUrl
        urlComponents.path = endpoint.path
        if let queryParams = endpoint.queryItems {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents.url else {
            print( "Failed to create URL")
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        return urlRequest
    }
}
