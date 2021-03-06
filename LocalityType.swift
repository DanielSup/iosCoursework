//
//  LocalityType.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 04/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This enum represents a possible type of a locality (pavilion, exposure, refreshment or other localities).
 */
enum LocalityType: Int, Codable {
    case pavilion = 1
    case exposure = 2
    case refreshment = 3
    case other = 4
}
