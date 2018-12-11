//
//  Starship.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/11/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Starship: Transportation, Codable {
    let name: String
    let model: String
    let cost: Int
    let length: Int
    let type: String
    let crew: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case model = "model"
        case cost = "cost_in_credits"
        case length = "length"
        case type = "starship_class"
        case crew = "crew"
    }
}
