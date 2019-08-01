//
//  AnimalsInBiotopeViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 20/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen with the list of animals in the given biotope.
 */
class AnimalsInBiotopeViewModel: BaseViewModel {
    typealias Dependencies = HasBiotopeBindingsRepository & HasAnimalRepository
    /// The object with important dependencies for the action for getting the list of animals in the given biotope.
    private var dependencies: Dependencies
    /// The given biotope
    private var biotope: Biotope
    
    // MARK - Actions
    
    /**
     This action finds bindings with the given biotope. The action ensures getting the animals from the bindings with the animal repository for getting an animal by an identificator. This action return s the found list of animals in the given biotope. If animals couldn't be loaded, it returns a signal producer with an error representing it.
     */
    lazy var getAnimalsInBiotope = Action<(), [Animal], LoadError>{
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
        self.dependencies.biotopeBindingRepository.loadAndSaveDataIfNeeded()
        if let animals = self.dependencies.animalRepository.entities.value as? [Animal] {
            var animalsInBiotope: [Animal] = []
            for animal in animals {
                var isAnimalInBiotope = self.isAnimalInBiotope(animal: animal)
                if (isAnimalInBiotope == nil) {
                    return SignalProducer(error: .noBindings)
                }
                if(isAnimalInBiotope! == true) {
                    animalsInBiotope.append(animal)
                }
            }
            return SignalProducer(value: animalsInBiotope)
        } else {
            return SignalProducer(error: .noAnimals)
        }
    }
    
    // MARK - Constructor and other methods
    
    /**
     - Parameters:
        - dependencies: The object with dependencies important for the action for getting the list of animals in the given biotope.
        - biotope: The given biotope where the found animals live.
    */
    init (dependencies: Dependencies, biotope: Biotope){
        self.dependencies = dependencies
        self.biotope = biotope
        super.init()
    }
    
    
    /**
     This function returns the locative of the title of the given biotope with a preposition.
     - Returns: The locative of the title of the given biotope with a preposition.
    */
    func getLocativeOfBiotopeTitleWithPreposition() -> String {
        return self.biotope.locativeWithPreposition
    }
    
    
    /**
     This function returns whether the animal is in biotope or not. If bindings couldn't be loaded, it returns nil.
     - Parameters:
        - animal: The given animal for which we find whether the animal is in the given biotope.
     - Returns: A boolean representing whether the given animal lives in the biotope or not. If bindings couldn't be loaded, it returns nil.
    */
    func isAnimalInBiotope(animal: Animal) -> Bool? {
        if let biotopes = self.dependencies.biotopeBindingRepository.getBiotopesWithAnimal(animal: animal) as? [Biotope] {
            var biotopeFound = false
            for biotope in biotopes {
                if (biotope == self.biotope) {
                    biotopeFound = true
                    break
                }
            }
            
            if (!biotopeFound) {
                return false
            }
            
            for biotope in biotopes {
                if (biotope.czechOriginalTitle == animal.biotope){
                    return true
                }
            }
            return false
        } else {
            return nil
        }
    }
    
}
