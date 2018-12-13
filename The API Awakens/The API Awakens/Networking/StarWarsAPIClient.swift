//
//  Networking.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/13/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

enum Endpoint {
    case people(Int)
    case starship(Int)
    case vehicle(Int)
    case planet(Int)
    
    func getUrl() -> String {
        switch self {
            case .people(let page): return "people/?page=\(page)"
            case .starship(let page): return "starships/?page=\(page)"
            case .vehicle(let page): return "people/?page=\(page)"
            case .planet(let index): return "planets/\(index)"
        }
    }
}

class StarWarsApiClient {
    let baseUrl = "https://swapi.co/api/"
    let decoder = JSONDecoder()
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    typealias PersonCompletionHandler = ([Person]?, DataError?) -> Void
    typealias CurrentWeatherCompletionHandler = ([Person]?, DataError?) -> Void
    
    private func getPeople(completionHandler completion: @escaping PersonCompletionHandler) {
        
        guard let url = baseUrl + Endpoint.getUrl() else {
            completion(nil, DataError.invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, DataError.requestFailed)
                        return
                    }
                    if httpResponse.statusCode == 200 {
                        do {
                            let person = try self.decoder.decode(Person.self, from: data)
                            completion(person, nil)
                        } catch let error {
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, DataError.invalidData)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    
}
