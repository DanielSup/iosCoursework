//
//  VoiceSettingsRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 09/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This protocol is used for dependency injection. This protocol ensures working with voice setting repositories.
*/
protocol VoiceSettingsRepositoring{
    func isVoiceOn() -> SignalProducer<Bool, Error>
    func turnVoiceOnOrOff()
    func getActualInformationSetting() -> SignalProducer<[SaidInfo: Bool], Error>
    func isInformationFromGuideSaid() -> SignalProducer<Bool, Error>
    func setActualInformationSetting(_ informationSetting: [SaidInfo: Bool])
}

/**
 This class is used for saving information about machine-reading and whether the voice is on or off.
*/
class VoiceSettingsRepository: VoiceSettingsRepositoring{
    /// The key which we save information about the turned on or turned off voice with.
    private static let key="VoiceSettingsVoiceOn"
    /// The key which we save an array in which is saved for each information whether it will be machine-read
    private static let informationSettingKey = "SettingInformationAboutAnimals"
    /// The boolean representing whether the voice is on or off. If this boolean is false, the voice is off.
    private var voiceOn: Bool = false
    
    /**
     This function returns whether the voice is on or off. This function never returns an error.
     - Returns: A signal producer with aboolean representing whether the voice is on or off.
    */
    func isVoiceOn() -> SignalProducer<Bool, Error>{
        self.voiceOn = UserDefaults.standard.bool(forKey: VoiceSettingsRepository.key)
        return SignalProducer(value: self.voiceOn)
    }
    
    /**
     This function ensures turning the voice on if the voice is turned off or turning off if the voice is turned on.
    */
    func turnVoiceOnOrOff(){
        self.voiceOn = !self.voiceOn
        UserDefaults.standard.set(self.voiceOn, forKey: VoiceSettingsRepository.key)
        UserDefaults.standard.synchronize()
    }
    
    /**
     This function returns the actual setting of the machine-read information as a dictionary where values are SaidInfo cases and values are booleans. This function constructs this dictionary from the array of booleans saved in UserDefaults.
     - Returns: The actual setting of the machine-read information as a dictionary where values are SaidInfo cases and values are booleans.
     */
    func getActualInformationSetting() -> SignalProducer<[SaidInfo : Bool], Error> {
        if let informationSettingValues = UserDefaults.standard.array(forKey: VoiceSettingsRepository.informationSettingKey) as? [Bool] {
            
            var informationSetting: [SaidInfo: Bool] = [:]
            informationSetting[SaidInfo.actualities] = informationSettingValues[0]
            informationSetting[SaidInfo.description] = informationSettingValues[1]
            informationSetting[SaidInfo.biotopes] = informationSettingValues[2]
            informationSetting[SaidInfo.continents] = informationSettingValues[3]
            informationSetting[SaidInfo.food] = informationSettingValues[4]
            informationSetting[SaidInfo.proportions] = informationSettingValues[5]
            informationSetting[SaidInfo.reproduction] = informationSettingValues[6]
            informationSetting[SaidInfo.attractions] = informationSettingValues[7]
            informationSetting[SaidInfo.breeding] = informationSettingValues[8]
            informationSetting[SaidInfo.informationFromGuide] = informationSettingValues[9]
            
            return SignalProducer(value: informationSetting)
        } else {
            
            var informationSetting: [SaidInfo: Bool] = [:]
            informationSetting[SaidInfo.actualities] = true
            informationSetting[SaidInfo.description] = true
            informationSetting[SaidInfo.biotopes] = false
            informationSetting[SaidInfo.continents] = false
            informationSetting[SaidInfo.food] = false
            informationSetting[SaidInfo.proportions] = false
            informationSetting[SaidInfo.reproduction] = false
            informationSetting[SaidInfo.attractions] = false
            informationSetting[SaidInfo.breeding] = false
            informationSetting[SaidInfo.informationFromGuide] = true

            return SignalProducer(value: informationSetting)
        }
    }

    
    /**
     This function returns a signal producer with the boolean representing whether other information (not information about a close animal) and instructions from the guide not only about the close animal are said or not.
     - Returns: A signal producer with the boolean representing whether other information (not information about a close animal) and instructions from the guide a
    */
    func isInformationFromGuideSaid() -> SignalProducer<Bool, Error> {
        if let informationSettingValues = UserDefaults.standard.array(forKey: VoiceSettingsRepository.informationSettingKey) as? [Bool] {
            return SignalProducer(value: informationSettingValues[9])
        } else {
            return SignalProducer(value: true)
        }
    }
    
    /**
     This function ensures saving the actual setting of the machine-read information about animals and instructions from the guide to UserDefaults.
     - Parameters:
        - informationSetting: The dictionary representing the actual setting of the machine-read information about animals and information and instructions from the guide where keys are SaidInfo cases and values are booleans
    */
    func setActualInformationSetting(_ informationSetting: [SaidInfo : Bool]) {
        let informationSettingValues = [informationSetting[SaidInfo.actualities],
        informationSetting[SaidInfo.description],
        informationSetting[SaidInfo.biotopes],
        informationSetting[SaidInfo.continents],
        informationSetting[SaidInfo.food],
        informationSetting[SaidInfo.proportions],
        informationSetting[SaidInfo.reproduction],
        informationSetting[SaidInfo.attractions],
        informationSetting[SaidInfo.breeding],
        informationSetting[SaidInfo.informationFromGuide]]
        UserDefaults.standard.set(informationSettingValues, forKey: VoiceSettingsRepository.informationSettingKey)
        UserDefaults.standard.synchronize()
    }
}
