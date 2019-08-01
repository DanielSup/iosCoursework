//
//  PavilionsViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen with the list of all localities (especially pavilions) in the ZOO.
*/
class PavilionsViewModel: BaseViewModel {
    typealias Dependencies = HasLocalityRepository
    /// The object with important dependencies for getting the list of localities in the ZOO.
    private var dependencies: Dependencies
    
    // MARK - Actions
    
    /**
     This action returns a signal producer with the list of all localities in the ZOO or an error representing that localities couldn't be loaded.
    */
    lazy var getLocalities = Action<(), [Locality], LoadError>{
        self.dependencies.localityRepository.loadAndSaveDataIfNeeded()
        if let localities = self.dependencies.localityRepository.entities.value as? [Locality] {
            return SignalProducer(value: localities)
        } else {
            return SignalProducer(error: LoadError.noLocalities)
        }
    }
    
    // MARK - Constructor
    
    /**
     - Parameters:
        - dependencies: The object with dependencies important for getting the list of localities in the ZOO.
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
}
