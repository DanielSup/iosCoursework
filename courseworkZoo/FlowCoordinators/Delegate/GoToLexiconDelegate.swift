//
//  GoToLexiconDelegate.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 10/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This protocol ensures going to the lexicon part of the application from any screen of the guide part of the application.
 */
protocol GoToLexiconDelegate: class {
    func goToLexicon(in viewController: BaseViewController)
}
