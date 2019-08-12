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
    func visitLocality(_ locality: Locality)
    func findLocalityInCloseness(latitude: Double, longitude: Double) -> SignalProducer<Locality?, LoadError>
}


/**
 This class is a child of Repository class which stores the mutable object with list of loaded entities or nil (if entities can't be loaded). This class also ensures finding enough close localities.
 */
class LocalityRepository: Repository<Locality>, LocalityRepositoring{
    
    /// The array of visited localities.
    var visitedLocalities: [Locality] = []
    
    
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
                if(abs(locality.latitude - latitude) < Constants.closeDistance && abs(locality.longitude - longitude) < Constants.closeDistance && !self.isTheLocalityVisited(locality: locality)){
                    return SignalProducer(value: locality)
                }
            }
            return SignalProducer(value: nil)
            
        } else {
            return SignalProducer(error: .noLocalities)
        }
    }
    
    
    /**
     This function ensures marking the given locality as visited.
     - Parameters:
        - locality: The locality which is visited at the moment.
    */
    func visitLocality(_ locality: Locality) {
        self.visitedLocalities.append(locality)
    }
    
    
    /**
    This function returns whether the locality is visited or not.
     - Parameters:
        - locality: The locality which is checked.
     - Returns: A boolean representing whether the given locality is visited or not.
     */
    private func isTheLocalityVisited(locality: Locality) -> Bool {
        for visitedLocality in self.visitedLocalities {
            if (abs(locality.latitude - visitedLocality.latitude) < 1e-7 &&
                abs(locality.longitude - visitedLocality.longitude) < 1e-7) {
                return true
            }
        }
        return false
    }
}
