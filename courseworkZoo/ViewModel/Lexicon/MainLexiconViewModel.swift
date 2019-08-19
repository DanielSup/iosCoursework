//
//  MainLexiconViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 08/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model for the main screen of the lexicon part of the application.
 */
class MainLexiconViewModel: BaseViewModel {
    typealias Dependencies = HasAnimalRepository
    
    /// The object with dependencies important for the action for getting the list of animals in this view models.
    private var dependencies: Dependencies
    
    // MARK - Actions
    
    /**
     This actions tries to return a list of all animals. It returns a list of all animals or an error indicating that animals could not be loaded.
     */
    lazy var getAllAnimals = Action<(), [Animal], LoadError>{
        [unowned self] in
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
        if let animals = self.dependencies.animalRepository.entities.value as? [Animal]  {
            let czechLocale = Locale(identifier: "cs")
            return SignalProducer<[Animal], LoadError>(value: animals.sorted(by: {$0.title.compare($1.title, locale: czechLocale) == .orderedAscending}))
        } else {
            return SignalProducer<[Animal], LoadError>(error: .noAnimals)
        }
    }
    
    // MARK - Constructor
    
    /**
     - Parameters:
     - dependencies: The object with dependencies important for the action for getting the list of all animals in this view model.
     */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
}
