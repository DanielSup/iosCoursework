//
//  ViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 23/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit
import ReactiveSwift


/**
This class is a view model for the main screen. This class ensures getting a list of animals and list of localities with known coordinates and machine-reading information about animals and localities.
 */
class MainViewModel: BaseViewModel{
    typealias Dependencies = HasLocalityRepository & HasAnimalRepository & HasVoiceSettingsRepository & HasSpeechService & HasProcessAnimalInformationService & HasPathRepository & HasRouteWithAnimalsService
    
    /// The object with target dependencies
    private var dependencies: Dependencies
    /// The mutable object with the actual latitude
    private var latitude = MutableProperty<Double>(-1)
    /// The mutable object with the actual longitude
    private var longitude = MutableProperty<Double>(-1)
    
    private var animalsVisited = MutableProperty<[Animal]>([])
    
    private var path = MutableProperty<[MKPlacemark]>([])
    
    // Mark - Actions
    
    
    /**
     This action tries to find and return an animal which is enough close (animal whose coordinates differ not more than 0,000045 from the actual coordinates). This action returns an animal in closeness or nil if there is no enough close animal or an error indicating animals could not be loaded.
    */
    lazy var getAnimalInCloseness = Action<(), Animal?, LoadError> { [unowned self] in
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
    lazy var getLocalityInCloseness = Action<(), Locality?, LoadError> { [unowned self] in
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
    lazy var getAnimals = Action<(), [Animal], LoadError>{
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
    lazy var getLocalities = Action<(), [Locality], LoadError>{
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
    
    
    /**
     This action returns a signal producer with value whether the voice is on or off.
    */
    lazy var isVoiceOn = Action<(), Bool, Error>{
        [unowned self] in
        return self.dependencies.voiceSettingsRepository.isVoiceOn()
    }
    
    
    /**
     This action returns a signal producer with the list of animals in the actual unsaved path.
    */
    lazy var getAnimalsInPath = Action<(), [Animal], Error>{
        [unowned self] in
        let animalsInPath = self.dependencies.pathRepository.getAnimalsInPath()
        return SignalProducer<[Animal], Error>(value: animalsInPath)
    }
    


    lazy var getPlacemarksForTheActualPath = Action<Bool, [MKPlacemark], Error> {
        return self.dependencies.routeWithAnimalsService.getPlacemarksForTheActualPath(countPath: $0)
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
    func sayInformationAbout(animal: Animal?){
        var voiceOn = true
        self.dependencies.voiceSettingsRepository.isVoiceOn().startWithResult{ (voiceOnResult) in
            voiceOn = voiceOnResult.value!
        }
        if(voiceOn == false){
            return
        }
        
        var actualSetting: [SaidInfo: Bool] = [:]
        self.dependencies.voiceSettingsRepository.getActualInformationSetting().startWithResult{ (acutalSettingResult) in
            actualSetting = acutalSettingResult.value!
        }
        
        if let animalForSaying = animal as? Animal{
            let latitude = animalForSaying.latitude
            let longitude = animalForSaying.longitude
            let coords = Coords(latitude: latitude, longitude: longitude)
            let existsPosition = BaseViewModel.existsPosition(latitude: latitude, longitude: longitude)
            if(!existsPosition){
                BaseViewModel.visited.append(coords)
                self.dependencies.processAnimalInformationService.updateSetting(actualSetting)
                let text: String = self.dependencies.processAnimalInformationService.processInformationAndGetTextForMachineReading(about: animalForSaying)
                self.dependencies.speechService.sayText(text: text)
            }
        }
    }
    
    /**
    This function gets the text for showing during the machine-reading. It finds the actual settings of the machine-read information and gets the text by the actual setting. It returns the text about the given close animal or empty string if there is no enough close animal.
     - Parameters:
        - animal: The animal in closeness or nil if there is no enough close animal
     - Returns: The text about the close animal or empty string if there is no enough close animal.
     */
    func textForShowingAbout(animal: Animal?) -> String{
        var actualSetting: [SaidInfo: Bool] = [:]
        self.dependencies.voiceSettingsRepository.getActualInformationSetting().startWithResult{ (acutalSettingResult) in
            actualSetting = acutalSettingResult.value!
        }
        
        if let animalForReading = animal as? Animal{
            self.dependencies.processAnimalInformationService.updateSetting(actualSetting)
            let text: String = self.dependencies.processAnimalInformationService.processInformationAndGetTextForMachineReading(about: animalForReading)
            return text
        }
        return ""
    }
    
    /**
     This function ensures machine-reading information about the close locality if there is any enough close locality.
     - Parameters:
        - locality: The close locality or nil (if there is no enough close locality)
    */
    func sayInformationAbout(locality: Locality?){
        var voiceOn = true
        self.dependencies.voiceSettingsRepository.isVoiceOn().startWithResult{ (isVoiceOn) in
            voiceOn = isVoiceOn.value!
        }
        if(voiceOn == false){
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
                let textForReading = "Vítejte v " + title
                self.dependencies.speechService.sayText(text: textForReading)
            }
        }
    }

    
    /**
    This function gets and returns the text about the given close locality. If there is no enough close locality, it returns an empty string.
     - Parameters:
        - locality: The close locality or nil if there is no enough close locality
     - Returns: The text about the close locality of nil if there is no enough close locality.
     */
    func textForShowingAbout(locality: Locality?) -> String {
        if let localityForReading = locality as? Locality {
            let title = localityForReading.title.replacingOccurrences(of: "Pavilon", with: "Pavilonu")
            let textForReading = "Vítejte v " + title
            return textForReading
        }
        return ""
    }
    
    
    /**
     This function ensures turning the voice on (if the voice is off) or off (if the voice is on).
    */
    func turnVoiceOnOrOff(){
        self.dependencies.voiceSettingsRepository.turnVoiceOnOrOff()
    }
    
    /**
     This function adds the animal to the actual unsaved path (if the animal isn't in the actual path) or removes the animal from the actual path (if the animal is in the actual path).
     - Parameters:
        - animal: The animal which is added to the actual path or removed from the actual path.
    */
    func addOrRemoveAnimal(animal: Animal){
        let animalsInPath = self.dependencies.pathRepository.getAnimalsInPath()
        var isTheAnimalInPath = false
        for animalInPath in animalsInPath {
            if(animalInPath.id == animal.id){
                isTheAnimalInPath = true
                break
            }
        }
        
        if (isTheAnimalInPath) {
            self.dependencies.pathRepository.removeAnimalFromPath(animal: animal)
        } else {
            self.dependencies.pathRepository.addAnimalToPath(animal: animal)
        }
    }
    
    /**
     This function set callback for the speech service. The first callback is called after starting the machine-reading and the second callback is called after the end of the machine-reading.
     - Parameters:
        - startCallback: The callback which is called after the start of the machine-reading.
        - finishCallback: The callback which is called after the end of the machine-reading
    */
    func setCallbacksOfSpeechService(startCallback: @escaping(() -> Void), finishCallback: @escaping(() -> Void)){
        self.dependencies.speechService.setStartCallback(callback: startCallback)
        self.dependencies.speechService.setFinishCallback(callback: finishCallback)
    }
    
    /**
     This function ensures informing the user about the visiting of the animal.
     - Parameters:
        - animal: The animal which is currently visited
    */
    func visitAnimal(animal: Animal) {
        self.animalsVisited.value.append(animal)
        self.dependencies.routeWithAnimalsService.visitAnimal(animal)
    }
    
    
    func set(animalsInPath: [Animal]) {
        self.dependencies.routeWithAnimalsService.setAnimalsInPath(animalsInPath)
        
    }
    
    func set(sourceLocation: CLLocationCoordinate2D){
        self.dependencies.routeWithAnimalsService.setSourceLocality(sourceLocation)
    }
}
