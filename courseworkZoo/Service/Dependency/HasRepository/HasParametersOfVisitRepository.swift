//
//  HasParametersOfVisitRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 12/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 Protocol for getting the repository for setting the parameters of the actual visit of the ZOO (walk speed and time spent at one animal).
*/
protocol HasParametersOfVisitRepository {
    var parametersOfVisitRepository: ParametersOfVisitRepositoring { get }
}
