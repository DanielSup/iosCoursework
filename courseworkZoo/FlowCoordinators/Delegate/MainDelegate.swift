//
//  MainDelegate.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 26/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This protocol ensures going to different screens (list of animals, selection of the target locality and settings the machine-read information) from the main screen.
 */
protocol MainDelegate: class {
    func goToLexicon(in viewController: BaseViewController)
    func goToSelectAnimalsToPath(in viewController: BaseViewController)
    func goToChooseSavedPath(in viewController: BaseViewController)
    func goToSettingParametersOfVisit(in viewController: BaseViewController)
    func goToSelectInformation(in viewController: BaseViewController)
    func goToAnimalDetail(in viewConotroller: BaseViewController, to animal: Animal)
    func goToHelp(in viewController: BaseViewController)
}
