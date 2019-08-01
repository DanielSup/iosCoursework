//
//  Continent.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 04/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This enum represents in which continent the animal can live. It also can represent that an animal doesn't live in nature.
 */
enum Continent: Int {
    case africa
    case asia
    case southAmerica
    case northAmerica
    case australia
    case notInNature
    case europe
    case none
    
    /// The localized title of the continent or string representing an information that an animal doesn't live in nature
    var title: String{
        switch self {

            case .africa:
                return NSLocalizedString("africa", comment: "")
            case .asia:
                return NSLocalizedString("asia", comment: "")
            case .southAmerica:
                return NSLocalizedString("southAmerica", comment: "")
            case .northAmerica:
                return NSLocalizedString("northAmerica", comment: "")
            case .australia:
                return NSLocalizedString("australia", comment: "")
            case .notInNature:
                return NSLocalizedString("notInNature", comment: "")
            case .europe:
                return NSLocalizedString("europe", comment: "")
            case .none:
                return ""
        }
    }
    
    /// The original name of the continent in the Czech language.
    var czechOriginalTitle: String {
        switch self {
            case .africa:
                return "Afrika"
            case .asia:
                return "Asie"
            case .southAmerica:
                return "Jižní Amerika"
            case .northAmerica:
                return "Severní Amerika"
            case .australia:
                return "Austrálie"
            case .notInNature:
                return "v přírodě nežije"
            case .europe:
                return "Evropa"
            case .none:
                return ""
        }
    }
    
    /// The locative with prepositions (and other words) of the continent in which animals can live. The locative with a preposition is used in the title of the screen with the list of animals living in the given continent or list of animals which don't live anywhere in nature.
    var locativeWithPreposition: String {
        switch self {
            case .africa:
                return NSLocalizedString("inAfrica", comment: "")
            case .asia:
                return NSLocalizedString("inAsia", comment: "")
            case .southAmerica:
                return NSLocalizedString("inSouthAmerica", comment: "")
            case .northAmerica:
                return NSLocalizedString("inNorthAmerica", comment: "")
            case .australia:
                return NSLocalizedString("inAustralia", comment: "")
            case .notInNature:
                return NSLocalizedString("notAnywhere", comment: "")
            case .europe:
                return NSLocalizedString("inEurope", comment: "")
            case .none:
                return NSLocalizedString("notAnywhere", comment: "")
        }
    }
    
    /**
     This function returns the continent with the given identificator.
     - Parameters:
        - id: The identificator of the continent
     - Returns: The continent with the given identificator.
    */
    static func getContinentWithId(id: Int) -> Continent{
        switch id{
            case 1:
                return .africa
            case 2:
                return .asia
            case 3:
                return .southAmerica
            case 4:
                return .northAmerica
            case 5:
                return .australia
            case 6:
                return .notInNature
            case 7:
                return .europe
            default:
                return .none
        }
    }
}



extension Continent: Equatable{
    static func==(lhs: Continent, rhs: Continent) -> Bool{
        switch(lhs,rhs){
        case(.europe, .europe):
            return true
        case (.asia, .asia):
            return true
        case (.africa, .africa):
            return true
        case (.southAmerica, .southAmerica):
            return true
        case (.northAmerica, .northAmerica):
            return true
        case (.australia, .australia):
            return true
        case (.notInNature, .notInNature):
            return true
        case (.none, .none):
            return true
        case (.none, .notInNature):
            return true
        case (.notInNature, .none):
            return true
        default:
            return false
        }
    }
}
