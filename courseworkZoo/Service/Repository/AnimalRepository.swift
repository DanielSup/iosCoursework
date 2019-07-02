//
//  AnimalRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 04/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift


/**
 This protocol is used for the dependency injection. It ensures loading the animal repository for loading animals and working with them.
 */
protocol AnimalRepositoring{
    var entities: MutableProperty<[Animal]?> { get }
    func loadAndSaveDataIfNeeded()
    func findAnimalById(id: Int) -> SignalProducer<Animal?, LoadError>
    func findAnimalInCloseness(latitude: Double, longitude: Double) -> SignalProducer<Animal?, LoadError>
}


/**
This class is a child of Repository class which stores the mutable object with list of loaded entities or nil (if entities can't be loaded). This class also ensures finding enough close animals.
*/
class AnimalRepository: Repository<Animal>, AnimalRepositoring{
    
    
    /**
    This function returns an animal with the given identificator.
     - Parameters:
        - id: The given identificator
     - Returns: The signal producer with an animal with the given identificator or nil (if no animal with the given identificator found) or an error representing that animals couldn't be loaded.
    */
    func findAnimalById(id: Int) -> SignalProducer<Animal?, LoadError> {
        if let animalList = self.entities.value as? [Animal] {
            for animal in animalList{
                if(animal.id == id){
                    return SignalProducer(value: animal)
                }
            }
            return SignalProducer(value: nil)
        } else {
            return SignalProducer(error: .noAnimals)
        }
    }
    
    
    /**
     This function finds an animal whose coordinates differ not more than 0,000045 from the given coordinates.
     - Parameters:
     - latitude: The actual latitude
     - longitude: The actual longitude
     - Returns: The signal producer with a close animal or nil value (if no enough close animal found) or an error representing that animals couldn't be loaded.
     */
    func findAnimalInCloseness(latitude: Double, longitude: Double) -> SignalProducer<Animal?, LoadError> {
        if let animalList = self.entities.value as? [Animal] {
            for animal in animalList{
                if(abs(animal.latitude - latitude) < BaseViewModel.closeDistance && abs(animal.longitude - longitude) < BaseViewModel.closeDistance){
                    return SignalProducer(value: animal)
                }
            }
            return SignalProducer(value: nil)
        } else {
            return SignalProducer(error: .noAnimals)
        }
    }
    
    
}
