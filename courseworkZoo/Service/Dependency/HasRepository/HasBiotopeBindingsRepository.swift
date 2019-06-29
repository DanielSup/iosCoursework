//
//  HasBiotopeBindingsRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 27/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 Protocol for getting the repository for working with information about animals and biotopes in which animals live.
 */
protocol HasBiotopeBindingsRepository {
    var biotopeBindingRepository: BiotopeBindingRepositoring {  get }
}
