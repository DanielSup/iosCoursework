//
//  FoodBinding.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

class FoodBinding: Bindable {
    let animal: String
    let food: String
    enum CodingKeys: String, CodingKey{
        case animal="id", food="id_f"
    }
    
    func getAnimalId() -> Int {
        return Int(animal) ?? -1
    }
    
}
