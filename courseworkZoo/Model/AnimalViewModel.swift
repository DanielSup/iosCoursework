//
//  AnimalViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 17/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit
import ReactiveSwift

protocol AnimalViewModelling{
    var animalInClosenessAction: Action<(), Animal?, LoadError> { get }
    var getAllAnimalsAction: Action<(), [Animal], LoadError> { get }
    var getAnimalsAction: Action<(), [Animal], LoadError> { get }
    func updateLocation(latitude: Double, longitude: Double)
    func sayInformationAboutAnimal(animal: Animal?)
}

class AnimalViewModel: BaseViewModel, AnimalViewModelling {
    typealias Dependencies = HasAnimalRepository & HasSpeechService
    private var dependencies: Dependencies
    private var animals = MutableProperty<[Animal]>([])
    private var latitude = MutableProperty<Double>(-1)
    private var longitude = MutableProperty<Double>(-1)
    
    lazy var animalInClosenessAction = Action<(), Animal?, LoadError> { [unowned self] in
        if let animals = self.animals.value as? [Animal]
        {
            return self.dependencies.animalRepository.findAnimalInCloseness(latitude: self.latitude.value, longitude: self.longitude.value)
        } else {
            return SignalProducer<Animal?, LoadError>(error: .noAnimals)
        }
    }
    
    lazy var getAllAnimalsAction = Action<(), [Animal], LoadError>{
        [unowned self] in
        self.dependencies.animalRepository.reload()
        if let animals = self.dependencies.animalRepository.animals.value as? [Animal]  {
            return SignalProducer<[Animal], LoadError>(value: animals)
        } else {
            return SignalProducer<[Animal], LoadError>(error: .noAnimals)
        }
    }
    
    lazy var getAnimalsAction = Action<(), [Animal], LoadError>{
        [unowned self] in
        self.dependencies.animalRepository.reload()
        if let animals = self.dependencies.animalRepository.animals.value as? [Animal]  {
            var newAnimals: [Animal] = []
            for animal in animals{
                if(animal.latitude < 0){
                    continue
                }
                newAnimals.append(animal)
            }
            return SignalProducer<[Animal], LoadError>(value: newAnimals)
        } else {
            return SignalProducer<[Animal], LoadError>(error: .noAnimals)
        }
    }
    
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        if let animals = self.dependencies.animalRepository.animals as? [Animal] {
            self.animals.value = animals
        }
        super.init()
    }

    func updateLocation(latitude: Double, longitude: Double){
        self.latitude.value = latitude
        self.longitude.value = longitude
    }
    
    func sayInformationAboutAnimal(animal: Animal?){
        if let animalForSaying = animal as? Animal{
            let latitude = animalForSaying.latitude
            let longitude = animalForSaying.longitude
            let coords = Coords(latitude: latitude, longitude: longitude)
            let existsPosition = BaseViewModel.existsPosition(latitude: latitude, longitude: longitude)
            if(!existsPosition){
                BaseViewModel.visited.append(coords)
                var text: String = "Toto je "+animalForSaying.title
                for actuality in animalForSaying.actualities{
                    text += actuality.title
                    text += actuality.perex
                    text += actuality.textOfArticle
                }
                text += animalForSaying.description
                self.dependencies.speechService.sayText(text: text)
            }
        }
    }
    
}
