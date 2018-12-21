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
    
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var creditButton: UIButton!
    
    @IBOutlet weak var smallNameLabel: UILabel!
    @IBOutlet weak var largeNameLabel: UILabel!
    
    
    @IBOutlet weak var shipsLabel: UILabel!
    @IBOutlet weak var vehiclesLabel: UILabel!
    
    @IBOutlet weak var associatedShipsLabel: UILabel!
    @IBOutlet weak var associatedVehiclesLabel: UILabel!
    @IBOutlet weak var associatedLabel: UILabel!
    
    
    var selectedCategory: SelectedType?
    
    var peopleResults: [Person]?
    var starshipResults: [Starship]?
    var vehicleResults: [Vehicle]?
    
    var input: Double?
    
    let alert = UIAlertController(title: "Conversion", message: "Please enter a conversion rate", preferredStyle: UIAlertController.Style.alert)

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
            detail6.isHidden = false
            
            usdButton.isHidden = true
            creditButton.isHidden = true
            
            shipsLabel.isHidden = false
            vehiclesLabel.isHidden = false
            
            associatedLabel.isHidden = false
            associatedShipsLabel.isHidden = false
            associatedVehiclesLabel.isHidden = false
        case .vehicles:
            label1.text = "Make"
            label2.text = "Cost"
            label3.text = "Length"
            label4.text = "Class"
            label5.text = "Crew"
            
            label6.isHidden = true
            detail6.isHidden = true
            
            usdButton.isHidden = false
            creditButton.isHidden = false
            
            shipsLabel.isHidden = true
            vehiclesLabel.isHidden = true
            
            associatedLabel.isHidden = true
            associatedShipsLabel.isHidden = true
            associatedVehiclesLabel.isHidden = true
        case .starships:
            label1.text = "Make"
            label2.text = "Cost"
            label3.text = "Length"
            label4.text = "Class"
            label5.text = "Crew"
            
            label6.isHidden = true
            detail6.isHidden = true
            
            usdButton.isHidden = false
            creditButton.isHidden = false
            
            shipsLabel.isHidden = true
            vehiclesLabel.isHidden = true
            
            associatedLabel.isHidden = true
            associatedShipsLabel.isHidden = true
            associatedVehiclesLabel.isHidden = true
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
        
        PeopleDataManager.getPersonVehicles(for: person) { result in
            if let result = result {
                switch result {
                case .success(let vehicles):
                    var vehiclesList = ""
                    for vehicle in vehicles {
                        vehiclesList += "\(vehicle), "
                    }
                    self.associatedVehiclesLabel.text = vehiclesList
                case .failure(let error):
                    print(error)
                }
            } else  {
                self.associatedVehiclesLabel.text = "-"
            }
        }
        
        PeopleDataManager.getPersonStarships(for: person) { result in
            if let result = result {
                switch result {
                case .success(let starships):
                    var starshipsList = ""
                    for starship in starships {
                        starshipsList += "\(starship), "
                    }
                    self.associatedShipsLabel.text = starshipsList
                case .failure(let error):
                    print(error)
                }
            } else  {
                self.associatedShipsLabel.text = "-"
            }
        }
        
        guard let people = peopleResults else { return }
        let result = findTallestAndShortestPerson(input: people)
        largeNameLabel.text = result.0?.name
        smallNameLabel.text = result.1?.name
    }
    
    func updateDataForStarship(with starship: Starship) {
        nameLabel.text = starship.name
        detail1.text = starship.model
        detail2.text = starship.costInCredits
        detail3.text = starship.length
        detail4.text = starship.starshipClass
        detail5.text = starship.crew
        
        detail6.isHidden = true
        
        guard let starships = starshipResults else { return }
        let result = findLargestAndSmallestTransport(input: starships)
        largeNameLabel.text = result.0?.name
        smallNameLabel.text = result.1?.name
    }
    
    func updateDataForVehicle(with vehicle: Vehicle) {
        nameLabel.text = vehicle.name
        detail1.text = vehicle.model
        detail2.text = vehicle.costInCredits
        detail3.text = vehicle.length
        detail4.text = vehicle.vehicleClass
        detail5.text = vehicle.crew
        
        detail6.isHidden = true
        
        guard let vehicles = vehicleResults else { return }
        let result = findLargestAndSmallestTransport(input: vehicles)
        largeNameLabel.text = result.0?.name
        smallNameLabel.text = result.1?.name
    }
    
    func updateView(category: SelectedType) {
        switch category {
        case .characters:
            PeopleDataManager.getPeople() { result in
                switch result {
                case .success(let response):
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
                    
                    PeopleDataManager.getPersonVehicles(for: response[0]) { result in
                        if let result = result {
                            switch result {
                            case .success(let vehicles):
                                var vehiclesList = ""
                                for vehicle in vehicles {
                                    vehiclesList += "\(vehicle), "
                                }
                                self.associatedVehiclesLabel.text = vehiclesList
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    
                    PeopleDataManager.getPersonStarships(for: response[0]) { result in
                        if let result = result {
                            switch result {
                            case .success(let starships):
                                var starshipsList = ""
                                for starship in starships {
                                    starshipsList += "\(starship), "
                                }
                                self.associatedShipsLabel.text = starshipsList
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
                    self.showAlert(title: "Network error", message: DataError.badResponse.localizedDescription)
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
                    self.showAlert(title: "Network error", message: DataError.badResponse.localizedDescription)
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
                    self.showAlert(title: "Network error", message: DataError.badResponse.localizedDescription)
                }
            }
        }
        
    }

    func checkConversionInput(textInput: String) throws {
        guard let number = Double(textInput) else {
            throw CostConversion.invalidInput
        }
        self.input = number
        
        if number == 0 || number < 0 {
            throw CostConversion.zeroOrNegativeInput
        }
        
        if self.usdButton.isEnabled == false {
            guard let input = self.input else { return }
            guard let credits = Double(self.detail2.text!) else { return }
            let result = credits / input
            
            self.detail2.text = String(describing: result)
        } else if self.creditButton.isEnabled == false {
            guard let input = self.input else { return }
            guard let usd = Double(self.detail2.text!) else { return }
            let result = usd * input
            
            self.detail2.text = String(describing: result)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists
            guard let textInput = textField?.text else { return }
            
            do {
                try self.checkConversionInput(textInput: textInput)
            } catch CostConversion.invalidInput {
                self.showAlert(title: "Conversion failed", message: CostConversion.invalidInput.localizedDescription)
            } catch CostConversion.zeroOrNegativeInput {
                self.showAlert(title: "Invalid input", message: CostConversion.zeroOrNegativeInput.localizedDescription)
            } catch let error {
                print("\(error)")
            }
        }))
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter a number"
        }
      
        // start with metric and credit button disabled because data comes in these forms
        metricButton.isEnabled = false
        creditButton.isEnabled = false
        
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
    
    
    @IBAction func convertToUSD(_ sender: UIButton) {
        creditButton.isEnabled = true
        usdButton.isEnabled = false
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func convertToCredits(_ sender: UIButton) {
        usdButton.isEnabled = true
        creditButton.isEnabled = false
        self.present(alert, animated: true, completion: nil)
    }
    
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
