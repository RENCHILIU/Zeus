//
//  NetworkService.swift
//  Zeus
//
//  Created by Renchi Liu on 3/29/25.
//

import Foundation

//TODO: dynamic model
class NetworkService {
    func fetchPosts(baseURL: String, offset: Int = 0, completion: @escaping (Result<[Post], Error>) -> Void) {
        let urlString = "\(baseURL)?o=\(offset)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
