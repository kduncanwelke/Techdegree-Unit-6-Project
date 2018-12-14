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
    let costInCredits: Int
    let length: Int
    let starshipClass: String
    let crew: Int
}
