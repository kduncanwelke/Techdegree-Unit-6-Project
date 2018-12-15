//
//  ViewController.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/11/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var selectedType: SelectedType?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*PeopleDataManager.getPeople(with: 1) { result in
            switch result {
            case .success(let response):
                for person in response.results {
                    print(person)
                    PeopleDataManager.getHomeworld(for: person) { result in
                        if let result = result {
                            switch result {
                            case .success(let home):
                                print(home.name)
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
                for person in response.results {
                    PeopleDataManager.getSpecies(for: person) { result in
                        if let result = result {
                            switch result {
                            case .success(let species):
                                print(species.name)
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Actions

    @IBAction func categorySelected(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            selectedType = SelectedType.characters
        case 1:
            selectedType = SelectedType.vehicles
        case 2:
            selectedType = SelectedType.starships
        default:
            break
        }
        performSegue(withIdentifier: "goToDetailView", sender: (Any).self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailViewController {
            let destinationViewController = segue.destination as? DetailViewController
            destinationViewController?.selectedCategory = selectedType
        }
    }
}

