//
//  InformationOptions.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 29/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit


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
