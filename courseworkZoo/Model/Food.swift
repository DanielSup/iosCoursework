//
//  Food.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This enum represent a possible kind of food which animals can eat.
 */
enum Food: Int{
    case partsOfPlants
    case livePrey
    case corpses
    case plankton
    case plantsAndAnimals
    case invertebrates
    case fish
    case seeds
    case fruits
    
    /// The localized title of the kind of food which animals can eat.
    var title: String {
        switch self {
            case .partsOfPlants:
                return NSLocalizedString("partsOfPlants", comment: "")
            case .livePrey:
                return NSLocalizedString("livePrey", comment: "")
            case .corpses:
                return NSLocalizedString("corpses", comment: "")
            case .plankton:
                return NSLocalizedString("plankton", comment: "")
            case .plantsAndAnimals:
                return NSLocalizedString("plantsAndAnimals", comment: "")
            case .invertebrates:
                return NSLocalizedString("invertebrates", comment: "")
            case .fish:
                return NSLocalizedString("fish", comment: "")
            case .seeds:
                return NSLocalizedString("seeds", comment: "")
            case .fruits:
                return NSLocalizedString("fruits", comment: "")
        }
    }
    
    /**
     This function returns a kind of food with the given identificator.
     - Parameters:
        - id: Identificator of the kind of food
     - Returns: The kind of food with the given identificator.
    */
    static func getFoodWithId(id: Int) -> Food{
        switch id {
            case 1:
                return Food.partsOfPlants
            case 2:
                return Food.livePrey
            case 3:
                return Food.corpses
            case 4:
                return Food.plankton
            case 5:
                return Food.plantsAndAnimals
            case 6:
                return Food.invertebrates
            case 7:
                return Food.fish
            case 8:
                return Food.seeds
            case 9:
                return Food.fruits
            default:
                return Food.partsOfPlants
        }
    }
}
