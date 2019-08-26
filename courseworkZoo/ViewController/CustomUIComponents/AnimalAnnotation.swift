//
//  AnimalAnnotation.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 17/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit

/**
 This class represent an annotation for the animal which can be in path.
*/
class AnimalAnnotation: NSObject, MKAnnotation {
    /// The coordinate of the animal
    var coordinate: CLLocationCoordinate2D
    /// The animal related to the annotation.
    var animal: Animal
    
    /// The title of the annotation
    var title: String?

    /**
     - Parameters:
        - coordinate: The coordinate (object with double latitude and double longitude) of the animal
        - animal: The animal related to the annotation.
    */
    init(coordinate: CLLocationCoordinate2D, animal: Animal){
        self.coordinate = coordinate
        self.animal = animal
        super.init()
    }
}
