//
//  SettingParametersOfVisitViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 12/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model fot the screen for setting the parameters of the actual visit of the ZOO (walk speed and time spent at one animal).
 */
class SettingParametersOfVisitViewModel: BaseViewModel {
    typealias Dependencies = HasParametersOfVisitRepository & HasVoiceSettingsRepository & HasSpeechService
    
    /// The object with dependencies important for the actions in this view model.
    private var dependencies: Dependencies
    
    // MARK - Actions
    
    /**
     This action returns the walk speed during the visit of the ZOO.
    */
    lazy var getWalkSpeed = Action<(), Float, Error>{
        [unowned self] in
        return self.dependencies.parametersOfVisitRepository.getWalkSpeed()
    }
    
    /**
     This action returns the time spent at one animal during the visit of the ZOO.
    */
    lazy var getTimeSpentAtOneAnimal = Action<(), Float, Error>{
        [unowned self] in
        return self.dependencies.parametersOfVisitRepository.getTimeSpentAtOneAnimal()
    }
    
    /**
     This action returns a signal producer with a boolean representing whether the voice for machine-reading is on (true) or off (false).
     */
    lazy var isVoiceOn = Action<(), Bool, Error> { [unowned self] in
        return self.dependencies.voiceSettingsRepository.isVoiceOn()
    }
    
    
    /**
     This action returns a signal producer with the boolean representing whether other infromation and instructions from the guide are said.
     */
    lazy var isInformationFromGuideSaid = Action<(), Bool, Error> { [unowned self] in
        return self.dependencies.voiceSettingsRepository.isInformationFromGuideSaid()
    }
    
    
    // MARK - Constructor and other methods
    
    /**
     - Parameters:
        - dependencies: The object with dependencies important for the action in this view model.
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
    
    
    /**
     This function ensures setting the parameters of the visit of the ZOO.
     - Parameters:
        - walkSpeed: The walk speed during the visit of the ZOO.
        - timeSpentAtOneAnimal: The time spent at any one animal during the visit of the ZOO.
    */
    func setParameters(walkSpeed: Float, timeSpentAtOneAnimal: Float){
        self.dependencies.parametersOfVisitRepository.setParameters(walkSpeed: walkSpeed, timeSpentAtOneAnimal: timeSpentAtOneAnimal)
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
