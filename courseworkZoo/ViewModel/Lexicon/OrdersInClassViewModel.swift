//
//  OrdersInClassViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 18/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen with the list of orders in the given class.
*/
class OrdersInClassViewModel: BaseViewModel {
    typealias Dependencies = HasClassRepository
    /// The object with dependencies important for getting the list of orders in the given class.
    private var dependencies: Dependencies
    /// The given parent class in which we find orders in which animals can belong.
    private var parentClass: Class
    
    // MARK - Actions
    
    /**
     This action returns the list of orders in the parent class or an error if classes couldn't be loaded.
    */
    lazy var getOrdersInClass = Action<(), [Class], LoadError>{
        self.dependencies.classRepository.loadAndSaveDataIfNeeded()
        if let classes = self.dependencies.classRepository.entities.value as? [Class] {
            return self.dependencies.classRepository.getOrdersIn(category: self.parentClass)
        } else {
            return SignalProducer(error: LoadError.noClasses)
        }
    }
    
    // MARK - Constructor and other methods.
    
    /**
     - Parameters:
        - dependencies: The object with important dependencies for getting the list of orders in the given parent class
        - parentClass: The given parent class.
    */
    init(dependencies: Dependencies, parentClass: Class){
        self.dependencies = dependencies
        self.parentClass = parentClass
        super.init()
    }
    
    /**
     This function returns the title of the parent class.
     - Returns: The title of the parent class.
    */
    func getParentClassTitle() -> String {
        return self.parentClass.title
    }
}
