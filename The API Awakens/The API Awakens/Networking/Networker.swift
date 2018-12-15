//
//  Networking.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/13/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Networker {
    private static let session = URLSession(configuration: .default)
    
    static func getUrl(endpoint: URL, completion: @escaping (Result<Data>) -> Void) {
        fetchData(url: endpoint, completion: completion) 
    }
    
    static func fetchData(url: URL, completion: @escaping (Result<Data>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                }
            }
        }
        task.resume()
    }
}
