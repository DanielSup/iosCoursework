//
//  ContinentBinding.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

struct ContinentBinding: Bindable{
    static var relativeUrl: String = Constants.continentsBindingsRelativeUrl
    
    let animal: String
    let continent: String
    enum CodingKeys: String, CodingKey{
        case animal="id", continent="id_c"
    }
    
    func getAnimalId() -> Int {
        return Int(animal) ?? -1
    }
}
