//
//  SaidInfo.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 29/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This enum is used for selection of information about close animal which are machinely said. It determines what will be machinely read when we are close to an animal.
 */
enum SaidInfo: CaseIterable{
    case actualities
    case description
    case biotopes
    case continents
    case food
    case proportions
    case reproduction
    case attractions
    case breeding
    
    /**
     This variable returns a suitable title for the given case.
    */
    var title: String {
        switch (self){
            case .actualities:
                return L10n.actualitiesSetting
            case .description:
                return L10n.descriptionSetting
            case .biotopes:
                return L10n.biotopesSetting
            case .continents:
                return L10n.continentsSetting
            case .food:
                return L10n.foodSetting
            case . proportions:
                return L10n.proportionsSetting
            case .reproduction:
                return L10n.reproductionSetting
            case .attractions:
                return L10n.attractionsSetting
            case .breeding:
                return L10n.breedingSetting
        }
    }
    
    /**
     This variable returns a list of all cases of this enum in the writter order.
    */
    static var values: [SaidInfo]{
        return [.actualities, .description, .biotopes, .continents, .food, .proportions, .reproduction, .attractions, .breeding]
    }
}
