//
//  SavePathViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 11/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This view model is used for the popover view controller for saving the actual path.
*/
class SavePathViewModel: BaseViewModel {
    typealias Dependencies = HasPathRepository & HasSpeechService & HasVoiceSettingsRepository
    
    // The object with the path repository for saving paths and the speech service for machine-reading of a text when the actual path was saved.
    private var dependencies: Dependencies
    
    // MARK - Actions
    
    
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
        - dependencies: The object with a path repository for saving paths.
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
    
    /**
     This function ensures saving the actual path with the given title.
     - Parameters:
        - title: The title which we save the actual path with.
    */
    func saveActualPath(with title: String){
        self.dependencies.pathRepository.saveActualPath(with: title)
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
    
    
    func stopSpeaking() {
        self.dependencies.speechService.stopSpeaking()
    }
}
