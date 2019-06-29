//
//  Binding.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

protocol Bindable: LoadedEntity{
    func getAnimalId() -> Int
}
