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
enum Biotope {
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
                return NSLocalizedString("sea", comment: "")
            case .freshWater:
                return NSLocalizedString("freshWater", comment: "")
            case .desertAndSemiDesert:
                return NSLocalizedString("desertAndSemiDesert", comment: "")
            case .grassyTerritory:
                return NSLocalizedString("grassyTerritory", comment: "")
            case .mountains:
                return NSLocalizedString("mountains", comment: "")
            case .tropicalForest:
                return NSLocalizedString("tropicalForest", comment: "")
            case .deciduousAndMixedForest:
                return NSLocalizedString("deciduousAndMixedForest", comment: "")
            case .coniferousForest:
                return NSLocalizedString("coniferousForest", comment: "")
            case .tundra:
                return NSLocalizedString("tundra", comment: "")
            case .polarRegions:
                return NSLocalizedString("polarRegions", comment: "")
            case .stonyStepsAndSemiDeserts:
                return NSLocalizedString("stonyStepsAndSemiDeserts", comment: "")
            
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
