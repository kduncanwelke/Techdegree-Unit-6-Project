//
//  JSONDownloader.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/11/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import Foundation

class JSONDownloader {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    typealias JSON = [String: AnyObject]
    typealias JSONTaskCompletionHandler = (JSON?, DataError?) -> Void
    
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                print("failed")
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                        completion(json, nil)
                        print("response ok")
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .badResponse)
            }
        }
        return task
    }
}
