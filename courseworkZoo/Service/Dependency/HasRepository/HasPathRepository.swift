//
//  HasPathRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 10/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 Protocol for getting the repository for working with paths (saving, getting all saved paths, getting the list of animals in the actual unsaved path).
 */
protocol HasPathRepository {
    var pathRepository: PathRepositoring { get }
}
