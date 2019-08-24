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
    lazy var biotopeBindingRepository: BiotopeBindingRepositoring = BiotopeBindingRepository(animalRepository: animalRepository)
    lazy var foodBindingRepository: FoodBindingRepositoring = FoodBindingRepository(animalRepository: animalRepository)
    lazy var continentBindingRepository: ContinentBindingRepositoring = ContinentBindingRepository(animalRepository: animalRepository)
    lazy var voiceSettingsRepository: VoiceSettingsRepositoring = VoiceSettingsRepository()
    lazy var pathRepository: PathRepositoring =  PathRepository(animalRepository: animalRepository)
    lazy var parametersOfVisitRepository: ParametersOfVisitRepositoring = ParametersOfVisitRepository()
    lazy var processAnimalInformationService: ProcessAnimalInformationServicing = ProcessAnimalInformationService(biotopeBindingRepository: biotopeBindingRepository, foodBindingRepository: foodBindingRepository, continentBindingRepository: continentBindingRepository)
    lazy var classRepository: ClassRepositoring = ClassRepository()
    lazy var routeWithAnimalsService: RouteWithAnimalsServicing = RouteWithAnimalsService(animalRepository: animalRepository)
}

extension AppDependency: HasAnimalRepository{}
extension AppDependency: HasLocalityRepository{}
extension AppDependency: HasSpeechService{}
extension AppDependency: HasContinentBindingsRepository{}
extension AppDependency: HasBiotopeBindingsRepository{}
extension AppDependency: HasFoodBindingsRepository{}
extension AppDependency: HasVoiceSettingsRepository{}
extension AppDependency: HasPathRepository{}
extension AppDependency: HasParametersOfVisitRepository{}
extension AppDependency: HasProcessAnimalInformationService {}
extension AppDependency: HasClassRepository{}
extension AppDependency: HasRouteWithAnimalsService{}
