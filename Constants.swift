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
    static let serverUrl: String = "https://lexikonprozoo-3601.rostiapp.cz/"
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
    /// The relative URL for getting the list of classes and orders.
    static let classes = "classes"
    /// The maximal distance in degrees at which must be an animal or a locality for machine-reading the information about the locality or the animal.
    static let closeDistance = 0.000045 + 1
    /// The latitude of the entrance to the ZOO
    static let entranceLatitude = 49.9726294
    /// The longitude of the entrance to the ZOO.
    static let entranceLongitude = 14.1649192
    /// The latitude of the exit from the ZOO.
    static let exitLatitude = 49.9726644
    /// The longitude of the exit from the ZOO.
    static let exitLongitude = 14.1651967
    
}
