//
//  LocalityRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 04/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This protocol is used for the dependency injection. It ensures loading the locality repository for loading localities and working with them.
 */
protocol LocalityRepositoring{
    var entities: MutableProperty<[Locality]?> { get }
    func loadAndSaveDataIfNeeded()
    func findLocalityInCloseness(latitude: Double, longitude: Double) -> SignalProducer<Locality?, LoadError>
}


/**
 This class is a child of Repository class which stores the mutable object with list of loaded entities or nil (if entities can't be loaded). This class also ensures finding enough close localities.
 */
class LocalityRepository: Repository<Locality>, LocalityRepositoring{
    
    
    /**
    This function finds a locality whose coordinates differ not more than 0,000045 from the given coordinates.
     - Parameters:
        - latitude: The actual latitude
        - longitude: The actual longitude
     - Returns: The signal producer with a close locality or nil value (if no enough close locality found) or an error representing that localities couldn't be loaded.
     */
    func findLocalityInCloseness(latitude: Double, longitude: Double) -> SignalProducer<Locality?, LoadError> {
        if let localities = self.entities.value as? [Locality]{
            for locality in localities{
                if(abs(locality.latitude - latitude) < BaseViewModel.closeDistance && abs(locality.longitude - longitude) < BaseViewModel.closeDistance){
                    return SignalProducer(value: locality)
                }
            }
            return SignalProducer(value: nil)
            
        } else {
            return SignalProducer(error: .noLocalities)
        }
    }
    
    
}
