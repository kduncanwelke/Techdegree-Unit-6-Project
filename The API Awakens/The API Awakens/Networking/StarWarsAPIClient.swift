//
//  Networking.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/13/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

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
    typealias PeopleCompletionHandler = ([Person]?, DataError?) -> Void

    
     func retrievePeople(with endpoint: Endpoint, completionHandler completion: @escaping PersonCompletionHandler) {
        
        let request = endpoint.request
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, DataError.requestFailed)
                        return
                    }
                    if httpResponse.statusCode == 200 {
                        do {
                            let people = try self.decoder.decode([Person].self, from: data)
                            completion(people, nil)
                        } catch _ {
                            completion(nil, DataError.jsonConversionFailure)
                        }
                    } else {
                        completion(nil, DataError.invalidData)
                    }
                } else if error != nil {
                    completion(nil, DataError.badResponse)
                }
            }
        }
        
        task.resume()
    }

    func getPeople(completionHandler completion: @escaping PeopleCompletionHandler) {
        retrievePeople(with: StarWarsApi.people) { people, error in
            completion(people, error)
        }
    }

}
