//
//  AnimalsInOrderViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen with the list of animals in the given order. There is registered an important action for getting the list of animals in the given order.
*/
class AnimalsInOrderViewModel: BaseViewModel {
    typealias Dependencies = HasAnimalRepository
    /// The object with important dependencies for getting the list of animals in the given order.
    private var dependencies: Dependencies
    /// The given order.
    private var order: Class
    
    // MARK - Actions
    
    /**
     This action return a signal producer with the list of animals in the given order or an error representing that animals couldn't be loaded.
    */
    lazy var getAnimalsInOrder = Action<(), [Animal], LoadError>{
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
        if let animalList = self.dependencies.animalRepository.entities.value as? [Animal] {
            return self.dependencies.animalRepository.getAnimalsInOrder(self.order)
        } else {
            return SignalProducer(error: LoadError.noAnimals)
        }
    }
    
    // MARK - Constructor and other methods
    
    /**
     - Parameters:
        - dependencies: The object with important dependencies for gting the list of animals in the given order.
        - order: The given order where we find animals.
    */
    init(dependencies: Dependencies, order: Class){
        self.dependencies = dependencies
        self.order = order
        super.init()
    }
    
    
    /**
     This function returns the title of the actual order.
     - Returns: The title of the actual order.
    */
    func getOrderTitle() -> String {
        return self.order.title
    }
}
