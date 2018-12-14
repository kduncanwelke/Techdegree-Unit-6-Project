//
//  PageManager.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/14/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct HandlePages<T: Codable>: Codable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [T]
}

