//
//  PieceOfPath.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 06/08/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit


/**
 This class represents a piece of the path with the selected animals. It represents the path from any one animal to any second animal.
*/
class PieceOfPath: NSObject {
    /// The source placemark representing the start
    var sourcePlacemark: MKPlacemark
    /// The placemark representing the destination (end of the piece).
    var destinationPlacemark: MKPlacemark
    /// The found shortest route between the two given placemarks.
    var route: MKRoute
    
    
    /**
     - Parameters:
        - sourcePlacemark: The placemark representing the start of the piece (source)
        - destinationPlacemark: The placemark representing the end of the piece (destination)
        - route: The found shortest route between the two given placemarks.
    */
    init(sourcePlacemark: MKPlacemark, destinationPlacemark: MKPlacemark, route: MKRoute) {
        self.sourcePlacemark = sourcePlacemark
        self.destinationPlacemark = destinationPlacemark
        self.route = route
    }
}
