//
//  AnimalDetailViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

class AnimalDetailViewModel: BaseViewModel {
    typealias Dependencies = HasContinentBindingsRepository & HasBiotopeBindingsRepository & HasFoodBindingsRepository 
    private let animal: Animal
    private let dependencies: Dependencies
    init(animal: Animal, dependencies: Dependencies){
        self.animal = animal
        self.dependencies = dependencies
        super.init()
    }
    
    lazy var getContinentsOfAnimal = Action<(), [Continent], LoadError> {
        [unowned self] in
        self.dependencies.continentBindingRepository.loadAndSaveDataIfNeeded()
        let bindingsArray = self.dependencies.continentBindingRepository.entities.value
        if let allBindings = bindingsArray as? [ContinentBinding] {
            let bindings = self.dependencies.continentBindingRepository.findBindingsWithAnimal(animal: self.animal.id)
            if (bindings == nil){
                return SignalProducer(error: .noBindings)
            } else {
                var continents: [Continent] = []
                for binding in bindings!{
                    let continentId = Int(binding.continent)
                    let continentToAdd = Continent.continentWithId(id: continentId ?? -1)
                    continents.append(continentToAdd)
                }
                return SignalProducer(value: continents)
            }
        } else {
            return SignalProducer(error: .noBindings)
        }
    }
    
    lazy var getBiotopesOfAnimal = Action<(), [Biotope], LoadError> {
        [unowned self] in
        self.dependencies.biotopeBindingRepository.loadAndSaveDataIfNeeded()
        let bindingsArray = self.dependencies.biotopeBindingRepository.entities.value
        if let allBindings = bindingsArray as? [BiotopeBinding] {
            let bindings = self.dependencies.biotopeBindingRepository.findBindingsWithAnimal(animal: self.animal.id)
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
}
