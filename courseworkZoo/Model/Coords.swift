//
//  Coords.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 17/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represents the visited location of a locality or an animal. It is used for saving already visited localities or animals.
 */
class Coords{
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
    }
}
