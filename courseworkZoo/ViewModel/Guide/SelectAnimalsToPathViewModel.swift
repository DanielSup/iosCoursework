//
//  SelectAnimalsToPathViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 10/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen for selecting animals to the actual unsaved path.
 */
class SelectAnimalsToPathViewModel: BaseViewModel {
    typealias Dependencies = HasAnimalRepository & HasPathRepository
    /// The object with dependencies important for the actions in this view model
    private var dependencies: Dependencies
    
    
    // MARK - Actions
    
    /**
     This action returns a signal producer with the list of animals which can be selected in path
    */
    lazy var getAnimalsForSelectingAction = Action<(), [Animal], Error>{
        [unowned self] in
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
        // getting the list of animals with known coordinates
        var animalsWithCoords: [Animal] = []
        if let animals = self.dependencies.animalRepository.entities.value as? [Animal]{
            for animal in animals{
                if (animal.latitude >= 0){
                    animalsWithCoords.append(animal)
                }
            }
        }
        // filtering animals which are not
        let animalsInPath = self.dependencies.pathRepository.getAnimalsInPath()
        var animalsForSelecting: [Animal] = []
        for animalWithCoords in animalsWithCoords{
            var inPath = false
            for animalInPath in animalsInPath{
                if (animalWithCoords.id == animalInPath.id){
                    inPath = true
                    break
                }
            }
            
            if (!inPath){
                animalsForSelecting.append(animalWithCoords)
            }
        }
        return SignalProducer(value: animalsForSelecting)
    }
    
    
    /**
     This action returns a signal producer with the list of animals in the actual path.
    */
    lazy var getAnimalsInPathAction = Action<(), [Animal], Error>{
        [unowned self] in
        let animalsInPath = self.dependencies.pathRepository.getAnimalsInPath()
        return SignalProducer(value: animalsInPath)
    }
    
    // MARK - Constructor and other methods
    
    /**
     - Parameters:
        - dependencies: The object with dependencies important for the actions in the view model.
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
    
    
    /**
     This function ensures adding the given animal to the actual path.
     - Parameters:
        - animal: The animal which will be added to the actual path.
    */
    func addAnimalToPath(animal: Animal){
        self.dependencies.pathRepository.addAnimalToPath(animal: animal)
    }
    
    
    /**
     This function ensures removing the given animal from the actual path.
     - Parameters:
        - animal: The animal which will be removed from the actual path.
    */
    func removeAnimalFromPath(animal: Animal){
        self.dependencies.pathRepository.removeAnimalFromPath(animal: animal)
    }
}
