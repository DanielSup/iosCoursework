//
//  BaseViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 15/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represents a base view model. It is used for checking possible memory leaks and finding out whether localities and animals were visited or not.
 */
class BaseViewModel {
    /// The distance in degrees in which must be an animal or a locality for machine-reading of information about the locality or the animal.
    static let closeDistance = 0.000045
    /// The array of visited locations saved as an array of coordinates of visited locations.
    static var visited:[Coords] = []
    
    init(){
        NSLog("Created ViewModel: \(self)")
    }
    
    
    /**
     This function checks whether the given position (position of an animal or a locality) was visited or not.
     - Parameters:
        - latitude: The latitude (first coordinate) of the given position
        - longitude: The longitude (second coordinate) of the given position
     - Returns: Boolean representing whether the given position was visited by the user or not.
     */
    static func existsPosition(latitude: Double, longitude: Double) -> Bool{
        for position in visited{
            if(position.latitude == latitude && position.longitude == longitude){
                return true
            }
        }
        return false
    }
    
    
    deinit{
        NSLog("Removing ViewModel: \(self)")
    }
}
