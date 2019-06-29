//
//  LoadedEntity.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 29/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

protocol LoadedEntity: Codable {
    static var relativeUrl: String {get}
}
