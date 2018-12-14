//
//  PeopleDataManager.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/14/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct PeopleDataManager {
    static func getPeople(with page: Int, completion: @escaping (Result<HandlePages<Person>>) -> Void) {
        Networker.getUrl(endpoint: Endpoint.people.url(with: page)) { result in
            switch result {
            case .success(let data):
                guard let people = try? JSONDecoder.starWarsApiDecoder.decode(HandlePages<Person>.self, from: data) else {
                    return
                }
                completion(.success(people))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getHomeworld(for person: Person, completion: @escaping (Result<Homeworld>?) -> Void) {
        if let homeURL = person.homeworld {
            Networker.fetchData(url: homeURL) { result in
                switch result {
                case .success(let data):
                    guard let home = try? JSONDecoder.starWarsApiDecoder.decode(Homeworld.self, from: data) else {
                        return
                    }
                    completion(.success(home))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(nil)
        }
    }
    
    static func getSpecies(for person: Person, completion: @escaping (Result<Species>?) -> Void) {
        let speciesList = person.species
        
        for species in speciesList {
            Networker.fetchData(url: species) { result in
                switch result {
                case .success(let data):
                    guard let species = try? JSONDecoder.starWarsApiDecoder.decode(Species.self, from: data) else {
                        return
                    }
                    completion(.success(species))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
}
