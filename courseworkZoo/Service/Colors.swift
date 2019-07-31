//
//  Colors.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 06/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This enum saves the most common colors in the user interface. It is used for getting any of the common color.
 */
enum Colors {
    case titleBackgroundColor
    case nonSelectedItemBackgroundColor
    case selectedItemBackgroundColor
    case goToGuideOrLexiconButtonBackgroundColor
    case helpButtonBackgroundColor
    case screenBodyBackgroundColor
    
    /// This property returns the UIColor object used for settings of the background color of any element on a screen. It returns the UIColor object dependent on the case
    var color: UIColor {
        switch self {
            case .titleBackgroundColor:
                return UIColor(red: 250.0 / 255.0, green: 205.0 / 255.0, blue: 145.0 / 255.0, alpha: 1.0)
            case .nonSelectedItemBackgroundColor:
                return UIColor(red: 149.0 / 255.0, green: 242.0 / 255.0, blue: 4.0 / 255.0, alpha: 1.0)
            case .selectedItemBackgroundColor:
                return UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
            case .goToGuideOrLexiconButtonBackgroundColor:
                return UIColor(red: 128.0 / 255.0, green: 1.0, blue: 1.0, alpha: 1.0)
            case .helpButtonBackgroundColor:
                return UIColor(red: 194.0 / 255.0, green: 128.0 / 255.0, blue: 1.0, alpha: 1.0)
            case .screenBodyBackgroundColor:
                return UIColor(red: 1.0, green: 1.0, blue: 0.6, alpha: 1.0)
        }
    }
}
