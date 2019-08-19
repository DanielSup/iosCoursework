//
//  BiotopeBindingRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/08/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift


/**
 This protocol is created for the dependency injection. This protocol ensures loading the repository for working with bindings between biotopes and animals. The property entities and the method loadAndSaveDataIfNeeded() are implemented in the grandparent class Repository and the other two methods for getting bindings with animal or the bindable object are implemented in the parent class BindingRepository.
 */
protocol BiotopeBindingRepositoring {
    var entities: MutableProperty<[BiotopeBinding]?> { get }
    func loadAndSaveDataIfNeeded()
    func getBindingsWithAnimal(animal: Int) -> [BiotopeBinding]?
    func getBindingsWithBindableObject(objectId: Int) -> [BiotopeBinding]?
    func getBiotopesWithAnimal(animal: Animal) -> [Biotope]?
    func getAnimalsInBiotope(biotope: Biotope) -> SignalProducer<[Animal], LoadError>
}

/**
 This class is a child of BindingRepository class for working with bindings with a biotope and an animal.
 */
class BiotopeBindingRepository: BindingRepository<BiotopeBinding>, BiotopeBindingRepositoring{
    
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
     This function returns the list of biotopes in which the given animal lives.
     - Parameters:
     - animal: The given animal.
     - Returns: The list of biotopes in which the given animal lives.
     */
    func getBiotopesWithAnimal(animal: Animal) -> [Biotope]? {
        if let bindings = self.getCorrectBindingsWithAnimal(animal: animal) {
            var biotopes: [Biotope] = []
            for binding in bindings {
                let biotopeId = binding.getBindedObjectId()
                let biotope = Biotope.getBiotopeWithId(id: biotopeId)
                biotopes.append(biotope)
            }
            return biotopes
        }
        return nil
    }
    
    /**
     This function finds animals which live in the given biotope. It returns the list of animals in the given biotope. If animals couldn't be loaded, it returns a signal producer with an error representing it. The list of animals is sorted alphabetically by title.
     - Parameters:
        - biotope: The given biotope.
     - Returns: A signal producer with the found list of animals in the given biotope. If animals couldn't be loaded, it returns a signal producer with an error representing it.
     */
    func getAnimalsInBiotope(biotope: Biotope) -> SignalProducer<[Animal], LoadError> {
        self.loadAndSaveDataIfNeeded()
        self.animalRepository.loadAndSaveDataIfNeeded()
        
        if let animals = self.animalRepository.entities.value as? [Animal] {
            var animalsInBiotope: [Animal] = []
            for animal in animals {
                var isAnimalInBiotope = self.isAnimalInBiotope(animal: animal,  biotope: biotope)
                if (isAnimalInBiotope == nil) {
                    return SignalProducer(error: .noBindings)
                }
                if(isAnimalInBiotope! == true) {
                    animalsInBiotope.append(animal)
                }
            }
            return SignalProducer(value: animalsInBiotope.sorted(by: { $0.title.compare($1.title, locale: czechLocale) == .orderedAscending }))
        } else {
            return SignalProducer(error: .noAnimals)
        }
    }
    
    /**
     This function returns whether the animal is in the given biotope or not. If bindings couldn't be loaded, it returns nil.
     - Parameters:
     - animal: The given animal for which we find whether the animal is in the given biotope.
     - Returns: A boolean representing whether the given animal lives in the biotope or not. If bindings couldn't be loaded, it returns nil.
     */
    private func isAnimalInBiotope(animal: Animal, biotope: Biotope) -> Bool? {
        if let biotopesWithAnimal = self.getBiotopesWithAnimal(animal: animal) as? [Biotope] {
            var biotopeFound = false
            for biotopeWithAnimal in biotopesWithAnimal {
                if (biotopeWithAnimal == biotope) {
                    biotopeFound = true
                    break
                }
            }
            
            return biotopeFound
        } else {
            return nil
        }
    }
    
}
