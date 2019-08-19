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
    func getAnimalById(id: Int) -> SignalProducer<Animal?, LoadError>
    func getAnimalBy_Id(id: Int) -> SignalProducer<Animal?, LoadError>
    func getAnimalsInOrder(_ order: Class) -> SignalProducer<[Animal], LoadError>
    func getAnimalsInLocality(_ locality: Locality) -> SignalProducer<[Animal], LoadError>
}


/**
This class is a child of Repository class which stores the mutable object with list of loaded entities or nil (if entities can't be loaded). This class also ensures finding enough close animals.
*/
class AnimalRepository: Repository<Animal>, AnimalRepositoring{
    
    /// The locale used for sorting animals by title
    private let czechLocale = Locale(identifier: "cs")
    
    /**
    This function returns an animal with the given identificator (the second identificator in the dataset from the opendata.praha.eu server).
     - Parameters:
        - id: The given identificator
     - Returns: The signal producer with an animal with the given identificator or nil (if no animal with the given identificator found) or an error representing that animals couldn't be loaded.
    */
    func getAnimalById(id: Int) -> SignalProducer<Animal?, LoadError> {
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
     This function returns an animal with the given identificator (the first identificator in the dataset from the opendata.praha.eu server).
     - Parameters:
     - id: The given identificator
     - Returns: The signal producer with an animal with the given identificator or nil (if no animal with the given identificator found) or an error representing that animals couldn't be loaded.
     */
    func getAnimalBy_Id(id: Int) -> SignalProducer<Animal?, LoadError> {
        if let animalList = self.entities.value as? [Animal] {
            for animal in animalList{
                if(animal._id == id){
                    return SignalProducer(value: animal)
                }
            }
            return SignalProducer(value: nil)
        } else {
            return SignalProducer(error: .noAnimals)
        }
    }
    
    
    /**
     This function finds and returns the list of animals in the given order. If animals could not be loaded, it returns an error. The list of animals is sorted alphabetically by title.
     - Parameters:
        - order: The order for which we find the list of animals.
     - Returns: A signal producer with the list of animals in the given order or an error representing that animals could not be loaded. The array of animals is sorted alphabetically by title.
     */
    func getAnimalsInOrder(_ order: Class) -> SignalProducer<[Animal], LoadError>{
        if let animalList = self.entities.value as? [Animal] {
            var animalsInOrder: [Animal] = []
            for animal in animalList {
                if (animal.order == order.title){
                    animalsInOrder.append(animal)
                }
            }
            return SignalProducer(value: animalsInOrder.sorted(by: {$0.title > $1.title}))
        } else {
            return SignalProducer(error: .noAnimals)
        }
    }
    
    
    /**
     This function finds and returns the list of animals in the given locality (pavilion). If animals couldn't be loaded, it returns an error. The list of animals is sorted alphabetically by title.
     - Parameters:
        - locality: The given locality in which we find animals.
     - Returns: A signal producer with the list of animals in the locality or an error representing that animals could not be loaded. The list of animals is sorted alphabetically by title.
    */
    func getAnimalsInLocality(_ locality: Locality) -> SignalProducer<[Animal], LoadError>{
        if let animalList = self.entities.value as? [Animal] {
            var animalsInLocality: [Animal] = []
            for animal in animalList {
                if (animal.localities.trimmingCharacters(in: .whitespacesAndNewlines) == locality.title.trimmingCharacters(in: .whitespacesAndNewlines)){
                    animalsInLocality.append(animal)
                }
            }
            return SignalProducer(value: animalsInLocality.sorted(by: {$0.title.compare($1.title, locale: czechLocale) == .orderedAscending}))
        } else {
            return SignalProducer(error: .noAnimals)
        }
    }
    
}
