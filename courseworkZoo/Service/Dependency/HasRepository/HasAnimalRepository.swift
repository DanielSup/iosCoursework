//
//  HasAnimalRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 27/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 Protocol for getting the animal repository.
 */
protocol HasAnimalRepository {
    var animalRepository: AnimalRepositoring { get }
}
