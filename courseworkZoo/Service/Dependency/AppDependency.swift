//
//  AppDependency.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit


/**
 This class is used for injection of some dependencies (especially repositories and services) to other code (especially ViewModels and ViewControllers)
 */
class AppDependency {
    private init() {}
    /// instance of AppDependency class used for dependency injection
    static let shared = AppDependency()
    
    lazy var animalRepository:AnimalRepositoring =  AnimalRepository()
    lazy var localityRepository:LocalityRepositoring =  LocalityRepository()
    lazy var speechService: SpeechServicing = SpeechService(language: Locale.current.identifier)
    lazy var biotopeBindingRepository: BiotopeBindingRepositoring = BiotopeBindingRepository()
    lazy var foodBindingRepository: FoodBindingRepositoring = FoodBindingRepository()
    lazy var continentBindingRepository: ContinentBindingRepositoring = ContinentBindingRepository()
}

extension AppDependency: HasAnimalRepository{}
extension AppDependency: HasLocalityRepository{}
extension AppDependency: HasSpeechService{}
extension AppDependency: HasContinentBindingsRepository{}
extension AppDependency: HasBiotopeBindingsRepository{}
extension AppDependency: HasFoodBindingsRepository{}

