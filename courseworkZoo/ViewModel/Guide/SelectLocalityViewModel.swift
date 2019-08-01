//
//  SelectLocalityViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model which prepares data for the screen for selection of the target locality where the user wants to go. This view model ensures getting the list of all possible localions with known coordinates where the user can go.
 */
class SelectLocalityViewModel: BaseViewModel {
    typealias Dependencies = HasLocalityRepository
    
    /// The object with dependencies important for actions in this view model
    private let dependencies: Dependencies
    /// The selected locality where the user wants to go.
    static var selectedLocality: Locality? = nil
    
    
    // MARK - Actions
    
    /**
     This actions tries to get a list of all localities where the user can go. It returns a list of all localities with known coordinates or an error that indicates that localities could not be loaded.
    */
    lazy var getLocalities = Action<(), [Locality], LoadError>{
        [unowned self] in
        self.dependencies.localityRepository.loadAndSaveDataIfNeeded()
        if let localities = self.dependencies.localityRepository.entities.value as? [Locality] {
            var newLocalities: [Locality] = []
            for locality in localities {
                if(locality.latitude < 0){
                    continue
                }
                newLocalities.append(locality)
            }
            return SignalProducer<[Locality], LoadError>(value: newLocalities)
        } else {
            return SignalProducer<[Locality], LoadError>(error: .noLocalities)
        }
    }

    // MARK - Constructor
    
    /**
     - Parameters:
        - dependencies: The object with dependencies important for actions in this view model.
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
}
