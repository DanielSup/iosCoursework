//
//  ProcessAnimalInformationService.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 15/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This protocol is used for the dependency injection. This protocol ensures getting the correct information about an animal for machine reading
*/
protocol ProcessAnimalInformationServicing {
    func updateSetting(_ setting: [SaidInfo: Bool])
    func processInformationAndGetTextForMachineReading(about animal: Animal) -> String
}

/**
 This class ensures getting the correct text about an animal for mahcine reading. This class works with the actual setting of information for machine-reading.
*/
class ProcessAnimalInformationService: ProcessAnimalInformationServicing {
    /// The actual setting of the machine-read information about a close animal.
    private var setting: [SaidInfo: Bool] = [:]
    /// The spaces for a short interruption of the machine-reading.
    private let spaces: String = "                    "
    /// The repository for getting biotopes where animals live
    private let biotopeBindingRepository: BiotopeBindingRepositoring
    /// The repository for getting kinds of food which animals eat
    private let foodBindingRepository: FoodBindingRepositoring
    /// The repository for getting continents where animals live
    private let continentBindingRepository: ContinentBindingRepositoring
    
    /**
     - Parameters:
        - biotopeBindingRepository: The repository for getting biotopes where animals live
        - foodBindingRepository: The repository for getting kinds of food which animals eat
        - continentBindingRepository: The repository for getting continents where animals live
    */
    init(biotopeBindingRepository: BiotopeBindingRepositoring, foodBindingRepository: FoodBindingRepositoring, continentBindingRepository: ContinentBindingRepositoring){
        self.biotopeBindingRepository = biotopeBindingRepository
        self.foodBindingRepository = foodBindingRepository
        self.continentBindingRepository = continentBindingRepository
    }
    
    /**
     This function ensures changine the saved setting to the actual setting of machine-read information.
     - Parameters:
        - setting: The actual setting of machine-read information about a close animal.
    */
    func updateSetting(_ setting: [SaidInfo: Bool]){
        self.setting = setting
    }
    
    /**
     This function returns the whole text about the given animal which is machine-read.
     - Parameters:
     - animal: The animal which is enough close for machine-reading information about it (at other places I write that the animal is close).
    */
    func processInformationAndGetTextForMachineReading(about animal: Animal) -> String {
        var textForMachineReading: String = NSLocalizedString("thisIs", comment: "") + animal.title
        for information in SaidInfo.values {
            if (self.setting[information] == true){
                textForMachineReading += self.getTextFrom(information: information, about: animal)
            }
        }
        return textForMachineReading
    }
    
    /**
     This function returns a text for machine-reading for the given property about the given animal which is close:
     - Parameters:
        - information: The information about the close animal which is machine-read.
        - animal: The animal which is close.
    */
    private func getTextFrom(information: SaidInfo, about animal: Animal) -> String {
        switch (information){
            case .actualities:
                return self.getStringFromActualities(about: animal)
            case .description:
                return information.title + spaces + animal.description + spaces
            case .biotopes:
                return self.getStringFromBiotopes(of: animal)
            case .food:
                return self.getStringFromFood(of: animal)
            case .continents:
                return self.getStringFromContinents(of: animal)
            case .proportions:
                return information.title + spaces + animal.proportions + spaces
            case .reproduction:
                return information.title + spaces + animal.reproduction + spaces
            case .attractions:
                return information.title + spaces + animal.attractions + spaces
            case .breeding:
                return information.title + spaces + animal.breeding + spaces
        }
    }
    
    /**
     This function ensures getting the string for machine-reading from the list of actualities about the given animal.
     - Parameters:
        - animal: The given animal which is close.
    */
    private func getStringFromActualities(about animal: Animal) -> String{
        if(animal.actualities.count == 0){
            return ""
        }
        var actualitiesString: String = SaidInfo.actualities.title + spaces
        for actuality in animal.actualities {
            actualitiesString += actuality.title + spaces
            actualitiesString += actuality.perex + spaces
            actualitiesString += actuality.textOfArticle + spaces
        }
        return actualitiesString
    }

    
    /**
     This function returns the string for machine-reading from the list of biotopes where tha animal lives.
     - Parameters:
        - animal: The given animal which is close.
    */
    private func getStringFromBiotopes(of animal: Animal) -> String {
        let biotopeBindings = self.biotopeBindingRepository.findBindingsWithAnimal(animal: animal.id)
        var biotopeArray: [Biotope] = []
        for biotopeBinding in biotopeBindings!{
            let biotopeId = Int(biotopeBinding.biotope)
            let biotope = Biotope.getBiotopeWithId(id: biotopeId!)
            biotopeArray.append(biotope)
        }
        
        var biotopeString: String = SaidInfo.biotopes.title + spaces
        for biotope in biotopeArray{
            biotopeString += biotope.title + " "
        }
        return biotopeString
    }
    
    
    /**
     This function returns the string for machine-reading from the list of kinds of food which the animal eats.
     - Parameters:
     - animal: The given animal which is close.
     */
    private func getStringFromFood(of animal: Animal) -> String {
        let foodBindings = self.foodBindingRepository.findBindingsWithAnimal(animal: animal.id)
        var foodArray: [Food] = []
        for foodBinding in foodBindings! {
            let foodId = Int(foodBinding.food)
            let food = Food.getFoodWithId(id: foodId!)
            foodArray.append(food)
        }
        
        var foodString: String = SaidInfo.food.title + spaces
        for food in foodArray {
            foodString += food.title + " "
        }
        return foodString
    }
    
    
    /**
     This function returns the string for machine-reading from the list of continent where tha animal lives.
     - Parameters:
     - animal: The given animal which is close.
     */
    private func getStringFromContinents(of animal: Animal) -> String {
        let continentBindings = self.continentBindingRepository.findBindingsWithAnimal(animal: animal.id)
        var continentArray: [Continent] = []
        for continentBinding in continentBindings! {
            let continentId = Int(continentBinding.continent)
            let continent = Continent.getContinentWithId(id: continentId!)
            continentArray.append(continent)
        }
        
        var continentString: String = SaidInfo.continents.title + spaces
        for continent in continentArray {
            continentString += continent.title + " "
        }
        return continentString
    }
}
