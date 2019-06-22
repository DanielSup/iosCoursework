//
//  SettingsInformationViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

class SettingsInformationViewModel: BaseViewModel {
    private static let key="SettingsInformationAboutAnimals"
    private static var actualSettings: SaidInformationSettings = SaidInformationSettings.elementary(ElementaryInformationOptions.titleNewsAndDescription)
    static func setActualSettings(_ newSettings: SaidInformationSettings){
        actualSettings = newSettings
        UserDefaults.standard.set(newSettings.rawValue, forKey: key)
        UserDefaults.standard.synchronize()
    }
    static func getActualSettings() -> SaidInformationSettings{
        if let settings = UserDefaults.standard.string(forKey: key){
            for actualCase in SaidInformationSettings.allCases{
                if(actualCase.rawValue == settings){
                    actualSettings = actualCase
                    break
                }
            }
        }
        return actualSettings
    }
    
}
