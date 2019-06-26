//
//  GoToAnimalDetailDelegate.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 26/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

protocol GoToAnimalDetailDelegate: class{
    func goToAnimalDetail(in viewController: BaseViewController, to animal: Animal)
}
