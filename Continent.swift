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
                return L10n.africa
            case .asia:
                return L10n.asia
            case .southAmerica:
                return L10n.southAmerica
            case .northAmerica:
                return L10n.northAmerica
            case .australia:
                return L10n.australia
            case .notInNature:
                return L10n.notInNature
            case .europe:
                return L10n.europe
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
                return L10n.inAfrica
            case .asia:
                return L10n.inAsia
            case .southAmerica:
                return L10n.inSouthAmerica
            case .northAmerica:
                return L10n.inNorthAmerica
            case .australia:
                return L10n.inAustralia
            case .notInNature:
                return L10n.notAnywhere
            case .europe:
                return L10n.inEurope
            case .none:
                return L10n.notAnywhere
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
