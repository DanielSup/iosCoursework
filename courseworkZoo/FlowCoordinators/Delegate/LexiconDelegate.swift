//
//  LexiconDelegate.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 26/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

protocol LexiconDelegate: GoToAnimalDetailDelegate {
    func goToGuide(in viewController: BaseViewController)
    func goToClasses(in viewController: BaseViewController)
    func goToBiotopes(in viewController: BaseViewController)
    func goToPavilions(in viewController: BaseViewController)
    func goToOrders(in viewController: BaseViewController, of parentClass: Class)
    func goToAnimalsInOrder(in viewController: BaseViewController, order: Class)
    func goToAnimalsInBiotope(in viewController: BaseViewController, biotope: Biotope)
    func goToAnimalsInPavilion(in: BaseViewController, pavilion: Locality)
    func goToContinents(in viewController: BaseViewController)
    func goToAnimalsInContinent(in: BaseViewController, continent: Continent)
}
