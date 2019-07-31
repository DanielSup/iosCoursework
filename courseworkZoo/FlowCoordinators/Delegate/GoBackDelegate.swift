//
//  GoBackDelegate.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 26/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This protocol ensures going back to the previous screen.
 */
protocol GoBackDelegate: class{
    func goBack(in viewController: BaseViewController)
}
