//
//  LoadError.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 18/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This enum represents an error which describes which entities could not be loaded from the server
 */
enum LoadError: Error {
    case noLocalities, noAnimals, noBindings
}
