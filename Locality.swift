//
//  Locality.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 04/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This struct represents a locality which can be loaded from the NodeJS server. This struct is a child of LoadedEntity which is a child of Codable.
 */
class Locality: LoadedEntity{
    static var relativeUrl: String = Constants.localitiesRelativeUrl
    
    let id: Int
    let title: String
    let alias: String
    let localityType: LocalityType
    let latitude: Double
    let longitude: Double
    
    
    enum CodingKeys: String, CodingKey{
        case id, title, alias, localityType = "type", latitude = "gps_x", longitude = "gps_y"
    }
    
}


