//
//  Person.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/11/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Person: Decodable {
    let name: String
    let birthday: String
    let homeWorld: String
    let height: String
    let eyeColor: String
    let hairColor: String
    //let species: [Species]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case birthday = "birth_year"
        case homeWorld = "homeworld"
        case height = "height"
        case eyeColor = "eye_color"
        case hairColor = "hair_color"
        // case species = "species"
    }
}











