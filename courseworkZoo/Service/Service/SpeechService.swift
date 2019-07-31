//
//  SpeechService.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 17/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import AVFoundation


/**
 Protocol used for speech service.
 */
protocol SpeechServicing{
    func sayText(text: String)
    func setStartCallback(callback: @escaping(() -> Void))
    func setFinishCallback(callback: @escaping(() -> Void))
}

/**
 This class is concrete implementation of speech service. This class ensures machine speaking of text with informations about animals or localities.
 */
class SpeechService: NSObject, SpeechServicing {
    /// The language used for machine speaking
    let language: String
    /// The synth object which ensures the machine-reading.
    let synth = AVSpeechSynthesizer()
    /// The callback of the function which is called after the start of the machine-reading.
    private var startCallback: () -> Void = { print("start") }
    /// The callback of the function which is called after the end of the machine-reading.
    private var finishCallback: () -> Void = { print("finish") }
    
    /**
     - Parameters:
        - language: The language which is used for machine speaking
     */
    init(language: String){
        self.language = language
        super.init()
        synth.delegate = self
    }
    
    /**
     This function stores the callback of the function which is called after the start of the machine-reading of a text.
     - Parameters:
        - callback: The callback of the function which is called after the end of the machine-reading of a text.
    */
    func setStartCallback(callback: @escaping (() -> Void)) {
        self.startCallback = callback
    }
    
    /**
     This function stores the callback of the function which is called after the end of the machine-reading of a text.
     - Parameters:
        - callback: The callback of the function which is called after the end of the machine-reading of a text.
    */
    func setFinishCallback(callback: @escaping(() -> Void)) {
        self.finishCallback = callback
    }
    
    /**
     This function ensures the machine speaking of the given text. The text is usually about an animal or a locality.
     - Parameters:
        - text: The text which will be read by machine
     */
    func sayText(text: String){
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: self.language)
        synth.speak(utterance)
    }
}



extension SpeechService: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.startCallback()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.finishCallback()
    }
}
