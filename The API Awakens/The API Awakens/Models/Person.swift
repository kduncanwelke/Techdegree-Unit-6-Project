//
//  Person.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/11/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Person {
    let name: String
    let birthday: String
    let homeWorld: String
    let height: String
    let eyeColor: String
    let hairColor: String
    //let species: [Species]
}

extension Person {
    init?(json: [String: Any]) {
        
        struct Keys {
            static let name = "name"
            static let birthday = "birth_year"
            static let homeWorld = "homeworld"
            static let height = "height"
            static let eyeColor = "eye_color"
            static let hairColor = "hair_color"
           // static let species = "species"
        }
        
       guard let personName = json[Keys.name] as? String,
        let personBirthday = json[Keys.birthday] as? String,
        let personHomeWorld = json[Keys.homeWorld] as? String,
        let personHeight = json[Keys.height] as? String,
        let personEyeColor = json[Keys.eyeColor] as? String,
        let personHairColor = json[Keys.hairColor] as? String//,
        //let personSpecies = json[Keys.species] as? [Species]
        else {
            return nil
        }
        
         self.init(name: personName, birthday: personBirthday, homeWorld: personHomeWorld, height: personHeight, eyeColor: personEyeColor, hairColor: personHairColor)
    }
}











