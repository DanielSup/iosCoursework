//
//  SettingsInformationViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit


/**
 This class is a view model for the screen for settigs the machinely-read information about the close animal. This class ensures the settings the machine-read information about the close animal
 */
class SettingsInformationViewModel: BaseViewModel {
    /// The key which the user settings of machine-read information is saved with.
    private static let key="SettingsInformationAboutAnimals"
    /// The default settings of the machine-read information. By default, the title, news and the description of the animal are machine-read.
    private static var actualSettings: SaidInformationSettings = SaidInformationSettings.elementary(ElementaryInformationOptions.titleNewsAndDescription)
    
    
    /**
     This function ensures setting the machine-read information and saving the user setting.
     - Parameters:
        - newSettings: The case of enum representing the settings the machine-read information.
    */
    static func setActualSettings(_ newSettings: SaidInformationSettings){
        actualSettings = newSettings
        UserDefaults.standard.set(newSettings.rawValue, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    /**
     This function returns the actual user setting of the machine-read information.
     - Returns: The actual user setting of the machine-read information.
    */
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
