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
     - Returns: The identificator of the animal in the given binding.
    */
    func getAnimalId() -> Int
}
