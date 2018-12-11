//
//  Endpoint.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/11/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

enum StarWarsApi {
    case people
    case starships
    case vehicles
}

extension StarWarsApi: Endpoint {
    var base: String {
        return "https://swapi.co/api"
    }
    
    var path: String {
        switch self {
        case .people:
            return "/people/"
        case .starships:
            return "/starships/"
        case .vehicles:
            return "/vehicles/"
        }
    }
}
