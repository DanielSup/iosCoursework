//
//  ChooseSavedPathViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 10/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//


import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen for choosing a path from the saved paths.
 */
class ChooseSavedPathViewModel: BaseViewModel {
    typealias Dependencies = HasPathRepository & HasSpeechService & HasVoiceSettingsRepository
    /// The object with the path repository for working with paths (getting all paths and choosing a saved path) and the speech service for saying text when any saved path is choosed.
    private let dependencies: Dependencies
    
    // MARK - Actions
    
    /**
     This action returns a signal producer with the list of saved paths.
    */
    lazy var getAllPaths = Action<(), [Path], Error>{
        [unowned self] in
        return self.dependencies.pathRepository.getAllPaths()
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
    
    // MARK - Constructor and other functions
    
    
    /**
     - Parameters:
     - dependencies: The object with the path repository for working with paths (getting all saved paths and choosing a saved path).
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }

    /**
     This function ensures choosing the given saved path with a list of animals. The saved path contains animals which the user will visit during the visit of the ZOO.
     - Parameters:
        - path: The path with the list of animals for visit which is choosed.
    */
    func chooseSavedPath(_ path: Path){
        self.dependencies.pathRepository.selectPath(path)
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
    
    /**
     This function ensures removing the given path.
     - Parameters:
        - path: The path which must be removed.
    */
    func removePath(_ path: Path) {
        self.dependencies.pathRepository.removePath(path)
    }
}
