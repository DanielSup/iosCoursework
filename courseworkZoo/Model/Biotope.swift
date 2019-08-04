//
//  Biotope.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This enum represent a biotope in which animals can live.
 */
enum Biotope: Int {
    case sea
    case freshWater
    case desertAndSemiDesert
    case grassyTerritory
    case mountains
    case tropicalForest
    case deciduousAndMixedForest
    case coniferousForest
    case tundra
    case polarRegions
    case stonyStepsAndSemiDeserts
    
    
    /// The localized title of the biotope in which animals can live.
    var title: String{
        switch self {
            case .sea:
                return L10n.sea
            case .freshWater:
                return L10n.freshWater
            case .desertAndSemiDesert:
                return L10n.desertAndSemiDesert
            case .grassyTerritory:
                return L10n.grassyTerritory
            case .mountains:
                return L10n.mountains
            case .tropicalForest:
                return L10n.tropicalForest
            case .deciduousAndMixedForest:
                return L10n.deciduousAndMixedForest
            case .coniferousForest:
                return L10n.coniferousForest
            case .tundra:
                return L10n.tundra
            case .polarRegions:
                return L10n.polarRegions
            case .stonyStepsAndSemiDeserts:
                return L10n.stonyStepsAndSemiDeserts
            
        }
    }
    
    
    /// The original name of the biotope in the Czech language.
    var czechOriginalTitle: String {
        switch self {
            case .sea:
                return "moře"
            case .freshWater:
                return "sladké vody"
            case .desertAndSemiDesert:
                return "poušť a polopoušť"
            case .grassyTerritory:
                return "travnaté území"
            case .mountains:
                return "hory"
            case .tropicalForest:
                return "tropický les"
            case .deciduousAndMixedForest:
                return "listnatý a smíšený les"
            case .coniferousForest:
                return "jehličnatý les"
            case .tundra:
                return "tundra"
            case .polarRegions:
                return "polární oblasti"
            case .stonyStepsAndSemiDeserts:
                return "kamenité stepi a polopouště"
            
        }
    }
    
    
    /// The locative with a preposition of the biotope in which animals can live. The locative with a preposition is used in the title of the screen with the list of animals living in the given biotope.
    var locativeWithPreposition: String {
        switch self {
            case .sea:
                return L10n.inSea
            case .freshWater:
                return L10n.inFreshWater
            case .desertAndSemiDesert:
                return L10n.inDesertAndSemiDesert
            case .grassyTerritory:
                return L10n.inGrassyTerritory
            case .mountains:
                return L10n.inMountains
            case .tropicalForest:
                return L10n.inTropicalForest
            case .deciduousAndMixedForest:
                return L10n.inDeciduousAndMixedForest
            case .coniferousForest:
                return L10n.inConiferousForest
            case .tundra:
                return L10n.inTundra
            case .polarRegions:
                return L10n.inPolarRegions
            case .stonyStepsAndSemiDeserts:
                return L10n.inStonyStepsAndSemiDeserts
            
        }
    }
    
    /**
     This function returns the biotope with the given identificator.
     - Parameters:
        - id: The identificator of the given biotope
     - Returns: The biotope with the given identificator.
    */
    static func getBiotopeWithId(id: Int) -> Biotope{
        switch id{
            case 1:
                return Biotope.sea
            case 2:
                return Biotope.freshWater
            case 3:
                return Biotope.desertAndSemiDesert
            case 4:
                return Biotope.grassyTerritory
            case 5:
                return Biotope.mountains
            case 6:
                return Biotope.tropicalForest
            case 7:
                return Biotope.deciduousAndMixedForest
            case 8:
                return Biotope.coniferousForest
            case 9:
                return Biotope.tundra
            case 10:
                return Biotope.polarRegions
            case 11:
                return Biotope.stonyStepsAndSemiDeserts
            default:
                return Biotope.sea
        }
    }
}
