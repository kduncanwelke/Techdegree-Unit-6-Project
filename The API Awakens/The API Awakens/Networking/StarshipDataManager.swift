//
//  StarshipDataManager.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/14/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct StarshipDataManager {
    static func getStarships(with page: Int, completion: @escaping (Result<HandlePages<Starship>>) -> Void) {
        Networker.getUrl(endpoint: Endpoint.starships.url(with: page)) { result in
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
}
