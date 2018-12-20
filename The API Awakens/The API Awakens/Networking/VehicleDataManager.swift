//
//  VehicleDataManager.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/14/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct VehicleDataManager {
    private static func fetch(url: URL, completion: @escaping (Result<HandlePages<Vehicle>>) -> Void) {
        Networker.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                guard let pagedResponse = try? JSONDecoder.starWarsApiDecoder.decode(HandlePages<Vehicle>.self, from: data) else {
                    return
                }
                completion(.success(pagedResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func fetch(with page: Int, completion: @escaping (Result<[Vehicle]>) -> Void) {
        fetch(url: Endpoint.vehicles.url(with: page)) { result in
            switch result {
            case .success(let result):
                completion(.success(result.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getVehicles(completion: @escaping (Result<[Vehicle]>) -> Void) {
        var resultArray = [Vehicle]()
        func handle(result: Result<HandlePages<Vehicle>>) {
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
        fetch(url: Endpoint.vehicles.url(with: 1), completion: handle)
    }
}
