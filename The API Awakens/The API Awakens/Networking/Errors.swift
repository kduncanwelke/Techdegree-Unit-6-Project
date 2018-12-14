//
//  Errors.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/11/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

enum DataError: Error {
    case invalidUrl
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case badResponse
}
