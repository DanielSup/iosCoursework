//
//  SelectInformationViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 14/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen for selecting information about a close animal which will be machine-read.
 */
class SelectInformationViewModel: BaseViewModel {
    typealias Dependencies = HasVoiceSettingsRepository
    /// The object with important dependencies for the setting and getting the information which will be machine-read.
    private var dependencies: Dependencies
    
    /**
     This is the action for getting the information which will be machine read.
    */
    lazy var getInformationSettingAction = Action<(), [SaidInfo: Bool], Error>{
        return self.dependencies.voiceSettingsRepository.getActualInformationSetting()
    }
    
    /**
     - Parameters:
     - dependencies: The object with important dependencies for the setting and getting the information which will be machine-read.
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
    
    /**
     This function ensures setting the information which will be machine-read by the given dictionary where keys are SaidInfo cases representing a piece of information and booleans representing whether the information will be machine-read or not.
     - Parameters:
        - informationSetting: The dictionary where is saved for each piece of information about a close animal whether it will be machine-read or not.
    */
    func setInformationSetting(_ informationSetting: [SaidInfo: Bool]){
        self.dependencies.voiceSettingsRepository.setActualInformationSetting(informationSetting)
    }
}
