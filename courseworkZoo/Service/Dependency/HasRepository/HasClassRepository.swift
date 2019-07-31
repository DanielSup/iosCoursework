//
//  HasClassRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 18/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 Protocol for getting the repository for working with categories of animals such as getting the list of classes and getting the list of orders in the class.
 */
protocol HasClassRepository {
    var classRepository: ClassRepositoring { get }
}
