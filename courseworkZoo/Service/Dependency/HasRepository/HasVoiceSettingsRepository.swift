//
//  HasVoiceSettingsRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 09/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 Protocol for getting the repository for settings the information about voice (whether the voice is on or off) and machine-reading.
 */
protocol HasVoiceSettingsRepository {
    var voiceSettingsRepository: VoiceSettingsRepositoring { get }
}
