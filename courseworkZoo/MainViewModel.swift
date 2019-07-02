//
//  ViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 23/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift


/**
This class is a view model for the main screen. This class ensures getting a list of animals and list of localities with known coordinates and machine-reading information about animals and localities.
 */
class MainViewModel: BaseViewModel{
    typealias Dependencies = HasLocalityRepository & HasAnimalRepository & HasSpeechService
    
    /// The object with target dependencies
    private var dependencies: Dependencies
    /// The mutable object with the actual latitude
    private var latitude = MutableProperty<Double>(-1)
    /// The mutable object with the actual longitude
    private var longitude = MutableProperty<Double>(-1)
    
    // Mark - Actions
    
    
    /**
     This action tries to find and return an animal which is enough close (animal whose coordinates differ not more than 0,000045 from the actual coordinates). This action returns an animal in closeness or nil if there is no enough close animal or an error indicating animals could not be loaded.
    */
    lazy var animalInClosenessAction = Action<(), Animal?, LoadError> { [unowned self] in
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
        if let animals = self.dependencies.animalRepository.entities.value as? [Animal]
        {
            return self.dependencies.animalRepository.findAnimalInCloseness(latitude: self.latitude.value, longitude: self.longitude.value)
        } else {
            return SignalProducer<Animal?, LoadError>(error: .noAnimals)
        }
    }
    
    
    /**
     This action tries to find and return a locality which is enough close (locality whose coordinates differ not more than 0,000045 from the actual coordinates). This action returns a locality in closeness or nil if there is no enough close locality or an error indicating localities could not be loaded.
     */
    lazy var localityInClosenessAction = Action<(), Locality?, LoadError> { [unowned self] in
        self.dependencies.localityRepository.loadAndSaveDataIfNeeded()
        if let localities = self.dependencies.localityRepository.entities.value as? [Locality] {
            return self.dependencies.localityRepository.findLocalityInCloseness(latitude: self.latitude.value, longitude: self.longitude.value)
        } else {
            return SignalProducer<Locality?, LoadError>(error: .noLocalities)
        }
    }

    
    /**
     This action tries to return a list of animal with known coordinates. It returns a list of animals with known coordinates or an error indicating that animals could not be loaded.
    */
    lazy var getAnimalsAction = Action<(), [Animal], LoadError>{
        [unowned self] in
        self.dependencies.animalRepository.loadAndSaveDataIfNeeded()
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
    
    
    /**
     This action tries to return a list of localities with known coordinates. It returns a list of localities with known coordinates or an error indicating that localities could not be loaded.
    */
    lazy var getLocalitiesAction = Action<(), [Locality], LoadError>{
        [unowned self] in
        self.dependencies.localityRepository.loadAndSaveDataIfNeeded()
        if let localities = self.dependencies.localityRepository.entities.value as? [Locality] {
            var newLocalities: [Locality] = []
            for locality in localities {
                if(locality.latitude < 0){
                    continue
                }
                newLocalities.append(locality)
            }
            return SignalProducer<[Locality], LoadError>(value: newLocalities)
        } else {
            return SignalProducer<[Locality], LoadError>(error: .noLocalities)
        }
    }
    
    
    // MARK - Constructor and other functions
    
    /**
     - Parameters:
        - dependencies: The object with dependencies important for actions in this view model.
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
    
    
    /**
     This function updated mutable properties which save the actual coordinates.
     - Parameters:
        - latitude: The actual latitude (the first coordinate of the actual location)
        - longitude: The actual longitude (the second coordinate of the actual location)
    */
    func updateLocation(latitude: Double, longitude: Double){
        self.latitude.value = latitude
        self.longitude.value = longitude
    }
    
    
    /**
     This function ensures machine-reading information about the given animal (or nil if no animals are enough close). This function chooses information for machine-reading according to the actual user setting and calls the service for machine-reading of the given text.
     - Parameters:
        - animal: The animal in closeness or nil (if there is no enough close animal)
    */
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
    
    
    /**
     This function ensures machine-reading information about the close locality if there is any enough close locality.
     - Parameters:
        - locality: The close locality or nil (if there is no enough close locality)
    */
    func sayInformationAboutLocality(locality: Locality?){
        if (SettingsInformationViewModel.getActualSettings() == SaidInformationSettings.none){
            return
        }
        if let localityForSaying = locality as? Locality {
            let latitude = localityForSaying.latitude
            let longitude = localityForSaying.longitude
            let coords = Coords(latitude: latitude, longitude: longitude)
            let existsPosition = BaseViewModel.existsPosition(latitude: latitude, longitude: longitude)
            if(!existsPosition){
                BaseViewModel.visited.append(coords)
                let title = localityForSaying.title.replacingOccurrences(of: "Pavilon", with: "Pavilonu")
                self.dependencies.speechService.sayText(text: "Vítejte v "+title)
            }
        }
    }
    
}
