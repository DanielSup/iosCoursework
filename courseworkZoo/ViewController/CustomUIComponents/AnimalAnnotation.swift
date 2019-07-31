//
//  AnimalAnnotation.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 17/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit

class AnimalAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var animal: Animal
    
    var title: String?
    var isSelected: Bool = false
    init(coordinate: CLLocationCoordinate2D, animal: Animal){
        self.coordinate = coordinate
        self.animal = animal
        super.init()
    }
}
