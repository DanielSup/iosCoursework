//
//  GoToAnimalDetailDelegate.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 26/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This protocol ensures going to a screen with detailed information about the given animal (for example selected animal from the list of all animals). 
 */
protocol GoToAnimalDetailDelegate: class{
    func goToAnimalDetail(in viewController: BaseViewController, to animal: Animal)
}
