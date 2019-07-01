//
//  LoadedEntity.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 29/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This protocol indicates that the class implementing it is an entity loaded from the NodeJS server for this application. This protocol is used for getting the relative URL on the NodeJS server for each kind of entity (class implementing this protocol).
 */
protocol LoadedEntity: Codable {
    /// This is the relative URL for getting the relative URL on the server which entities of the given kind are loaded from.
    static var relativeUrl: String {get}
}
