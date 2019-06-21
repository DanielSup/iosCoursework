//
//  AppDependency.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

protocol HasNoDependency {
    
}

class AppDependency: HasNoDependency {
    private init() {}
    static let shared = AppDependency()
    
    lazy var animalRepository:AnimalRepositoring =  AnimalRepository()
    lazy var localityRepository:LocalityRepositoring =  LocalityRepository()
    lazy var speechService: SpeechServicing = SpeechService(language: Locale.current.identifier)
}

extension AppDependency: HasAnimalRepository{}
extension AppDependency: HasLocalityRepository{}
extension AppDependency: HasSpeechService{}

