//
//  ViewController.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/11/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       let client = StarWarsApiClient()
       /* client.retrievePeople { people, error in
            print(people)
        }*/
        
        let url = URL(fileReferenceLiteralResourceName: "https://swapi.co/api/planets/1/")
        
        client.retrieveHomeworld(homeURL: url) { home, error in
           print("something happened")
        }
        
       // let result = StarWarsApi.people
       // print(result.request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

