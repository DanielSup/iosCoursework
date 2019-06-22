//
//  BiotopeBinding.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

struct BiotopeBinding: Bindable {
    
    let animal: String
    let biotope: String
    enum CodingKeys: String, CodingKey{
        case animal="id", biotope="id_b"
    }
    
    func getAnimalId() -> Int {
        return Int(animal) ?? -1
    }
    
}
