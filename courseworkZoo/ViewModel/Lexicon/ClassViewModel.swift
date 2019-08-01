//
//  ClassViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 18/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen with the list of classes of animals.
*/
class ClassViewModel: BaseViewModel {
    typealias Dependencies = HasClassRepository
    
    /// The object with the important dependency for getting the list of classes of animals.
    private var dependencies: Dependencies
    
    // MARK - Actions
    
    /**
     This action returns the list of all classes in which animals can belong.
    */
    lazy var getClasses = Action<(), [Class], LoadError> {
        self.dependencies.classRepository.loadAndSaveDataIfNeeded()
        if let classes = self.dependencies.classRepository.entities.value as? [Class] {
            return self.dependencies.classRepository.getClasses()
        } else {
            return SignalProducer(error: LoadError.noClasses)
        }
    }
    
    // MARK - Constructor
    
    /**
     - Parameters:
        - dependencies: The object with the important dependency for getting the list of classes of animals.
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
}
