//
//  Path.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 10/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represents a path with animals at which want the user.
*/
class Path {
    /// The title of the path
    var title: String
    /// The list of animals in this path.
    var animals: [Animal]
    
    /**
     - Parameters:
        - title: The title of the path
        - animals: The list of animals in the path
    */
    init(title: String, animals: [Animal]){
        self.title = title
        self.animals = animals
    }
}
