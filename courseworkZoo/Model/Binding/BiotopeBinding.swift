//
//  BiotopeBinding.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represent binding of animal with the given identificator with a biotope in which the animal lives.
 */
struct BiotopeBinding: Bindable {
    
    static var relativeUrl: String = Constants.biotopesBindingsRelativeUrl
    
    let animal: String
    let biotope: String
    
    
    enum CodingKeys: String, CodingKey{
        case animal="id", biotope="id_b"
    }
    
    /**
     It returns the identificator of the animal in the binding as an integer.
     - Returns: The identificator of the animal in the given binding.
     */
    func getAnimalId() -> Int {
        return Int(animal) ?? -1
    }
    
    /**
     It returns the identificator of the biotope where the binded animal lives.
     - Returns: The identificator of the biotope where the animal lives.
    */
    func getBindedObjectId() -> Int {
        return Int(biotope) ?? -1
    }
    
    /**
     This function returns the czech title of the biotope binded with the animal by this binding.
     - Returns: The title of the biotope binded with the animal by this binding.
    */
    func getCzechTitleOfBindedEntity() -> String {
        let biotope = Biotope.getBiotopeWithId(id: self.getBindedObjectId())
        return biotope.czechOriginalTitle
    }
    
    /**
     This function returns the biotope where the animal in the binding lives.
     - Returns: The biotope where the animal in the binding lives.
    */
    func getComparedPropertyOfAnimal(_ animal: Animal) -> String {
        return animal.biotope
    }
    
}
