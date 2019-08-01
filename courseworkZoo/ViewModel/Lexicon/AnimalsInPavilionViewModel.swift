//
//  AnimalsInPavilionViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen with the list of animals in the choosed pavilion.
*/
class AnimalsInPavilionViewModel: BaseViewModel {
    typealias Dependencies = HasAnimalRepository
    /// The object with important dependency (animal repository) for getting the list of animals in the choosed locality.
    private var dependencies: Dependencies
    /// The selected locality (pavilion)
    private var locality: Locality

    // MARK - Actions
    
    /**
     This action returns a signal producer with the list of animals in the choosed locality. If animals could not be loaded, it returns a signal producer with an error representing it.
    */
    lazy var getAnimalsInLocality = Action<(), [Animal], LoadError>{
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
        return self.dependencies.animalRepository.findAnimalsInLocality(self.locality)
    }
    
    // MARK - Constructor and other methods
    
    /**
     - Parameters:
        - dependencies: The object with animal repository for getting the list of animals in the choosed locality.
        - locality: The choosed locality
    */
    init(dependencies: Dependencies, locality: Locality){
        self.dependencies = dependencies
        self.locality = locality
        super.init()
    }
    
    /**
     This function returns the title of the locality.
     - Returns: The title of the locality.
    */
    func getLocalityTitle() -> String {
        return self.locality.title
    }
}
