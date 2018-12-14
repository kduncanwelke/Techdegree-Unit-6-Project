//
//  Endpoint.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/13/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

enum Endpoint {
    case people
    case starships
    case vehicles
    
    private var baseURL: URL {
        return URL(string: "https://swapi.co/api/")!
    }
    
    func url(with page: Int) -> URL {
        switch self {
        case .people:
            var components = URLComponents(url: baseURL.appendingPathComponent("people"), resolvingAgainstBaseURL: false)
            components!.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
            return components!.url!
        case .starships:
            var components = URLComponents(url: baseURL.appendingPathComponent("starships"), resolvingAgainstBaseURL: false)
            components!.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
            return components!.url!
        case .vehicles:
            var components = URLComponents(url: baseURL.appendingPathComponent("vehicles"), resolvingAgainstBaseURL: false)
            components!.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
            return components!.url!
        }
    }
}

