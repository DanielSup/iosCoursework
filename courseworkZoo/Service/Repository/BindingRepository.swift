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
 This class is a child of Repository class in which it is stored array of entities with the name entities of type MutableProperty. This class ensures finding bindings to the animal given by an identificator.
 */
class BindingRepository<B: Bindable> : Repository<B>{

    /**
     This function finds bindings between the animal given by the identificator.
     - Parameters:
        - animal: The identificator of the animal which we find bindings for.
     - Returns: Array of bindings with the given identificator of the animal or nil if array of bindings is not correctly loaded.
     */
    func getBindingsWithAnimal(animal: Int) -> [B]?{
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
    func getBindingsWithBindableObject(objectId: Int) -> [B]? {
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
        if let bindings = self.getBindingsWithAnimal(animal: animal.id) as? [B] {
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
            if let bindingsBy_Id = self.getBindingsWithAnimal(animal: animal._id) as? [B] {
                return bindingsBy_Id
            }
        }
        return nil
    }
}
