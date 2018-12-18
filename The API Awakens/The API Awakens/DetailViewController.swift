//
//  DetailViewController.swift
//  The API Awakens
//
//  Created by Kate Duncan-Welke on 12/15/18.
//  Copyright © 2018 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    
    @IBOutlet weak var picker: UIPickerView!
    
    
    var selectedCategory: SelectedType?
    
    var peopleResults: [Person]?
    var starshipResults: [Starship]?
    var vehicleResults: [Vehicle]?
    
    let dummyData = ["skgg", "kagff", "dhfkg"]
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
                    self.peopleResults = response.results
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
                    self.picker.reloadAllComponents()
                case .failure(let error):
                    print(error)
                }
            }
        case .starships:
            StarshipDataManager.getStarships(with: 1) { result in
                switch result {
                case .success(let response):
                    self.starshipResults = response.results
                    self.updateDataForStarship(with: response.results[0])
                    self.picker.reloadAllComponents()
                case .failure(let error):
                    print(error)
                }
            }
        case .vehicles:
            VehilceDataManager.getVehicles(with: 1) { result in
                switch result {
                case .success(let response):
                    self.vehicleResults = response.results
                    self.updateDataForVehicle(with: response.results[0])
                    self.picker.reloadAllComponents()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        picker.delegate = self
        picker.dataSource = self
        
        guard let category = selectedCategory else { return }
        
        self.title = String(describing: category.rawValue)
        
        updateLabels(category: category)
        
        updateView(category: category)
      
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let selectedCategory = selectedCategory else { return 0 }
        
            switch selectedCategory {
            case .characters:
                guard let result = peopleResults?.count else { return 0 }
                return result
            case .starships:
                guard let result = starshipResults?.count else { return 0 }
                return result
            case .vehicles:
                guard let result = vehicleResults?.count else { return 0 }
                return result
            }
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let selectedCategory = selectedCategory else {
            return nil
        }
        
        switch selectedCategory {
        case .characters:
            guard let result = peopleResults else { return nil }
            return result[row].name
        case .starships:
            guard let result = starshipResults else { return nil }
            return result[row].name
        case .vehicles:
            guard let result = vehicleResults else { return nil }
            return result[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let selectedCategory = selectedCategory else {
            return
        }
        
        switch selectedCategory {
        case .characters:
            guard let result = peopleResults else { return }
            updateDataForPerson(with: result[row])
        case .starships:
            guard let result = starshipResults else { return }
            updateDataForStarship(with: result[row])
        case .vehicles:
            guard let result = vehicleResults else { return }
            updateDataForVehicle(with: result[row])
        }
    }
}