//
//  AnimalsEatingKindOfFoodViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 31/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen with the list of animals which eat the given kind of food.
*/
class AnimalsEatingKindOfFoodViewModel: BaseViewModel {
    typealias Dependencies = HasFoodBindingsRepository & HasAnimalRepository
    /// The object with dependencies important for getting the list of animals eating the given kind of food.
    private var dependencies: Dependencies
    /// The given kind of food which the animals in the list eat.
    private let kindOfFood: Food
    
    // MARK - Actions

    
    /**
     This action finds bindings with the given continent for finding the list of animals. It returns a signal producer the list of animals eating the kind of food. If bindings can't be loaded, it returns a signal producer with this error. If animals couldn't be loaded, it returns a signal producer with an error representing it.
     */
    lazy var getAnimalsEatingKindOfFood = Action<(), [Animal], LoadError> {
        self.dependencies.foodBindingRepository.loadAndSaveDataIfNeeded()
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
        
        if let animals = self.dependencies.animalRepository.entities.value as? [Animal] {
            var animalsEatingKindOfFood: [Animal] = []
            for animal in animals {
                var isAnimalEatingKindOfFood = self.isAnimalEatingTheKindOfFood(animal: animal)
                if (isAnimalEatingKindOfFood == nil) {
                    return SignalProducer(error: .noBindings)
                }
                if(isAnimalEatingKindOfFood!) {
                    animalsEatingKindOfFood.append(animal)
                }
            }
            return SignalProducer(value: animalsEatingKindOfFood)
        } else {
            return SignalProducer(error: .noAnimals)
        }
        
    }
    
    
    // MARK - Constructor and other methods
    
    
    /**
     - Parameters:
        - dependencies: The object with dependencies important for getting the list of animals eating the given kind of food
        - kindOfFood: The kind of food which the animals from the list eat.
     */
    init(dependencies: Dependencies, kindOfFood: Food){
        self.dependencies = dependencies
        self.kindOfFood = kindOfFood
        super.init()
    }
    
    /**
     This function returns whether the animal eats the kind of food or not. If bindings couldn't be loaded, it returns nil.
     - Parameters:
     -   animal: The given animal for which we find whether it eats the kind of food.
     - Returns: A boolean representing whether the given animal eats the kind of food.
     */
    func isAnimalEatingTheKindOfFood(animal: Animal) -> Bool? {
        if let kindsOfFood = self.dependencies.foodBindingRepository.getKindsOfFoodWithAnimal(animal: animal) as? [Food] {
            var isEatingKindOfFood = false
            for kindOfFood in kindsOfFood {
                if (kindOfFood == self.kindOfFood) {
                    isEatingKindOfFood = true
                    break
                }
            }
            
            if (!isEatingKindOfFood) {
                return false
            }
            
            for kindOfFood in kindsOfFood {
                if (kindOfFood.czechOriginalTitle == animal.food){
                    return true
                }
            }
            return false
        } else {
            return nil
        }
    }
    
    /**
     This function returns the instrumental of the title of the kind of food.
     - Return: The instrumental of the title of the kind of food.
    */
    func getInstrumentalOfTitleOfKindOfFood() -> String {
        return self.kindOfFood.instrumentalOfTitle
    }
    
}
