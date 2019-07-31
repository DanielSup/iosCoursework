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
     This action finds bindings with the given biotope. The action ensures getting the animals from the bindings with the animal repository for getting an animal by an identificator. This action return s the found list of animals in the given biotope.
    */
    lazy var getAnimalsInBiotopeAction = Action<(), [Animal], LoadError>{
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
        self.dependencies.biotopeBindingRepository.loadAndSaveDataIfNeeded()
        if let bindings = self.dependencies.biotopeBindingRepository.findBindingsWithBindableObject(objectId: self.biotope.rawValue + 1) as?
            [BiotopeBinding] {
            
            var animalsInBiotope: [Animal] = []
            
            for binding in bindings {
                let animalId = binding.getAnimalId()
                var animalWasFound = false
                self.dependencies.animalRepository.findAnimalBy_Id(id: animalId).producer.startWithResult{
                     (animalResult) in
                    if (animalResult.value! != nil){
                        animalWasFound = true
                        animalsInBiotope.append(animalResult.value!!)
                    }
                }
                
                if(!animalWasFound){
                    self.dependencies.animalRepository.findAnimalById(id: animalId).producer.startWithResult { (animalResult) in
                        if(animalResult.value! != nil){
                            animalsInBiotope.append(animalResult.value!!)
                        }
                    }
                }
                
            }
            return SignalProducer(value: animalsInBiotope)
        } else {
            return SignalProducer(error: LoadError.noBindings)
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
}
