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
}

/**
 This class is concrete implementation of speech service. This class ensures machine speaking of text with informations about animals or localities.
 */
class SpeechService: SpeechServicing {
    /// The language used for machine speaking
    let language: String
    
    /**
     - Parameters:
        - language: The language which is used for machine speaking
     */
    init(language: String){
        self.language = language
    }
    
    /**
     This function ensures the machine speaking of the given text. The text is usually about an animal or a locality.
     - Parameters:
        - text: The text which will be read by machine
     */
    func sayText(text: String){
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: self.language)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
}
