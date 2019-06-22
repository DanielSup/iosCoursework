//
//  SaidInformatinoSettings.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

precedencegroup AlmostEqualPrecedence{
    associativity: left
    higherThan: ComparisonPrecedence
}

infix operator =+-=: AlmostEqualPrecedence
infix operator !=+-=: AlmostEqualPrecedence

protocol AlmostEquatable{
    static func =+-=(lhs: Self, rhs: Self) -> Bool
}

extension AlmostEquatable {
    static func !=+-=(lhs: Self, rhs: Self) -> Bool {
        return !(lhs =+-= rhs)
    }
}

enum SaidInfo{
    case title
    case news
    case description
    case biotopes
    case continents
    case spread
    case food
    
    case proportions
    case reproduction
    case attractions
    case breeding
}

enum ElementaryInformationOptions: String, CaseIterable{
    case onlyTitleAndNews = "onlyTitleAndNews"
    case titleNewsAndDescription = "titleNewsAndDescription"
    case allElementaryInformation = "allElementaryInformation"
    var saidInfo: [SaidInfo]{
        switch self{
            case .onlyTitleAndNews:
                return [SaidInfo.title, SaidInfo.news]
            case .titleNewsAndDescription:
                return [SaidInfo.title, SaidInfo.news, SaidInfo.description]
            case .allElementaryInformation:
                return [SaidInfo.title, SaidInfo.news, SaidInfo.description, SaidInfo.biotopes, SaidInfo.continents, SaidInfo.spread]
        }
    }
}

enum AdvancedInformationOptions: String, CaseIterable{
    case withoutAttractionsAndBreeding = "withoutAttractionsAndBreeding"
    case withoutAttractions = "withoutAttractions"
    case withoutBreeding = "withoutBreeding"
    case allInformation = "allInformation"
    var saidInfo: [SaidInfo]{
        switch self {
        case .withoutAttractionsAndBreeding:
            return [SaidInfo.title, SaidInfo.news, SaidInfo.description, SaidInfo.biotopes, SaidInfo.continents, SaidInfo.spread, SaidInfo.food, SaidInfo.proportions, SaidInfo.reproduction]
        case .withoutBreeding:
            return [SaidInfo.title, SaidInfo.news, SaidInfo.description, SaidInfo.biotopes, SaidInfo.continents, SaidInfo.spread, SaidInfo.food, SaidInfo.proportions, SaidInfo.reproduction, SaidInfo.attractions]
        case .withoutAttractions:
            return [SaidInfo.title, SaidInfo.news, SaidInfo.description, SaidInfo.biotopes, SaidInfo.continents, SaidInfo.spread, SaidInfo.food, SaidInfo.proportions, SaidInfo.reproduction, SaidInfo.breeding]
        case .allInformation:
            return [SaidInfo.title, SaidInfo.news, SaidInfo.description, SaidInfo.biotopes, SaidInfo.continents, SaidInfo.spread, SaidInfo.food, SaidInfo.proportions, SaidInfo.reproduction, SaidInfo.attractions, SaidInfo.breeding]
        }
    }
}

enum SaidInformationSettings: CaseIterable{
    case none
    case elementary(ElementaryInformationOptions)
    case advanced(AdvancedInformationOptions)
    var saidInfo: [SaidInfo]{
        switch self{
            case .none:
                return []
            case .elementary(let m1):
                return m1.saidInfo
            case .advanced(let m1):
                return m1.saidInfo
        }
    }
    static var allCases: [SaidInformationSettings]{
        let elementary = ElementaryInformationOptions.allCases.map { SaidInformationSettings.elementary($0) }
        let advanced = AdvancedInformationOptions.allCases.map { SaidInformationSettings.advanced($0) }
        return [.none] + elementary + advanced
    }
    
    static var sections: [SaidInformationSettings]{
        return [.none, .elementary(ElementaryInformationOptions.allElementaryInformation), .advanced(AdvancedInformationOptions.allInformation)]
    }
    var title: String{
        switch self{
        case .none:
            return "none"
        case .elementary(let m):
            return "elementary"
        case .advanced(let m):
            return "advanced"
        }
    }
    
    var subtitle: String{
        switch self{
        case .none:
            return "none"
        case .elementary(let m):
            return m.rawValue
        case .advanced(let m):
            return m.rawValue
        }
    }
    
    var rawValue: String{
        switch self{
            case .none:
                return "none"
            case .elementary(let m):
                return "elementary,"+m.rawValue
            case .advanced(let m):
                return "advanced,"+m.rawValue
        }
    }
    
}

extension SaidInformationSettings: AlmostEquatable{
    static func =+-= (lhs: SaidInformationSettings, rhs: SaidInformationSettings) -> Bool {
        switch (lhs, rhs){
        case (.none, .none):
            return true
        case (.elementary, .elementary):
            return true
        case (.advanced, .advanced):
            return true
        default:
            return false
        }
    }
    
}

extension SaidInformationSettings: Equatable{
    static func == (lhs: SaidInformationSettings, rhs: SaidInformationSettings) -> Bool {
        switch (lhs, rhs){
        case (.none, .none):
            return true
        case (.elementary(let m1), .elementary(let m2)):
            return m1 == m2
        case (.advanced(let m1), .advanced(let m2)):
            return m1 == m2
        default:
            return false
        }
    }
    
}
