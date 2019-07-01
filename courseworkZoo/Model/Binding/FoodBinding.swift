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
    
    func getAnimalId() -> Int {
        return Int(animal) ?? -1
    }
    
}
