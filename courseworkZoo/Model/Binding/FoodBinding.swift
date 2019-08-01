//
//  FoodBinding.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represents a binding of animal with the given identificator with a kind of food which the animal eats.
 */
class FoodBinding: Bindable {
    static var relativeUrl: String = Constants.foodBindingsRelativeUrl
    
    let animal: String
    let food: String
    enum CodingKeys: String, CodingKey{
        case animal="id", food="id_f"
    }
    
    /**
     It returns the identificator of the animal in the binding as an integer.
     - Returns: The identificator of the animal in the given binding.
     */
    func getAnimalId() -> Int {
        return Int(animal) ?? -1
    }
    
    /**
     It returns the identificator of the food which the binded animal eats.
     - Returns: The identificator of the food which the animal eats.
    */
    func getBindedObjectId() -> Int {
        return Int(food) ?? -1
    }
    
    /**
     This function returns the czech title of the kind of food binded with the animal by this binding.
     - Returns: The title of the kind of food binded with the animal by this binding.
     */
    func getCzechTitleOfBindedEntity() -> String {
        let food = Food.getFoodWithId(id: self.getBindedObjectId())
        return food.czechOriginalTitle
    }
    
    /**
     This function returns the kind of food which the animal eats.
     - Returns: The kind of food which the animal eats.
     */
    func getComparedPropertyOfAnimal(_ animal: Animal) -> String {
        return animal.food
    }
    
}
