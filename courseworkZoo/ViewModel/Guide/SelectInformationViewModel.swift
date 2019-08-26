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
 This class is a view model for the screen for selecting information about a close animal and other information and instructions from the guide which will be machine-read.
 */
class SelectInformationViewModel: BaseViewModel {
    typealias Dependencies = HasVoiceSettingsRepository & HasSpeechService & HasVoiceSettingsRepository

    /// The object with important dependencies for the setting and getting the information which will be machine-read.
    private var dependencies: Dependencies
    
    // MARK - Actions
    
    /**
     This is the action for getting the information which will be machine read.
    */
    lazy var getInformationSetting = Action<(), [SaidInfo: Bool], Error>{
        return self.dependencies.voiceSettingsRepository.getActualInformationSetting()
    }
    
    /**
     This action returns whether any text is machine-read now.
     */
    lazy var isMachineReadingRunning = Action<(), Bool, Error> { [unowned self] in
        return SignalProducer(value: self.dependencies.speechService.isSpeaking)
    }
    
    
    /**
     This action returns a signal producer with value whether the voice is on or off.
     */
    lazy var isVoiceOn = Action<(), Bool, Error>{ [unowned self] in
        return self.dependencies.voiceSettingsRepository.isVoiceOn()
    }
    
    /**
     This action returns a signal producer with the boolean representing whether other infromation and instructions from the guide are said.
     */
    lazy var isInformationFromGuideSaid = Action<(), Bool, Error> { [unowned self] in
        return self.dependencies.voiceSettingsRepository.isInformationFromGuideSaid()
    }
    
    // MARK - Constructor and other functions
    
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
        - informationSetting: The dictionary where is saved for each piece of information about a close animal and other information and instructions from the guide (for settings are other information and instructions from the guide represented as one information) whether it will be machine-read or not.
    */
    func setInformationSetting(_ informationSetting: [SaidInfo: Bool]){
        self.dependencies.voiceSettingsRepository.setActualInformationSetting(informationSetting)
    }
    
    /**
     This function ensures saying the given text.
     - Parameters:
     - text: The text which is machine-read.
     */
    func sayText(_ text: String) {
        self.dependencies.speechService.sayText(text)
    }
    
    
    /**
     This function set callback for the speech service. The first callback is called after starting the machine-reading and the second callback is called after the end of the machine-reading.
     - Parameters:
     - startCallback: The callback which is called after the start of the machine-reading.
     - finishCallback: The callback which is called after the end of the machine-reading
     */
    func setCallbacksOfSpeechService(startCallback: @escaping(() -> Void), finishCallback: @escaping(() -> Void)){
        self.dependencies.speechService.setStartCallback(callback: startCallback)
        self.dependencies.speechService.setFinishCallback(callback: finishCallback)
    }
    
    
    /**
     This function ensures stopping the machine-reading of the previous text.
     */
    func stopSpeaking() {
        self.dependencies.speechService.stopSpeaking()
    }
}
