//
//  AnimalsInContinentViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 30/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen with the list of animals living in the given continent or animals which don't live anywhere in nature (if the option was choosed).
*/
class AnimalsInContinentViewModel: BaseViewModel {
    typealias Dependencies = HasContinentBindingsRepository
    /// The object with important dependencies for getting the list of animals living in the given continent (or animals which don't live anywhere in nature if the option was choosed).
    private var dependencies: Dependencies
    /// The selected continent (or option for getting the list of animals which don't live anywhere in nature)
    private let continent: Continent
    
    
    // MARK - Actions
    
    
    /**
     This action returns a signal producer the list of animals living in the given continent (or animals not living in nature if the option was choosed). If bindings can't be loaded, it returns a signal producer with this error. If animals couldn't be loaded, it returns a signal producer with an error representing it.
    */
    lazy var getAnimalsInContinent = Action<(), [Animal], LoadError>  {
        return self.dependencies.continentBindingRepository.getAnimalsInContinent(self.continent)
    }
    
    
    // MARK - Constructor and other functions
    
    
    /**
     - Parameters:
        - dependencies: The object with dependencies important for getting the list of animals in continent.
        - continent: The choosed continent or the option which represents that these animals don't live anywhere in nature.
    */
    init(dependencies: Dependencies, continent: Continent){
        self.dependencies = dependencies
        self.continent = continent
        super.init()
    }
    
    
    /**
     This function returns the locative of the title of the given continent with prepositions and other words or a string representing that animals from the shown list don't live anywhere in nature.
     - Returns: The locative of the title of the continent with prepositions and other words or a string representing that animals from the shown list don't live anywhere in nature.
     */
    func getLocativeOfContinentWithPreposition() -> String {
        return self.continent.locativeWithPreposition
    }
    
}
