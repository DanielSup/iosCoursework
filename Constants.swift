//
//  Constants.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 14/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit

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
    static let closeDistance = 0.000055
    /// The maximal radius of the map view to show labels at markers.
    static let maximumRadiusToShowLabels = 250.0
    /// The array of coordinates of entrances to the ZOO.
    static let coordinatesOfEntrances = [CLLocationCoordinate2D(latitude: 50.1168117, longitude: 14.4108614), CLLocationCoordinate2D(latitude: 50.1150014, longitude: 14.4083322), CLLocationCoordinate2D(latitude: 50.1186719, longitude: 14.4088675)]
    /// The array of coordinates of exits from the ZOO.
    static let coordinatesOfExits = [CLLocationCoordinate2D(latitude: 50.1161419, longitude: 14.4114261), CLLocationCoordinate2D(latitude: 50.1150886, longitude: 14.4083256), CLLocationCoordinate2D(latitude: 50.1187519, longitude: 14.4088475)]
}
