//
//  Constants.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 14/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class saves important constants in the whole code of this application.
 */
class Constants: NSObject {
    /// This constant determines where data are loaded from.
    static let serverUrl: String = "https://test-3565.rostiapp.cz/"
    /// The relative URL for getting the list of animals with detailed information
    static let animalsRelativeUrl: String = "animals"
    /// The relative URL for getting the list of localities
    static let localitiesRelativeUrl: String = "localities"
    /// The relative URL for getting the list of bindings with a biotope and an animal
    static let biotopesBindingsRelativeUrl: String = "biotopes/bindings"
    /// The relative URL for getting the list of bindings with a kind of food and an animal
    static let foodBindingsRelativeUrl: String = "food/bindings"
    /// The relative URL for getting the list of bindings with a continent and an animal
    static let continentsBindingsRelativeUrl: String = "continents/bindings"
}
