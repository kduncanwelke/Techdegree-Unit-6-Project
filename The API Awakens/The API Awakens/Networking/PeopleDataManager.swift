//
//  PeopleDataManager.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/14/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct PeopleDataManager {
    private static func fetch(url: URL, completion: @escaping (Result<HandlePages<Person>>) -> Void) {
        Networker.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                guard let pagedResponse = try? JSONDecoder.starWarsApiDecoder.decode(HandlePages<Person>.self, from: data) else {
                    return
                }
                completion(.success(pagedResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func fetch(with page: Int, completion: @escaping (Result<[Person]>) -> Void) {
        fetch(url: Endpoint.people.url(with: page)) { result in
            switch result {
                case .success(let result):
                    completion(.success(result.results))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    static func getPeople(completion: @escaping (Result<[Person]>) -> Void) {
        var resultArray = [Person]()
        func handle(result: Result<HandlePages<Person>>) {
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
        fetch(url: Endpoint.people.url(with: 1), completion: handle)
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
        if let species = person.species {
            if species.isEmpty != true {
                Networker.fetchData(url: species[0]) { result in
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
            } else {
                completion(nil)
            }
        }
    }
    
    static func getPersonVehicles(for person: Person, completion: @escaping (Result<[String]>?) -> Void) {
        if let vehicles = person.vehicles {
            if vehicles.isEmpty != true {
                var vehicleNames = [String]()
                var i = 0
                for vehicle in vehicles {
                    Networker.fetchData(url: vehicle) { result in
                        switch result {
                        case .success(let response):
                            guard let vehicle = try? JSONDecoder.starWarsApiDecoder.decode(Vehicle.self, from: response) else { return }
                            vehicleNames.append(vehicle.name)
                            i += 1
                            
                            if i == vehicles.count {
                                completion(.success(vehicleNames))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    }
    
    static func getPersonStarships(for person: Person, completion: @escaping (Result<[String]>?) -> Void) {
        if let starships = person.starships {
            if starships.isEmpty != true {
                var starshipNames = [String]()
                var i = 0
                for starship in starships {
                    Networker.fetchData(url: starship) { result in
                        switch result {
                        case .success(let response):
                            guard let starship = try? JSONDecoder.starWarsApiDecoder.decode(Starship.self, from: response) else { return }
                            starshipNames.append(starship.name)
                            i += 1
                            
                            if i == starships.count {
                                completion(.success(starshipNames))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    }
    
    static func findTallestAndShortestPerson(input: [Person]) -> (Person?, Person?) {
        let sorted = input.sorted(by: { if let height1 = Int($0.height), let height2 = Int($1.height) {
            return height1 > height2
            }
            return true
        })
        let tallest = sorted.first
        let shortest = sorted.last
        
        return (tallest, shortest)
    }

}
