//
//  BaseLexiconViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 24/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the base of all screens in the lexicon part of the application. It ensures finding results in the top searchbar for finding animals anywhere in the lexicon.
*/
class BaseLexiconViewModel: BaseViewModel {
    typealias Dependencies = HasAnimalRepository & HasClassRepository & HasLocalityRepository
    /// The object with dependencies important for getting all possible screens where the user can go.
    private var dependencies: Dependencies
    
    // MARK - Actions
    
    /**
     This action finds all animals, biotopes, classes and orders of animals. The list of all screens in the lexicon consists of all animals, lists of animals in orders, lists of orders in classes, list of animals in pavilions, lists of animals in biotopes, list of biotopes, list of classes and list of pavilions. It returns the list of all possible screens in the lexicon part of the application where the user can go.
    */
    lazy var getAllScreens = Action<(), [Screen], LoadError>{
        var screens: [Screen] = []
        
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
        self.dependencies.classRepository.loadAndSaveDataIfNeeded()
        self.dependencies.localityRepository.loadAndSaveDataIfNeeded()
        
        if let animals = self.dependencies.animalRepository.entities.value as? [Animal] {
            for animal in animals {
                let screenToAdd = Screen(title: animal.title, animal: animal, classOrOrder: nil, continent: nil, biotope: nil, kindOfFood: nil,  pavilion: nil)
                screens.append(screenToAdd)
            }
        } else {
            return SignalProducer(error: LoadError.noAnimals)
        }
        
        
        if let classes = self.dependencies.classRepository.entities.value as? [Class] {
            for classOfAnimals in classes {
                var screenTitle = classOfAnimals.type ==  "class" ? L10n.orderList : L10n.animalsInOrderList
                screenTitle += " " + classOfAnimals.title
                
                let screenToAdd = Screen(title: screenTitle, animal: nil, classOrOrder: classOfAnimals, continent: nil, biotope: nil, kindOfFood: nil, pavilion: nil)
                screens.append(screenToAdd)
            }
        } else {
            return SignalProducer(error: LoadError.noClasses)
        }
        
        /// adding screens with lists of animals living in a continent or list of animals which don't live anywhere in nature.
        for i in 1...7 {
            let continent = Continent.getContinentWithId(id: i)
            let animalListTitle = L10n.animalList + " " + continent.locativeWithPreposition
            let screenToAdd = Screen(title: animalListTitle, animal: nil, classOrOrder: nil, continent: continent, biotope: nil, kindOfFood: nil, pavilion: nil)
            screens.append(screenToAdd)
        }
    
        /// adding screens with list of animals living in a biotope
        for i in 1...11 {
            let biotope = Biotope.getBiotopeWithId(id: i)
            let animalListTitle = L10n.animalList + " " + biotope.locativeWithPreposition
            let screenToAdd = Screen(title: animalListTitle, animal: nil, classOrOrder: nil, continent: nil, biotope: biotope, kindOfFood: nil, pavilion: nil)
            screens.append(screenToAdd)
        }
        
        /// adding screen with list of animals eating a kind of food.
        for i in 1...9 {
            let kindOfFood = Food.getFoodWithId(id: i)
            let animalListTitle = L10n.listOfAnimalsEating + " " + kindOfFood.instrumentalOfTitle
            let screenToAdd = Screen(title: animalListTitle, animal: nil, classOrOrder: nil, continent: nil, biotope: nil, kindOfFood: kindOfFood, pavilion: nil)
            screens.append(screenToAdd)
        }
        
        if let localities = self.dependencies.localityRepository.entities.value as? [Locality] {
            for locality in localities {
                let listOfAnimalsInLocalityTitle = L10n.animalsInLocality + " " + locality.title
                let screenToAdd = Screen(title: listOfAnimalsInLocalityTitle, animal: nil, classOrOrder: nil, continent: nil, biotope: nil, kindOfFood: nil, pavilion: locality)
                screens.append(screenToAdd)
            }
        } else {
            return SignalProducer(error: LoadError.noLocalities)
        }
        
        
        let classListScreen = Screen(title: L10n.classList, animal: nil, classOrOrder: nil, continent: nil, biotope: nil, kindOfFood: nil, pavilion: nil)
        screens.append(classListScreen)
        
        let continentsScreen = Screen(title: L10n.continents, animal: nil, classOrOrder: nil, continent: nil, biotope: nil, kindOfFood: nil, pavilion: nil)
        screens.append(continentsScreen)
        
        let biotopesScreen = Screen(title: L10n.biotopes, animal: nil, classOrOrder: nil, continent: nil, biotope: nil, kindOfFood: nil, pavilion: nil)
        screens.append(biotopesScreen)
        
        let kindsOfFoodScreen = Screen(title: L10n.kindsOfFood, animal: nil, classOrOrder: nil, continent: nil, biotope: nil, kindOfFood: nil, pavilion: nil)
        screens.append(kindsOfFoodScreen)
        
        let pavilionsScreen = Screen(title: L10n.pavilions, animal: nil, classOrOrder: nil, continent: nil, biotope: nil, kindOfFood: nil, pavilion: nil)
        screens.append(pavilionsScreen)
        
        return SignalProducer(value: screens)
    }
    
    // MARK - Constructor
    
    /**
     - Parameters:
        - dependencies: The object with important dependencies for getting the list of all possible screens in the lexicon part of the application.
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
}
