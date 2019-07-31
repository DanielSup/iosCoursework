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
    lazy var getAllScreensAction = Action<(), [Screen], LoadError>{
        var screens: [Screen] = []
        
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
        self.dependencies.classRepository.loadAndSaveDataIfNeeded()
        self.dependencies.localityRepository.loadAndSaveDataIfNeeded()
        
        if let animals = self.dependencies.animalRepository.entities.value as? [Animal] {
            for animal in animals {
                let screenToAdd = Screen(title: animal.title, animal: animal, biotope: nil, classOrOrder: nil, pavilion: nil)
                screens.append(screenToAdd)
            }
        } else {
            return SignalProducer(error: LoadError.noAnimals)
        }
        
        
        if let classes = self.dependencies.classRepository.entities.value as? [Class] {
            for classOfAnimals in classes {
                var screenTitle = classOfAnimals.type ==  "class" ? NSLocalizedString("orderList", comment: "") : NSLocalizedString("animalsInOrderList", comment: "")
                screenTitle += " " + classOfAnimals.title
                
                let screenToAdd = Screen(title: screenTitle, animal: nil, biotope: nil, classOrOrder: classOfAnimals, pavilion: nil)
                screens.append(screenToAdd)
            }
        } else {
            return SignalProducer(error: LoadError.noClasses)
        }
        
        
        var allBiotopes: [Biotope] = []
        for i in 1...11 {
            let animalListTitle = NSLocalizedString("animalList", comment: "") + " " + Biotope.getBiotopeWithId(id: i).locativeWithPreposition
            let screenToAdd = Screen(title: animalListTitle, animal: nil, biotope: Biotope.getBiotopeWithId(id: i), classOrOrder: nil, pavilion: nil)
            screens.append(screenToAdd)
        }
        
        
        if let localities = self.dependencies.localityRepository.entities.value as? [Locality] {
            for locality in localities {
                let listOfAnimalsInLocalityTitle = NSLocalizedString("animalsInLocality", comment: "") + " " + locality.title
                let screenToAdd = Screen(title: listOfAnimalsInLocalityTitle, animal: nil, biotope: nil, classOrOrder: nil, pavilion: locality)
                screens.append(screenToAdd)
            }
        } else {
            return SignalProducer(error: LoadError.noLocalities)
        }
        
        
        let classListScreen = Screen(title: NSLocalizedString("classList", comment: ""), animal: nil, biotope: nil, classOrOrder: nil, pavilion: nil)
        screens.append(classListScreen)
        
        let biotopesScreen = Screen(title: NSLocalizedString("biotopes", comment: ""), animal: nil, biotope: nil, classOrOrder: nil, pavilion: nil)
        screens.append(biotopesScreen)
        
        let pavilionsScreen = Screen(title: NSLocalizedString("pavilions", comment: ""), animal: nil, biotope: nil, classOrOrder: nil, pavilion: nil)
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
