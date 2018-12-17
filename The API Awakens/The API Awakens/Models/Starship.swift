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
    let costInCredits: String
    let length: String
    let starshipClass: String
    let crew: String
}
