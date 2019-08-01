//
//  BindingRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This protocol is created for the dependency injection. This protocol ensures loading the repository for working with bindings between biotopes and animals.
 */
protocol BiotopeBindingRepositoring{
    var entities: MutableProperty<[BiotopeBinding]?> { get }
    func loadAndSaveDataIfNeeded()
    func findBindingsWithAnimal(animal: Int) -> [BiotopeBinding]?
    func findBindingsWithBindableObject(objectId: Int) -> [BiotopeBinding]?
    func getBiotopesWithAnimal(animal: Animal) -> [Biotope]?
}

/**
 This protocol is created for the dependency injection. This protocol ensures loading the repository for working with bindings between kinds of food and animals.
 */
protocol FoodBindingRepositoring{
    var entities: MutableProperty<[FoodBinding]?> { get }
    func loadAndSaveDataIfNeeded()
    func findBindingsWithAnimal(animal: Int) -> [FoodBinding]?
    func findBindingsWithBindableObject(objectId: Int) -> [FoodBinding]?
    func getKindsOfFoodWithAnimal(animal: Animal) -> [Food]?
}

/**
 This protocol is created for the dependency injection. This protocol ensures loading the repository for working with bindings between continents and animals.
 */
protocol ContinentBindingRepositoring{
    var entities: MutableProperty<[ContinentBinding]?> { get }
    func loadAndSaveDataIfNeeded()
    func findBindingsWithAnimal(animal: Int) -> [ContinentBinding]?
    func findBindingsWithBindableObject(objectId: Int) -> [ContinentBinding]?
    func getContinentsWithAnimal(animal: Animal) -> [Continent]?
}



/**
 This class is a child of Repository class in which it is stored array of entities with the name entities of type MutableProperty. This class ensures finding bindings to the animal given by an identificator.
 */
class BindingRepository<B: Bindable> : Repository<B>{

    /**
     This function finds bindings between the animal given by the identificator.
     - Parameters:
        - animal: The identificator of the animal which we find bindings for.
     - Returns: Array of bindings with the given identificator of the animal or nil if array of bindings is not correctly loaded.
     */
    func findBindingsWithAnimal(animal: Int) -> [B]?{
        if let bindings = self.entities.value as? [B]{
            var bindingEntities: [B] = []
            for binding in bindings{
                if(binding.getAnimalId() == animal){
                    bindingEntities.append(binding)
                }
            }
            return bindingEntities
        } else {
            return nil
        }
    }
    
    /**
     This function finds and returns bindings with the binded object (kind of food, continent or biotope).
     - Parameters:
        - objectId: The identificator of the binded object (kind of food, continent or biotope).
     - Returns: The array of bindings with the binded object (kind of food, continent or biotope).
    */
    func findBindingsWithBindableObject(objectId: Int) -> [B]? {
        if let bindings = self.entities.value as? [B] {
            var bindingEntities: [B] = []
            for binding in bindings {
                if (binding.getBindedObjectId() == objectId){
                    bindingEntities.append(binding)
                }
            }
            return bindingEntities
        } else {
            return nil
        }
    }
    
    
    /**
     This function finds and returns the correct bindings with the given animal. Firstly, this function finds the bindings by identificator in column "id". If there is no binding with the correct title in the list of bindings with the identificator, then the function tries to get and return the list of bindings with the identificator of the animal in column "_id".
     - Returns: The list of bindings with the given animal or nil if no bindings are found.
    */
    func getCorrectBindingsWithAnimal(animal: Animal) -> [B]? {
        var correctBindingsFound = false
        if let bindings = self.findBindingsWithAnimal(animal: animal.id) as? [B] {
            var bindingsById: [B] = []
            for binding in bindings {
                let bindedObjectTitle = binding.getCzechTitleOfBindedEntity()
                let comparedPropertyOfAnimal = binding.getComparedPropertyOfAnimal(animal)
                bindingsById.append(binding)
                if (comparedPropertyOfAnimal.contains(bindedObjectTitle)) {
                    correctBindingsFound = true
                }
                
            }
            if (correctBindingsFound) {
                return bindingsById
            }
        } else {
            return nil
        }
        
        if (!correctBindingsFound) {
            if let bindingsBy_Id = self.findBindingsWithAnimal(animal: animal._id) as? [B] {
                return bindingsBy_Id
            }
        }
        return nil
    }
}



// These classes created for simpler dependency injection. These classes are childs of parent class BindingRepository for finding bindings between biotopes, kinds of food and continents and animals.

/**
 This class is a child of BindingRepository class for working with bindings with a biotope and an animal.
 */
class BiotopeBindingRepository: BindingRepository<BiotopeBinding>, BiotopeBindingRepositoring{
    
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
}

/**
 This class is a child of BindingRepository class for working with bindings with a kind of food and an animal.
 */
class FoodBindingRepository: BindingRepository<FoodBinding>, FoodBindingRepositoring{
    
    /**
     This function returns the list of kinds of food which the animal eats.
     - Parameters:
        - animal: The given animal.
     - Returns: The list of kinds of food which the given animal eats.
     */
    func getKindsOfFoodWithAnimal(animal: Animal) -> [Food]? {
        if let bindings = self.getCorrectBindingsWithAnimal(animal: animal) {
            var kindsOfFood: [Food] = []
            for binding in bindings {
                let kindOfFoodId = binding.getBindedObjectId()
                let kindOfFood = Food.getFoodWithId(id: kindOfFoodId)
                kindsOfFood.append(kindOfFood)
            }
            return kindsOfFood
        }
        return nil
    }
}

/**
 This class is a child of BindingRepository class for working with bindings with a continent and an animal.
 */
class ContinentBindingRepository: BindingRepository<ContinentBinding>, ContinentBindingRepositoring{

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
}
