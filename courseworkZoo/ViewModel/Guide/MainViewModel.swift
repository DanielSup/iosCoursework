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
    typealias Dependencies = HasLocalityRepository & HasAnimalRepository & HasVoiceSettingsRepository & HasSpeechService & HasProcessAnimalInformationService & HasPathRepository & HasRouteWithAnimalsService & HasParametersOfVisitRepository
    
    /// The object with target dependencies
    private var dependencies: Dependencies
    /// The mutable object with the actual latitude
    private var latitude = MutableProperty<Double>(-1)
    /// The mutable object with the actual longitude
    private var longitude = MutableProperty<Double>(-1)
    /// The mutable property with the list of visited animals during the visit with selected saved pathk.
    private var animalsVisited = MutableProperty<[Animal]>([])
    /// The array of placemarks to visit.
    private var path = MutableProperty<[MKPlacemark]>([])
    /// The array of saved pieces of a path in the ZOO (path from one animal to any other animal).
    private var savedPiecesOfPath: [PieceOfPath] = []
    /// The boolean representing whether the exit was visited or not.
    private var exitVisited = false
    
    
    // MARK - Actions
    
    
    /**
     This action returns an animal in the actual path which is enough close (animal whose coordinates differ not more than 0,000045 from the actual coordinates). This action returns an animal in closeness or nil.
    */
    lazy var getAnimalInCloseness = Action<(), Animal?, Error> { [unowned self] in
    
        return self.dependencies.routeWithAnimalsService.getCloseAnimalInPath(latitude: self.latitude.value, longitude: self.longitude.value)
    }
    
    
    /**
     This action tries to find and return a locality which is enough close (locality whose coordinates differ not more than 0,000045 from the actual coordinates). This action returns a locality in closeness or nil if there is no enough close locality or an error indicating localities could not be loaded.
     */
    lazy var getLocalityInCloseness = Action<(), Locality?, LoadError> { [unowned self] in
        self.dependencies.localityRepository.loadAndSaveDataIfNeeded()
        return self.dependencies.localityRepository.findLocalityInCloseness(latitude: self.latitude.value, longitude: self.longitude.value)
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
    

    /**
     This action returns a signal producer with the list of placemarks for showing the actual path with animals in the map view in the main screen.
    */
    lazy var getPlacemarksForTheActualPath = Action<Bool, [MKPlacemark], Error> {
        [unowned self] in
        return self.dependencies.routeWithAnimalsService.getPlacemarksForTheActualPath(countPath: $0)
    }
    
    
    /**
     This action returns a signal producer with the list of visited animals.
    */
    lazy var getVisitedAnimals = Action<(), [Animal], Error> { [unowned self] in
        return SignalProducer(value: self.animalsVisited.value)
    }
    
    
    /**
     This action returns a signal producer with the piece of path between the two given placemarks. If there is no saved piece of path with the two given placemarks, it returns a signal producer with nil value.
    */
    lazy var getSavedPieceOfPathBetweenPlacemarks = Action<(MKPlacemark, MKPlacemark), PieceOfPath?, Error> {
        for savedPieceOfPath in self.savedPiecesOfPath {
            let sourceCoordinate = savedPieceOfPath.sourcePlacemark.location!.coordinate
            let sourceCoordinateLatitude = sourceCoordinate.latitude
            let sourceCoordinateLongiture = sourceCoordinate.longitude
            
            let destinationCoordinate = savedPieceOfPath.destinationPlacemark.location!.coordinate
            let destinationCoordinateLatitude = destinationCoordinate.latitude
            let destinationCoordinateLongitude = destinationCoordinate.longitude
            
            let sourcePlacemarkCoordinate = $0.location!.coordinate
            let sourcePlacemarkCoordinateLatitude = sourcePlacemarkCoordinate.latitude
            let sourcePlacemarkCoordinateLongitude = sourcePlacemarkCoordinate.longitude
            
            let destinationPlacemarkCoordinate = $1.location!.coordinate
            let destinationPlacemarkCoordinateLatitude = destinationPlacemarkCoordinate.latitude
            let destinationPlacemarkCoordinateLongitude = destinationPlacemarkCoordinate.longitude
            
            if (abs(sourcePlacemarkCoordinateLatitude - sourceCoordinateLatitude) < 1e-7 &&
                abs(sourcePlacemarkCoordinateLongitude - sourcePlacemarkCoordinateLongitude) < 1e-7 &&
                abs(destinationPlacemarkCoordinateLatitude - destinationCoordinateLatitude) < 1e-7 &&
                abs(destinationPlacemarkCoordinateLongitude - destinationPlacemarkCoordinateLongitude) < 1e-7) {
                return SignalProducer(value: savedPieceOfPath)
            }
        }
        return SignalProducer(value: nil)
    }
    
    
    /**
     This action returns a signal producer with the number of unvisited animals in the actual path.
    */
    lazy var getCountOfUnvisitedAnimals = Action<(), Int, Error> {
        return self.dependencies.routeWithAnimalsService.getCountOfUnvisitedAnimals()
    }
    
    
    /**
     This action returns a signal producer with the actual set walk speed during the visit of the ZOO.
    */
    lazy var getWalkSpeed = Action<(), Float, Error> {
        return self.dependencies.parametersOfVisitRepository.getWalkSpeed()
    }
    
    
    /**
     This action returns a signal producer with the time spent at one animal during the visit of the ZOO.
    */
    lazy var getTimeSpentAtOneAnimal = Action<(), Float, Error> {
        return self.dependencies.parametersOfVisitRepository.getTimeSpentAtOneAnimal()
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
            self.dependencies.processAnimalInformationService.updateSetting(actualSetting)
            let text: String = self.dependencies.processAnimalInformationService.processInformationAndGetTextForMachineReading(about: animalForSaying)
            self.dependencies.speechService.sayText(text: text)
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
            let title = localityForSaying.title.replacingOccurrences(of: "Pavilon", with: "Pavilonu")
            let textForReading = "Vítejte v " + title
            self.dependencies.speechService.sayText(text: textForReading)
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
    
    
    /**
     This function sets the array of animals in the path.
     - Parameters:
        - animalsInPath: The array of animals which the user wants to visit.
    */
    func set(animalsInPath: [Animal]) {
        if (self.dependencies.routeWithAnimalsService.setAnimalsInPath(animalsInPath)) {
            self.animalsVisited.value = []
        }
        
    }
    
    
    /**
     This function sets the source location where the path in the ZOO starts.
     - Parameters:
        - sourceLocation: The actual location where the path in the ZOO with animals starts.
    */
    func set(sourceLocation: CLLocationCoordinate2D){
        self.dependencies.routeWithAnimalsService.setSourceLocality(sourceLocation)
    }
    
    
    /**
    This function saved the path from one animal to any second animal in the path in the ZOO.
     - Parameters:
        - pieceOfPath: The path from one animal to second.
     */
    func savePieceOfPath(_ pieceOfPath: PieceOfPath) {
        self.savedPiecesOfPath.append(pieceOfPath)
    }
    
    
    /**
     This function marks the locality which is visited now as visited.
     - Parameters:
        - locality: The locality which is visited now and has to be marked as visited.
    */
    func visitLocality(_ locality: Locality) {
        self.dependencies.localityRepository.visitLocality(locality)
    }
    
    
    /**
     This function finds out and returns the coordinate of the entrance to ZOO is at the route. If there is no entrance at the route, it returns nil
     - Parameters:
        - route: The found shortest route from the actual location to the first animal in the path in the ZOO.
     - Returns: A coordinate of the entrance at the given route. If there is no entrance at the route, it returns nil.
    */
    func entranceAtTheRoute(_ route: MKRoute) -> CLLocationCoordinate2D?{
        for step in route.steps as [MKRoute.Step] {
            let pointCount = step.polyline.pointCount
            if (pointCount < 2) {
                continue
            }
            var pointArray = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: pointCount)
            step.polyline.getCoordinates(pointArray, range: NSMakeRange(0, pointCount))
            
            
            for c in 0..<(pointCount - 1) {
                let start = pointArray[c]
                let finish = pointArray[c + 1]
                
                let entranceAtTheLine = CountService.entranceAtTheLine(a: start, b: finish)
                if (entranceAtTheLine != nil) {
                    return entranceAtTheLine!
                }
            }
            pointArray.deallocate()
        }
        return nil
    }
    
    /**
     This function ensures welcoming user in the application.
    */
    func welcomeUserInTheGuide() {
        let text = L10n.welcome
        self.dependencies.speechService.sayText(text: text)
    }
    
    
    /**
     This function checks whether the user is at the exit from the ZOO. If the user gone through the exit, then the path to the exit isn't shown anymore. This method is called only if there are no unvisited animals in the path in the ZOO and user should go to the exit.
     - Returns: A boolean whether the user is at the exit or not.
    */
    func checkExitAndGoThroughIt() -> Bool {
        let exit = self.dependencies.routeWithAnimalsService.getExitCoordinate()
        if (exit == nil) {
            return false
        }
        if abs(self.latitude.value - exit!.latitude) < Constants.closeDistance &&
            abs(self.longitude.value - exit!.longitude) < Constants.closeDistance {
            self.dependencies.routeWithAnimalsService.goThroughExit()
            self.exitVisited = true
            return true
        }
        return self.exitVisited
    }
    
    
    /**
     This function ensures that the user is informed by the voice that he/she is at the exit from the ZOO. This function is called only if there are no unvisited animals.
    */
    func speechAtExit() {
        let exit = self.dependencies.routeWithAnimalsService.getExitCoordinate()
        if (exit == nil) {
            return
        }
        if abs(self.latitude.value - exit!.latitude) < Constants.closeDistance &&
            abs(self.longitude.value - exit!.longitude) < Constants.closeDistance {        self.dependencies.speechService.sayText(text: L10n.speechAtExit)
        }
    }
    
    /**
     This function ensures informing the user that he/she is at the entrance to the ZOO. This function is called only if no animal is visited.
    */
    func speechAtEntrance() {
        let entrance = self.dependencies.routeWithAnimalsService.getEntranceCoordinate()
        if (entrance == nil) {
            return
        }
        if abs(self.latitude.value - entrance!.latitude) < Constants.closeDistance &&
            abs(self.longitude.value - entrance!.longitude) < Constants.closeDistance {
            self.dependencies.speechService.sayText(text: L10n.speechAtEntrance)
        }
    }
    
    
    /**
     This function ensures setting the coordinate of the exit which is used as the end of the path in the ZOO. It finds the closest exit from the given coordination of any entrance to the ZOO.
     - Parameters:
        - entranceCoordinate: The coordinate of the entrance to the ZOO at the start of the path to the ZOO.
    */
    func setClosestExitCoordinateFromEntrance(_ entranceCoordinate: CLLocationCoordinate2D) {
        var closestExitCoordinate: CLLocationCoordinate2D!
        for coordinateOfExit in Constants.coordinatesOfExits {
            if (closestExitCoordinate == nil) {
                closestExitCoordinate = coordinateOfExit
            } else {
                let latitudeDifference = (entranceCoordinate.latitude - coordinateOfExit.latitude)
                let longitudeDifference = (entranceCoordinate.longitude - coordinateOfExit.longitude)
                let distanceFromActualExit = (latitudeDifference * latitudeDifference) + (longitudeDifference * longitudeDifference)
                
                let smallestLatitudeDifference = (entranceCoordinate.latitude - closestExitCoordinate.latitude)
                let smallestLongitudeDifference = (entranceCoordinate.longitude - closestExitCoordinate.longitude)
                let smallestDistanceFromExit = (smallestLatitudeDifference * smallestLatitudeDifference) + (smallestLongitudeDifference * smallestLongitudeDifference)
                
                if (distanceFromActualExit < smallestDistanceFromExit) {
                    closestExitCoordinate = coordinateOfExit
                }
            }
        }
        self.dependencies.routeWithAnimalsService.setEntranceCoordinate(entranceCoordinate)
        self.dependencies.routeWithAnimalsService.setExitCoordinate(closestExitCoordinate)
    }
}
