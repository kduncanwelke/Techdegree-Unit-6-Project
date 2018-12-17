//
//  Transportation.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/11/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

protocol Transportation {
    var name: String { get }
    var model: String { get }
    var costInCredits: String { get }
    var length: String { get }
    var crew: String { get }
}
