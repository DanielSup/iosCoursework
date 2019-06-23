//
//  AnimalListViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 23/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

protocol AnimalListViewModelling{
    var getAllAnimalsAction: Action<(), [Animal], LoadError> { get }
}

class AnimalListViewModel: BaseViewModel, AnimalListViewModelling {
    typealias Dependencies = HasAnimalRepository & HasSpeechService
    private var dependencies: Dependencies
    private var animals = MutableProperty<[Animal]>([])
    
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        if let animals = self.dependencies.animalRepository.entities as? [Animal] {
            self.animals.value = animals
        }
        super.init()
    }
    
    lazy var getAllAnimalsAction = Action<(), [Animal], LoadError>{
        [unowned self] in
        self.dependencies.animalRepository.reload()
        if let animals = self.dependencies.animalRepository.entities.value as? [Animal]  {
            return SignalProducer<[Animal], LoadError>(value: animals)
        } else {
            return SignalProducer<[Animal], LoadError>(error: .noAnimals)
        }
    }
}
