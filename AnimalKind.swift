//
//  AnimalKind.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 04/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

struct AnimalKind{
    enum AnimalClass{
        case actinopterygii
        case chondrichthyes
        case amphibia
        case arachnida
        case diplopoda
        case insecta
        case mollusca
        case mammalia
        case otherInvertebrate
        case reptilia
        case aves
        
        var name: String {
            switch self {
            case .actinopterygii:
                return NSLocalizedString("actinopterygii", comment: "")
            case .chondrichthyes:
                return NSLocalizedString("chondrichthyes", comment: "")
            case .amphibia:
                return NSLocalizedString("amphibia", comment: "")
            case .arachnida:
                return NSLocalizedString("arachnida", comment: "")
            case .diplopoda:
                return NSLocalizedString("diplopoda", comment: "")
            case .insecta:
                return NSLocalizedString("insecta", comment: "")
            case .mollusca:
                return NSLocalizedString("mollusca", comment: "")
            case .mammalia:
                return NSLocalizedString("mammalia", comment: "")
            case .otherInvertebrate:
                return NSLocalizedString("otherInvertebrate", comment: "")
            case .reptilia:
                return NSLocalizedString("reptilia", comment: "")
            case .aves:
                return NSLocalizedString("aves", comment: "")
            }
        }
        
        var id: Int{
            switch self {
            case .actinopterygii:
                return 5
            case .chondrichthyes:
                return 6
            case .amphibia:
                return 4
            case .arachnida:
                return 10
            case .diplopoda:
                return 0
            case .insecta:
                return 8
            case .mollusca:
                return 7
            case .mammalia:
                return 1
            case .otherInvertebrate:
                return 9
            case .reptilia:
                return 3
            case .aves:
                return 2
            }
        }
    }
    
    let classOfAnimals: AnimalClass
    let kindName: String
}

extension AnimalKind {
    static var allCases: [AnimalKind]{
        return []
    }
    
    var title: String{
        return classOfAnimals.name
    }
    
    var subTitle: String{
        return kindName
    }
}
