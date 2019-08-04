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
                return L10n.partsOfPlants
            case .livePrey:
                return L10n.livePrey
            case .corpses:
                return L10n.corpses
            case .plankton:
                return L10n.plankton
            case .plantsAndAnimals:
                return L10n.plantsAndAnimals
            case .invertebrates:
                return L10n.invertebrates
            case .fish:
                return L10n.fish
            case .seeds:
                return L10n.seeds
            case .fruits:
                return L10n.fruits
        }
    }
    
    /// The original name of the continent in the Czech language.
    var czechOriginalTitle: String {
        switch self {
            case .partsOfPlants:
                return "části rostlin"
            case .livePrey:
                return "živá kořist"
            case .corpses:
                return "zdechliny"
            case .plankton:
                return "plankton"
            case .plantsAndAnimals:
                return "rostliny i živočichové"
            case .invertebrates:
                return "bezobratlí"
            case .fish:
                return "ryby"
            case .seeds:
                return "semena"
            case .fruits:
                return "plody"
        }
    }
    
    
    /**
    This property returns the instrumental of the title of the kind of food.
     */
    var instrumentalOfTitle: String {
        switch self {
            case .partsOfPlants:
                return L10n.byPartsOfPlants
            case .livePrey:
                return L10n.byLivePrey
            case .corpses:
                return L10n.byCorpses
            case .plankton:
                return L10n.byPlankton
            case .plantsAndAnimals:
                return L10n.byPlantsAndAnimals
            case .invertebrates:
                return L10n.byInvertebrates
            case .fish:
                return L10n.byFish
            case .seeds:
                return L10n.bySeeds
            case .fruits:
                return L10n.byFruits
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
