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
}

/**
 This protocol is created for the dependency injection. This protocol ensures loading the repository for working with bindings between kinds of food and animals.
 */
protocol FoodBindingRepositoring{
    var entities: MutableProperty<[FoodBinding]?> { get }
    func loadAndSaveDataIfNeeded()
    func findBindingsWithAnimal(animal: Int) -> [FoodBinding]?
    
}

/**
 This protocol is created for the dependency injection. This protocol ensures loading the repository for working with bindings between continents and animals.
 */
protocol ContinentBindingRepositoring{
    var entities: MutableProperty<[ContinentBinding]?> { get }
    func loadAndSaveDataIfNeeded()
    func findBindingsWithAnimal(animal: Int) -> [ContinentBinding]?
    
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
    
}



// These classes created for simpler dependency injection. These classes are childs of parent class BindingRepository for finding bindings between biotopes, kinds of food and continents and animals.

/**
 This class is a child of BindingRepository class for working with bindings with a biotope and an animal.
 */
class BiotopeBindingRepository: BindingRepository<BiotopeBinding>, BiotopeBindingRepositoring{
}

/**
 This class is a child of BindingRepository class for working with bindings with a kind of food and an animal.
 */
class FoodBindingRepository: BindingRepository<FoodBinding>, FoodBindingRepositoring{
}

/**
 This class is a child of BindingRepository class for working with bindings with a continent and an animal.
 */
class ContinentBindingRepository: BindingRepository<ContinentBinding>, ContinentBindingRepositoring{
}
