//
//  AnimalDetailViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen with detailed information about an animal. This class ensures getting the list of biotopes in which the animal lives, kinds of food which the animal eats and continents where the animal lives.
 */
class AnimalDetailViewModel: BaseViewModel {
    typealias Dependencies = HasContinentBindingsRepository & HasBiotopeBindingsRepository & HasFoodBindingsRepository
    
    /// The animal which we want to get and show information about.
    private let animal: Animal
    /// The object with dependencies important for actions in this view model
    private let dependencies: Dependencies
    
    // MARK - Actions
    
    
    /**
     This action tries to get the list of continents where the animal lives. It returns the list of continents where the animal lives or an error that indicates that bindings with the animal could not be loaded.
    */
    lazy var getContinentsOfAnimal = Action<(), [Continent], LoadError> {
        [unowned self] in
        self.dependencies.continentBindingRepository.loadAndSaveDataIfNeeded()
        let bindingsArray = self.dependencies.continentBindingRepository.entities.value
        if let allBindings = bindingsArray as? [ContinentBinding] {
            let bindings = self.dependencies.continentBindingRepository.findBindingsWithAnimal(animal: self.animal._id)
            if (bindings == nil){
                return SignalProducer(error: .noBindings)
            } else {
                var continents: [Continent] = []
                for binding in bindings!{
                    let continentId = Int(binding.continent)
                    let continentToAdd = Continent.getContinentWithId(id: continentId ?? -1)
                    continents.append(continentToAdd)
                }
                return SignalProducer(value: continents)
            }
        } else {
            return SignalProducer(error: .noBindings)
        }
    }
    
    
    /**
     This action tries to get the list of biotopes in which the animal lives. It returns the list of biotopes in which the animal lives or an error that indicates that bindings with the animal could not be loaded.
     */
    lazy var getBiotopesOfAnimal = Action<(), [Biotope], LoadError> {
        [unowned self] in
        self.dependencies.biotopeBindingRepository.loadAndSaveDataIfNeeded()
        let bindingsArray = self.dependencies.biotopeBindingRepository.entities.value
        if let allBindings = bindingsArray as? [BiotopeBinding] {
            let bindings = self.dependencies.biotopeBindingRepository.findBindingsWithAnimal(animal: self.animal._id)
            if (bindings == nil){
                return SignalProducer(error: .noBindings)
            } else {
                var biotopes: [Biotope] = []
                for binding in bindings!{
                    let biotopeId = Int(binding.biotope)
                    let biotopeToAdd = Biotope.getBiotopeWithId(id: biotopeId ?? -1)
                    biotopes.append(biotopeToAdd)
                }
                return SignalProducer(value: biotopes)
            }
        } else {
            return SignalProducer(error: .noBindings)
        }
    }
    
    
    /**
     This action tries to get the list of kinds of food which the animal eats. It returns the list of kinds of food which the animal eats or an error that indicates that bindings with the animal could not be loaded.
     */
    lazy var getFoodsOfAnimal = Action<(), [Food], LoadError> {
        [unowned self] in
        self.dependencies.foodBindingRepository.loadAndSaveDataIfNeeded()
        let bindingsArray = self.dependencies.foodBindingRepository.entities.value
        if let allBindings = bindingsArray as? [FoodBinding] {
            let bindings = self.dependencies.foodBindingRepository.findBindingsWithAnimal(animal: self.animal.id)
            if (bindings == nil){
                return SignalProducer(error: .noBindings)
            } else {
                var food: [Food] = []
                for binding in bindings!{
                    let foodId = Int(binding.food)
                    let foodToAdd = Food.getFoodWithId(id: foodId ?? -1)
                    food.append(foodToAdd)
                }
                return SignalProducer(value: food)
            }
        } else {
            return SignalProducer(error: .noBindings)
        }
    }
    
    // MARK - Constructor
    
    
    /**
     - Parameters:
        - animal: The animal which we want to show information about
        - dependencies: The object with dependencies important for actions in this view model.
     */
    init(animal: Animal, dependencies: Dependencies){
        self.animal = animal
        self.dependencies = dependencies
        super.init()
    }
}
