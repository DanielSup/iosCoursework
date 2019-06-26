//
//  MainDelegate.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 26/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

protocol MainDelegate: class {
    func goToAnimalListTapped(in viewController: BaseViewController)
    func goForSelectionOfLocality(in viewController: BaseViewController)
    func goToSettings(in viewController: BaseViewController)
}
