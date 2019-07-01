//
//  Continent.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 04/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

enum Continent: String, Codable {
    case europe = "Evropa"
    case asia = "Asie"
    case africa = "Afrika"
    case southAmerica = "Jižní Amerika"
    case northAmerica = "Severní Amerika"
    case australia = "Austrálie"
    case notInNature = "V přírodě nežije"
    case none = ""
    
    var title: String{
        switch self {
            case .europe:
                return NSLocalizedString("europe", comment: "")
            case .asia:
                return NSLocalizedString("asia", comment: "")
            case .africa:
                return NSLocalizedString("africa", comment: "")
            case .southAmerica:
                return NSLocalizedString("southAmerica", comment: "")
            case .northAmerica:
                return NSLocalizedString("northAmerica", comment: "")
            case .australia:
                return NSLocalizedString("australia", comment: "")
            case .notInNature:
                return NSLocalizedString("notInNature", comment: "")
            case .none:
                return ""
        }
    }
    
    
    static func continentWithId(id: Int) -> Continent{
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
