//
//  FoodBindingRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/08/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This protocol is created for the dependency injection. This protocol ensures loading the repository for working with bindings between kinds of food and animals. The property entities and the method loadAndSaveDataIfNeeded() are implemented in the grandparent class Repository and the other two methods for getting bindings with animal or the bindable object are implemented in the parent class BindingRepository.
 */
protocol FoodBindingRepositoring{
    var entities: MutableProperty<[FoodBinding]?> { get }
    func loadAndSaveDataIfNeeded()
    func getBindingsWithAnimal(animal: Int) -> [FoodBinding]?
    func getBindingsWithBindableObject(objectId: Int) -> [FoodBinding]?
    func getKindsOfFoodWithAnimal(animal: Animal) -> [Food]?
    func getAnimalsEatingKindOfFood(kindOfFood: Food) -> SignalProducer<[Animal], LoadError>
}


/**
 This class is a child of BindingRepository class for working with bindings with a kind of food and an animal.
 */
class FoodBindingRepository: BindingRepository<FoodBinding>, FoodBindingRepositoring{
    
    /// The repository for finding the list of animals.
    private var animalRepository: AnimalRepositoring
    /// The locale used for sorting animals by title
    private let czechLocale = Locale(identifier: "cs")

    /**
     - Parameters:
     - animalRepository: The repository for finding the list of animals.
     */
    init(animalRepository: AnimalRepositoring) {
        self.animalRepository = animalRepository
        super.init()
    }

    /**
     This function returns the list of kinds of food which the animal eats.
     - Parameters:
     - animal: The given animal.
     - Returns: The list of kinds of food which the given animal eats.
     */
    func getKindsOfFoodWithAnimal(animal: Animal) -> [Food]? {
        if let bindings = self.getCorrectBindingsWithAnimal(animal: animal) {
            var kindsOfFood: [Food] = []
            for binding in bindings {
                let kindOfFoodId = binding.getBindedObjectId()
                let kindOfFood = Food.getFoodWithId(id: kindOfFoodId)
                kindsOfFood.append(kindOfFood)
            }
            return kindsOfFood
        }
        return nil
    }
    
    /**
     This function finds the list of animals eating the given kind of food. It returns a signal producer with the found list of animals living in the given continent. If animals couldn't be loaded, it returns a signal producer with an error representing it. The list of animals is alphabetically sorted by title.
     - Parameters:
     - continent: The given continent.
     - Returns: A signal producer with the found list of animals living in the given continent. If animals couldn't be loaded, it returns a signal producer with an error representing it.
     */
    func getAnimalsEatingKindOfFood(kindOfFood: Food) -> SignalProducer<[Animal], LoadError> {
        self.loadAndSaveDataIfNeeded()
        self.animalRepository.loadAndSaveDataIfNeeded()
        
        if let animals = self.animalRepository.entities.value as? [Animal] {
            var animalsEatingKindOfFood: [Animal] = []
            for animal in animals {
                var isAnimalEatingKindOfFood = self.isAnimalEatingTheKindOfFood(animal: animal, kindOfFood: kindOfFood)
                if (isAnimalEatingKindOfFood == nil) {
                    return SignalProducer(error: .noBindings)
                }
                if(isAnimalEatingKindOfFood!) {
                    animalsEatingKindOfFood.append(animal)
                }
            }
            return SignalProducer(value: animalsEatingKindOfFood.sorted(by: { $0.title.compare($1.title, locale: czechLocale) == .orderedAscending }))
        } else {
            return SignalProducer(error: .noAnimals)
        }
    }
    
    /**
     This function returns whether the animal eats the kind of food or not. If bindings couldn't be loaded, it returns nil.
     - Parameters:
     -   animal: The given animal for which we find whether it eats the kind of food.
     - Returns: A boolean representing whether the given animal eats the kind of food.
     */
    private func isAnimalEatingTheKindOfFood(animal: Animal, kindOfFood: Food) -> Bool? {
        if let kindsOfFoodWithAnimal = self.getKindsOfFoodWithAnimal(animal: animal) as? [Food] {
            var isEatingKindOfFood = false
            for kindOfFoodWithAnimal in kindsOfFoodWithAnimal {
                if (kindOfFoodWithAnimal == kindOfFood) {
                    isEatingKindOfFood = true
                    break
                }
            }
            
            return isEatingKindOfFood
        } else {
            return nil
        }
    }
}
