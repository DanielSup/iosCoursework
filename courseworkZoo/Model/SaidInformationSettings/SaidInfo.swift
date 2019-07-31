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
                return NSLocalizedString("actualitiesSetting", comment: "")
            case .description:
                return NSLocalizedString("descriptionSetting", comment: "")
            case .biotopes:
                return NSLocalizedString("biotopesSetting", comment: "")
            case .continents:
                return NSLocalizedString("continentsSetting", comment: "")
            case .food:
                return NSLocalizedString("foodSetting", comment: "")
            case . proportions:
                return NSLocalizedString("proportionsSetting", comment: "")
            case .reproduction:
                return NSLocalizedString("reproductionSetting", comment: "")
            case .attractions:
                return NSLocalizedString("attractionsSetting", comment: "")
            case .breeding:
                return NSLocalizedString("breedingSetting", comment: "")
        }
    }
    
    /**
     This variable returns a list of all cases of this enum in the writter order.
    */
    static var values: [SaidInfo]{
        return [.actualities, .description, .biotopes, .continents, .food, .proportions, .reproduction, .attractions, .breeding]
    }
}
