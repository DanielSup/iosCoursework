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
    
    func getAnimalId() -> Int {
        return Int(animal) ?? -1
    }
    
}
