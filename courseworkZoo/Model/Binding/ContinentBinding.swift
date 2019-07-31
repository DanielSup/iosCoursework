//
//  ContinentBinding.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represents a binding of animal with a biotope in which the animal lives.
 */
struct ContinentBinding: Bindable{
    static var relativeUrl: String = Constants.continentsBindingsRelativeUrl
    
    let animal: String
    let continent: String
    enum CodingKeys: String, CodingKey{
        case animal="id", continent="id_c"
    }
    
    /**
     It returns the identificator of the animal in the binding as an integer.
     - Returns: The identificator of the animal in the given binding.
     */
    func getAnimalId() -> Int {
        return Int(animal) ?? -1
    }
    
    /**
     It returns the identificator of the continent where the binded animal lives.
     - Returns: The identificator of the continent where the animal lives.
    */
    func getBindedObjectId() -> Int {
        return Int(continent) ?? -1
    }
}
