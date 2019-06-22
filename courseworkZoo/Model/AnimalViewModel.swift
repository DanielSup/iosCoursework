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
        if let animals = self.dependencies.animalRepository.entities.value as? [Animal]  {
            return SignalProducer<[Animal], LoadError>(value: animals)
        } else {
            return SignalProducer<[Animal], LoadError>(error: .noAnimals)
        }
    }
    
    lazy var getAnimalsAction = Action<(), [Animal], LoadError>{
        [unowned self] in
        self.dependencies.animalRepository.reload()
        if let animals = self.dependencies.animalRepository.entities.value as? [Animal]  {
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
        if let animals = self.dependencies.animalRepository.entities as? [Animal] {
            self.animals.value = animals
        }
        super.init()
    }

    func updateLocation(latitude: Double, longitude: Double){
        self.latitude.value = latitude
        self.longitude.value = longitude
    }
    
    func sayInformationAboutAnimal(animal: Animal?){
        if (SettingsInformationViewModel.getActualSettings() == SaidInformationSettings.none){
            return
        }
        if let animalForSaying = animal as? Animal{
            let latitude = animalForSaying.latitude
            let longitude = animalForSaying.longitude
            let coords = Coords(latitude: latitude, longitude: longitude)
            let existsPosition = BaseViewModel.existsPosition(latitude: latitude, longitude: longitude)
            let actualSettings = SettingsInformationViewModel.getActualSettings()
            var text: String = ""
            if(!existsPosition){
                BaseViewModel.visited.append(coords)
                if (actualSettings.saidInfo.contains(SaidInfo.title)){
                    text += "Toto je "+animalForSaying.title
                }
                if(actualSettings.saidInfo.contains(SaidInfo.news)){
                    if(animalForSaying.actualities.count > 0){
                        text += "Novinky"
                    }
                    for actuality in animalForSaying.actualities{
                        text += "          "
                        text +=  actuality.title
                        text += actuality.perex
                        text += actuality.textOfArticle
                    }
                }
                if(actualSettings.saidInfo.contains(SaidInfo.description)){
                    text += "Popis          " + animalForSaying.description
                }
                
                if(actualSettings.saidInfo.contains(SaidInfo.biotopes)){
                    text += "Biotopy, kde zvire zije, je              "+animalForSaying.biotope
                }
                if(actualSettings.saidInfo.contains(SaidInfo.continents) && animalForSaying.continent != Continent.none){
                    text += "Kontinenty           "+animalForSaying.continent.rawValue
                } else if(animalForSaying.continent == Continent.none){
                    text += "Toto zvire v prirode nezije"
                }
                
                if(actualSettings.saidInfo.contains(SaidInfo.spread)){
                    text += "Rozsireni               "+animalForSaying.spread
                }

                if(actualSettings.saidInfo.contains(SaidInfo.food)){
                    text += "Potrava        " + animalForSaying.food
                    text += animalForSaying.foodNote
                }
                
                if(actualSettings.saidInfo.contains(SaidInfo.proportions)){
                    text += "Rozmery          "+animalForSaying.proportions
                }
                
                if(actualSettings.saidInfo.contains(SaidInfo.reproduction)){
                    text += "Rozmnozovani          "+animalForSaying.reproduction
                }
                
                if(actualSettings.saidInfo.contains(SaidInfo.attractions)){
                    text += "Zajimavosti              " + animalForSaying.attractions
                }
                if(actualSettings.saidInfo.contains(SaidInfo.breeding)){
                    text += "Informace o chovu             " + animalForSaying.breeding
                }
                self.dependencies.speechService.sayText(text: text)
            }
        }
    }
    
}
