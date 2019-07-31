//
//  Class.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 18/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
*/
class Class: LoadedEntity {
    static var relativeUrl: String = Constants.classes
    
    let id: String
    let type: String
    let parentCategory: String
    let title: String
    
    enum CodingKeys: String, CodingKey{
        case id = "a", type = "b", parentCategory = "c", title = "d"
    }
}
