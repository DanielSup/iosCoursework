//
//  HasProcessAnimalInformationService.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 15/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
Protocol for getting the service for getting the text for machine-reading (used especially in MainViewModel).
 */
protocol HasProcessAnimalInformationService{
    var processAnimalInformationService: ProcessAnimalInformationServicing { get }
}
