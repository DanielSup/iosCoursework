//
//  HasLocalityRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 27/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 Protocol for getting the locality repository.
 */
protocol HasLocalityRepository {
    var localityRepository: LocalityRepositoring { get }
}
