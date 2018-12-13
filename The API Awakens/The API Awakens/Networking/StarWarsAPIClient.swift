//
//  StarWarsAPIClient.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/11/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

class StarWarsApiClient {
    let downloader = JSONDownloader()
    
    func retrievePeople(completion: @escaping ([Person], DataError?) -> Void) {
        let endpoint = StarWarsApi.people
        
        performRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion([], error)
                return
            }
            
            let people = results.flatMap { Person(json: $0) }
            
            completion(people, nil)
        }
    }
    
    func retrieveHomeworld(homeURL: URL, completion: @escaping (Homeworld?, DataError?) -> Void) {
        let endpoint = URLRequest(url: homeURL)
    
        
        let task = downloader.jsonTask(with: endpoint) { json, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                guard let home = Homeworld(json: json) else {
                    completion(nil, .jsonConversionFailure)
                    return
                }
                
                completion(home, nil)
            }
        }
        task.resume()
       
    }
    
    typealias Results = [[String: Any]]
    
    private func performRequest(with endpoint: Endpoint, completion: @escaping (Results?, DataError?) -> Void) {
        
        let task = downloader.jsonTask(with: endpoint.request) { json, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                guard let results = json["results"] as? [[String: Any]] else {
                    completion(nil, .jsonConversionFailure)
                    return
                }
                
                completion(results, nil)
            }
        }
        
        task.resume()
    }
}
