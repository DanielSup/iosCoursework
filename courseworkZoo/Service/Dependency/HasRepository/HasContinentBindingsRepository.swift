//
//  HasContinentBindingsRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 27/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit


/**
 Protocol for getting the repository for working with information about animals and continents in which animals live.
 */
protocol HasContinentBindingsRepository {
    var continentBindingRepository: ContinentBindingRepositoring { get }
}
