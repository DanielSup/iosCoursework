//
//  Actuality.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 17/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This struct represents an actuality saved at an animal which is the actuality about. This struct is a child of LoadedEntity which is a child of Codable.
 */
class Actuality: Codable {
    let title: String
    let perex: String
    let textOfArticle: String
    
    
    enum CodingKeys: String, CodingKey{
        case title, perex, textOfArticle
    }
    
}
