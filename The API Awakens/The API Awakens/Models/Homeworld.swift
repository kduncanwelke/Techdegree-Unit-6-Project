//
//  Homeworld.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/12/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Homeworld {
    let name: String
}

extension Homeworld {
    init?(json: [String: Any]) {
        
        struct Keys {
            static let name = "name"
        }
        
        guard let homeName = json[Keys.name] as? String else {
            return nil
        }
        
        self.init(name: homeName)
    }
}
