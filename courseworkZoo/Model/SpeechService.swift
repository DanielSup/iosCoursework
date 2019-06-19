//
//  SpeechService.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 17/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechService: NSObject {
    let language: String
    init(language: String){
        self.language = language
    }
    func sayText(text: String){
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: self.language)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        while(synth.isSpeaking){
            synth.continueSpeaking()
        }
    }
}
