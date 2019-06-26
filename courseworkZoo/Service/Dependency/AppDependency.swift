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
    lazy var biotopeBindingRepository: BindingRepository<BiotopeBinding> = BindingRepository<BiotopeBinding>(url: Constants.biotopesBindings)
    lazy var foodBindingRepository: BindingRepository<FoodBinding> = BindingRepository<FoodBinding>(url: Constants.foodBindings)
    lazy var continentBindingRepository: BindingRepository<ContinentBinding> = BindingRepository<ContinentBinding>(url: Constants.continentsBindings)
}

extension AppDependency: HasAnimalRepository{}
extension AppDependency: HasLocalityRepository{}
extension AppDependency: HasSpeechService{}
extension AppDependency: HasContinentBindingsRepository{}
extension AppDependency: HasBiotopeBindingsRepository{}
extension AppDependency: HasFoodBindingsRepository{}

