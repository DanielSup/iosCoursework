//
//  AnimalsInContinentViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 30/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen with the list of animals living in the given continent or animals which don't live anywhere in nature (if the option was choosed).
*/
class AnimalsInContinentViewModel: BaseViewModel {
    typealias Dependencies = HasContinentBindingsRepository & HasAnimalRepository
    /// The object with important dependencies for getting the list of animals living in the given continent (or animals which don't live anywhere in nature if the option was choosed).
    private var dependencies: Dependencies
    /// The selected continent (or option for getting the list of animals which don't live anywhere in nature)
    private let continent: Continent
    
    
    // MARK - Actions
    
    
    /**
     This action finds bindings with the given continent for finding the list of animals. It returns a signal producer the list of animals living in the given continent (or animals not living in nature if the option was choosed). If bindings can't be loaded, it returns a signal producer with this error. If animals couldn't be loaded, it returns a signal producer with an error representing it.
    */
    lazy var getAnimalsInContinent = Action<(), [Animal], LoadError>  {
        self.dependencies.continentBindingRepository.loadAndSaveDataIfNeeded()
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
        
        if let animals = self.dependencies.animalRepository.entities.value as? [Animal] {
            var animalsInContinent: [Animal] = []
            for animal in animals {
                var isAnimalInContinent = self.isAnimalInContinent(animal: animal)
                if (isAnimalInContinent == nil) {
                    return SignalProducer(error: .noBindings)
                }
                if (isAnimalInContinent!) {
                    animalsInContinent.append(animal)
                }
            }
            return SignalProducer(value: animalsInContinent)
        } else {
            return SignalProducer(error: .noAnimals)
        }
    }
    
    
    // MARK - Constructor and other functions
    
    
    /**
     - Parameters:
        - dependencies: The object with dependencies important for getting the list of animals in continent.
        - continent: The choosed continent or the option which represents that these animals don't live anywhere in nature.
    */
    init(dependencies: Dependencies, continent: Continent){
        self.dependencies = dependencies
        self.continent = continent
        super.init()
    }
    
    
    /**
     This function returns the locative of the title of the given continent with prepositions and other words or a string representing that animals from the shown list don't live anywhere in nature.
     - Returns: The locative of the title of the continent with prepositions and other words or a string representing that animals from the shown list don't live anywhere in nature.
     */
    func getLocativeOfContinentWithPreposition() -> String {
        return self.continent.locativeWithPreposition
    }
    
    /**
     This function returns whether the animal lives in the continent (or whether it is an animal which doesn't live anywhere in nature) or not. If bindings couldn't be loaded, it returns nil.
     - Parameters:
     -   animal: The given animal for which we find whether the animal lives in the given continent or it is an animal which doesn't live anywhere in nature.
     - Returns: A boolean representing whether the given animal lives in the biotope or not. If bindings couldn't be loaded, it returns nil.
     */
    func isAnimalInContinent(animal: Animal) -> Bool? {
        if let continents = self.dependencies.continentBindingRepository.getContinentsWithAnimal(animal: animal) as? [Continent] {
            var continentFound = false
            for continent in continents {
                if (continent == self.continent) {
                    continentFound = true
                    break
                }
            }
            
            if (!continentFound) {
                return false
            }
            
            for continent in continents {
                if (continent.czechOriginalTitle == animal.continent){
                    return true
                }
            }
            return false
        } else {
            return nil
        }
    }
    
}
