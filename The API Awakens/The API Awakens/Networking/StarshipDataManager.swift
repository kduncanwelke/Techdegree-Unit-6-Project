//
//  StarshipDataManager.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/14/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct StarshipDataManager {
    private static func fetch(url: URL, completion: @escaping (Result<HandlePages<Starship>>) -> Void) {
        Networker.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                guard let pagedResponse = try? JSONDecoder.starWarsApiDecoder.decode(HandlePages<Starship>.self, from: data) else {
                    return
                }
                completion(.success(pagedResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func fetch(with page: Int, completion: @escaping (Result<[Starship]>) -> Void) {
        fetch(url: Endpoint.starships.url(with: page)) { result in
            switch result {
            case .success(let result):
                completion(.success(result.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getStarships(completion: @escaping (Result<[Starship]>) -> Void) {
        var resultArray = [Starship]()
        func handle(result: Result<HandlePages<Starship>>) {
            switch result {
            case .success(let response):
                resultArray.append(contentsOf: response.results)
                if let nextURL = response.next {
                    fetch(url: nextURL, completion: handle)
                } else {
                    completion(.success(resultArray))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        fetch(url: Endpoint.starships.url(with: 1), completion: handle)
    }
    
    static func findLargestAndSmallestTransport(input: [Transportation]) -> (Transportation?, Transportation?) {
        let sorted = input.sorted(by: { if let length1 = Int($0.length), let length2 = Int($1.length) {
            return length1 > length2
            }
            return true
        })
        let largest = sorted.first
        let smallest = sorted.last
        
        return (largest, smallest)
    }

}
