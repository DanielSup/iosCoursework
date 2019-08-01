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
        if let continentsWithAnimal = self.dependencies.continentBindingRepository.getContinentsWithAnimal(animal: self.animal) as? [Continent]{
            return SignalProducer(value: continentsWithAnimal)
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
        if let biotopesWithAnimal = self.dependencies.biotopeBindingRepository.getBiotopesWithAnimal(animal: self.animal) as? [Biotope] {
            return SignalProducer(value: biotopesWithAnimal)
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
        if let kindsOfFoodWithAnimal = self.dependencies.foodBindingRepository.getKindsOfFoodWithAnimal(animal: self.animal) as? [Food] {
            return SignalProducer(value: kindsOfFoodWithAnimal)
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
