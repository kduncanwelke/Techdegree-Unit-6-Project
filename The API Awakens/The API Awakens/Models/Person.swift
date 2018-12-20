//
//  Person.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/11/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Person: Codable {
    let name: String
    let birthYear: String?
    let gender: String?
    let height: String
    let eyeColor: String
    let hairColor: String?
    let homeworld: URL?
    let starships: [URL]?
    let vehicles: [URL]?
    let species: [URL]?
}











