//
//  AnimalListViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 23/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift


/**
 This class is a view model for the screen with the list of all animals. It ensures getting the list of all animals.
 */
class AnimalListViewModel: BaseViewModel{
    typealias Dependencies = HasAnimalRepository & HasSpeechService
   
    /// The object with dependencies important for the action for getting the list of animals in this view models.
    private var dependencies: Dependencies
    
    // MARK - Actions
    
    
    /**
     This actions tries to return a list of all animals. It returns a list of all animals or an error indicating that animals could not be loaded.
    */
    lazy var getAllAnimalsAction = Action<(), [Animal], LoadError>{
        [unowned self] in
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
        if let animals = self.dependencies.animalRepository.entities.value as? [Animal]  {
            return SignalProducer<[Animal], LoadError>(value: animals)
        } else {
            return SignalProducer<[Animal], LoadError>(error: .noAnimals)
        }
    }
    
    // MARK - Constructor
    
    /**
     - Parameters:
        - dependencies: The object with dependencies important for the action for getting the list of all animals in this view model.
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
    
}
