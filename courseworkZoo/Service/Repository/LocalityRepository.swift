//
//  LocalityRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 04/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift


protocol LocalityRepositoring{
    var entities: MutableProperty<[Locality]?> { get }
    func loadAndSaveDataIfNeeded()
    func findLocalityInCloseness(latitude: Double, longitude: Double) -> SignalProducer<Locality?, LoadError>
}


class LocalityRepository: Repository<Locality>, LocalityRepositoring{
    
    
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
