//
//  ContinentBindingRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/08/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift


/**
 This protocol is created for the dependency injection. This protocol ensures loading the repository for working with bindings between continents and animals. The property entities and the method loadAndSaveDataIfNeeded() are implemented in the grandparent class Repository and the other two methods for getting bindings with animal or the bindable object are implemented in the parent class BindingRepository.
 */

protocol ContinentBindingRepositoring{
    var entities: MutableProperty<[ContinentBinding]?> { get }
    func loadAndSaveDataIfNeeded()
    func getBindingsWithAnimal(animal: Int) -> [ContinentBinding]?
    func getBindingsWithBindableObject(objectId: Int) -> [ContinentBinding]?
    func getContinentsWithAnimal(animal: Animal) -> [Continent]?
    func getAnimalsInContinent(continent: Continent) -> SignalProducer<[Animal], LoadError>
}

/**
 This class is a child of BindingRepository class for working with bindings with a continent and an animal.
 */
class ContinentBindingRepository: BindingRepository<ContinentBinding>, ContinentBindingRepositoring{
    
    /// The repository for finding the list of animals.
    private var animalRepository: AnimalRepositoring
    /// The locale used for sorting animals by title
    private let czechLocale = Locale(identifier: "cs")

    /**
     - Parameters:
     - animalRepository: The repository for finding the list of animals.
     */
    init(animalRepository: AnimalRepositoring) {
        self.animalRepository = animalRepository
        super.init()
    }
    
    
    /**
     This function returns the list of continents in which the given animal lives.
     - Parameters:
     - animal: The given animal.
     - Returns: The list of continents in which the given animal lives.
     */
    func getContinentsWithAnimal(animal: Animal) -> [Continent]? {
        if let bindings = self.getCorrectBindingsWithAnimal(animal: animal) {
            var continents: [Continent] = []
            for binding in bindings {
                let continentId = binding.getBindedObjectId()
                let continent = Continent.getContinentWithId(id: continentId)
                continents.append(continent)
            }
            return continents
        }
        return nil
    }
    
    
    /**
     This function finds the list of animals living in the given continent. It returns a signal producer with the found list of animals living in the given continent. If animals couldn't be loaded, it returns a signal producer with an error representing it. The list of animals is alphabetically sorted by title.
     - Parameters:
        - continent: The given continent.
     - Returns: A signal producer with the found list of animals living in the given continent. If animals couldn't be loaded, it returns a signal producer with an error representing it.
     */
    func getAnimalsInContinent(continent: Continent) -> SignalProducer<[Animal], LoadError> {
        self.loadAndSaveDataIfNeeded()
        self.animalRepository.loadAndSaveDataIfNeeded()
        
        if let animals = self.animalRepository.entities.value as? [Animal] {
            var animalsInContinent: [Animal] = []
            for animal in animals {
                var isAnimalInContinent = self.isAnimalInContinent(animal: animal, continent: continent)
                if (isAnimalInContinent == nil) {
                    return SignalProducer(error: .noBindings)
                }
                if (isAnimalInContinent!) {
                    animalsInContinent.append(animal)
                }
            }
            return SignalProducer(value: animalsInContinent.sorted(by: { $0.title.compare($1.title, locale: czechLocale ) == .orderedAscending }))
        } else {
            return SignalProducer(error: .noAnimals)
        }
    }
    
    
    /**
     This function returns whether the animal lives in the continent (or whether it is an animal which doesn't live anywhere in nature) or not. If bindings couldn't be loaded, it returns nil.
     - Parameters:
     -   animal: The given animal for which we find whether the animal lives in the given continent or it is an animal which doesn't live anywhere in nature.
     - Returns: A boolean representing whether the given animal lives in the biotope or not. If bindings couldn't be loaded, it returns nil.
     */
    private func isAnimalInContinent(animal: Animal, continent: Continent) -> Bool? {
        if let continentsWithAnimal = self.getContinentsWithAnimal(animal: animal) as? [Continent] {
            var continentFound = false
            for continentWithAnimal in continentsWithAnimal {
                if (continentWithAnimal == continent) {
                    continentFound = true
                    break
                }
            }
            
            return continentFound
        } else {
            return nil
        }
    }
    
}
