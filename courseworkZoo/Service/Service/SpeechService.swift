//
//  SpeechService.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 17/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import AVFoundation

protocol HasSpeechService{
    var speechService: SpeechServicing { get }
}

protocol SpeechServicing{
    func sayText(text: String)
}

class SpeechService: SpeechServicing {
    let language: String
    init(language: String){
        self.language = language
    }
    func sayText(text: String){
        print(text)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: self.language)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        while(synth.isSpeaking){
            synth.continueSpeaking()
        }
    }
}
