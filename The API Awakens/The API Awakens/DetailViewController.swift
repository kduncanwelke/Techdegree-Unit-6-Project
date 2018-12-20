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
    
    
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    
    
    var selectedCategory: SelectedType?
    
    var peopleResults: [Person]?
    var starshipResults: [Starship]?
    var vehicleResults: [Vehicle]?

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
        
        detail3.text = person.height
        detail4.text = person.eyeColor
        detail5.text = person.hairColor
        
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
            PeopleDataManager.getPeople() { result in
                switch result {
                case .success(let response):
                    print(response)
                    self.peopleResults = response
                    self.updateDataForPerson(with: response[0])
                    
                    // load home and species for first item separately to prevent weird display with loop spitting out data
                    PeopleDataManager.getHomeworld(for: response[0]) { result in
                        if let result = result {
                            switch result {
                            case .success(let home):
                                self.detail2.text = home.name
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    
                    PeopleDataManager.getSpecies(for: response[0]) { result in
                        if let result = result {
                            switch result {
                            case .success(let species):
                                self.detail6.text = species.name
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    
                    for person in response {
                        PeopleDataManager.getHomeworld(for: person) { result in
                            if let result = result {
                                switch result {
                                case .success(let home):
                                    print(home)
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }
                    }
                    for person in response {
                        PeopleDataManager.getSpecies(for: person) { result in
                            if let result = result {
                                switch result {
                                case .success(let species):
                                     print(species)
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
            StarshipDataManager.getStarships() { result in
                switch result {
                case .success(let response):
                    self.starshipResults = response
                    self.updateDataForStarship(with: response[0])
                    self.picker.reloadAllComponents()
                case .failure(let error):
                    print(error)
                }
            }
        case .vehicles:
            VehicleDataManager.getVehicles() { result in
                switch result {
                case .success(let response):
                    self.vehicleResults = response
                    self.updateDataForVehicle(with: response[0])
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
        
        // start with metric button disabled because data comes in metric form
        metricButton.isEnabled = false
        
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
    
    // MARK: Actions
    
    @IBAction func convertToInches(_ sender: UIButton) {
        guard let number = Double(detail3.text!) else { return }
        let result = number * 2.54
        detail3.text = String(describing: result)
        
        englishButton.isEnabled = false
        metricButton.isEnabled = true
    }
    
    @IBAction func convertToCentimeters(_ sender: UIButton) {
        guard let number = Double(detail3.text!) else { return }
        let result = number / 2.54
        detail3.text = String(describing: result)
        
        metricButton.isEnabled = false
        englishButton.isEnabled = true
    }
    
}
