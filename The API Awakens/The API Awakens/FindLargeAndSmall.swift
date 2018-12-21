//
//  FindLargeAndSmall.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/20/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

func findTallestAndShortestPerson(input: [Person]) -> (Person?, Person?) {
    let sorted = input.sorted(by: { if let height1 = Int($0.height), let height2 = Int($1.height) {
        return height1 > height2
        }
        return true
    })
    let tallest = sorted.first
    let shortest = sorted.last
    
    return (tallest, shortest)
}


func findLargestAndSmallestTransport(input: [Transportation]) -> (Transportation?, Transportation?) {
    let sorted = input.sorted(by: { if let length1 = Int($0.length), let length2 = Int($1.length) {
        return length1 > length2
        }
        return true
    })
    let largest = sorted.first
    let smallest = sorted.last
    
    return (largest, smallest)
}
