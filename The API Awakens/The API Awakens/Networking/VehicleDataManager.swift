//
//  VehicleDataManager.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/14/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct VehilceDataManager {
    static func getVehicles(with page: Int, completion: @escaping (Result<HandlePages<Vehicle>>) -> Void) {
        Networker.getUrl(endpoint: Endpoint.vehicles.url(with: page)) { result in
            switch result {
            case .success(let data):
                guard let vehicles = try? JSONDecoder.starWarsApiDecoder.decode(HandlePages<Vehicle>.self, from: data) else {
                    return
                }
                completion(.success(vehicles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
