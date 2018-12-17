//
//  DetailViewController.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/15/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    @IBOutlet weak var detail1: UILabel!
    @IBOutlet weak var detail2: UILabel!
    @IBOutlet weak var detail3: UILabel!
    @IBOutlet weak var detail4: UILabel!
    @IBOutlet weak var detail5: UILabel!
    @IBOutlet weak var detail6: UILabel!
    
    
    var selectedCategory: SelectedType?
    
    //  MARK: Custom functions
    
    func updateLabels(category: SelectedType) {
        guard let selectedCategory = selectedCategory else { return }
        switch selectedCategory {
        case .characters:
            label1.text = "Born"
            label2.text = "Home"
            label3.text = "Height"
            label4.text = "Eyes"
            label5.text = "Hair"
            label6.text = "Species"
            
            label6.isHidden = false
        case .vehicles, .starships:
            label1.text = "Make"
            label2.text = "Cost"
            label3.text = "Length"
            label4.text = "Class"
            label5.text = "Crew"
            
            label6.isHidden = true
        }
    }
    
    func updateDataForPerson(with person: Person) {
        nameLabel.text = person.name
        detail1.text = person.birthYear
        detail3.text = person.height
        detail4.text = person.eyeColor
        detail5.text = person.hairColor
        
        detail6.isHidden = false
    }
    
    func updateDataForStarship(with starship: Starship) {
        nameLabel.text = starship.name
        detail1.text = starship.model
        detail2.text = starship.costInCredits
        detail3.text = starship.length
        detail4.text = starship.starshipClass
        detail5.text = starship.crew
        
        detail6.isHidden = true
    }
    
    func updateDataForVehicle(with vehicle: Vehicle) {
        nameLabel.text = vehicle.name
        detail1.text = vehicle.model
        detail2.text = vehicle.costInCredits
        detail3.text = vehicle.length
        detail4.text = vehicle.vehicleClass
        detail5.text = vehicle.crew
        
        detail6.isHidden = true
    }
    
    func updateView(category: SelectedType) {
        switch category {
        case .characters:
            PeopleDataManager.getPeople(with: 1) { result in
                switch result {
                case .success(let response):
                    self.updateDataForPerson(with: response.results[0])
                    
                    for person in response.results {
                        PeopleDataManager.getHomeworld(for: person) { result in
                            if let result = result {
                                switch result {
                                case .success(let home):
                                    self.detail2.text = home.name
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
                                    self.detail6.text = species.name
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .starships:
            StarshipDataManager.getStarships(with: 1) { result in
                switch result {
                case .success(let response):
                    self.updateDataForStarship(with: response.results[0])
                case .failure(let error):
                    print(error)
                }
            }
        case .vehicles:
            VehilceDataManager.getVehicles(with: 1) { result in
                switch result {
                case .success(let response):
                    self.updateDataForVehicle(with: response.results[0])
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let category = selectedCategory else { return }
        
        self.title = String(describing: category.rawValue)
        
        updateLabels(category: category)
        
        updateView(category: category)
      
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    }
}
