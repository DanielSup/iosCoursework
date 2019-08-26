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
    typealias Dependencies = HasFoodBindingsRepository
    /// The object with dependencies important for getting the list of animals eating the given kind of food.
    private var dependencies: Dependencies
    /// The given kind of food which the animals in the list eat.
    private let kindOfFood: Food
    
    // MARK - Actions

    
    /**
     This action returns a signal producer the list of animals eating the kind of food. If bindings can't be loaded, it returns a signal producer with this error. If animals couldn't be loaded, it returns a signal producer with an error representing it.
     */
    lazy var getAnimalsEatingKindOfFood = Action<(), [Animal], LoadError> {
        return self.dependencies.foodBindingRepository.getAnimalsEatingKindOfFood(self.kindOfFood)
        
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
     This function returns the instrumental of the title of the kind of food.
     - Return: The instrumental of the title of the kind of food.
    */
    func getInstrumentalOfTitleOfKindOfFood() -> String {
        return self.kindOfFood.instrumentalOfTitle
    }
    
}
