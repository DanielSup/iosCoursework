//
//  Binding.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This protocol indicates that classes implementing it are some kind of binding with an animal with the given identificator. It is used for getting the identificator of enimal of the binding.
 */
protocol Bindable: LoadedEntity{
    /**
     It returns the identificator of the animal in the binding as an integer.
     - Returns: The identificator of the animal in the given binding.
    */
    func getAnimalId() -> Int
    
    /**
     It returns the identificator of the binded object as an integer.
     - Returns: The identificator of the binded object with an animal.
    */
    func getBindedObjectId() -> Int
    
    /**
     It returns the czech original title of the binded entity from the dataset from opendata.praha.eu server.
     - Returns: The czech original title of the binded entity.
    */
    func getCzechTitleOfBindedEntity() -> String
    
    /**
     The property of the animal (biotope, continent or food) which is compared with the czech original title during finding the correct bindings.
    */
    func getComparedPropertyOfAnimal(_ animal: Animal) -> String
}
