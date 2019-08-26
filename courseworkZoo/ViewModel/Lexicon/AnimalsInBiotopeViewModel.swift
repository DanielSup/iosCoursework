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
    typealias Dependencies = HasBiotopeBindingsRepository
    /// The object with important dependencies for the action for getting the list of animals in the given biotope.
    private var dependencies: Dependencies
    /// The given biotope
    private var biotope: Biotope
    
    // MARK - Actions
    
    /** This action return s the found list of animals in the given biotope. If animals couldn't be loaded, it returns a signal producer with an error representing it.
     */
    lazy var getAnimalsInBiotope = Action<(), [Animal], LoadError>{
        return self.dependencies.biotopeBindingRepository.getAnimalsInBiotope(self.biotope)
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
