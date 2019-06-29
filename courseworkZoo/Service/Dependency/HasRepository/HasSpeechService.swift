//
//  HasSpeechService.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 27/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 Protocol for getting the speech service for machine speaking information about animals or localities.
 */
protocol HasSpeechService{
    var speechService: SpeechServicing { get }
}
