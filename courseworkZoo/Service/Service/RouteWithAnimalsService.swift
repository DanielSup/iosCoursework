//
//  RouteWithAnimalsService.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 27/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit
import ReactiveSwift

/**
 This protocol is used for the dependency injection. It is used for working with a service for finding the shortest possible combination of routes with all selected animals in the actual path.
*/
protocol RouteWithAnimalsServicing {
    func setSourceLocality(_ sourceLocality: CLLocationCoordinate2D)
    func setAnimalsInPath(_ animalsInPath: [Animal]) -> Bool
    func addAllAnimalsToPath()
    func setExitCoordinate(_ exitCoordinate: CLLocationCoordinate2D)
    func getExitCoordinate() -> CLLocationCoordinate2D?
    func setEntranceCoordinate(_ entranceCoordinate: CLLocationCoordinate2D)
    func getEntranceCoordinate() -> CLLocationCoordinate2D?
    func getPlacemarksForTheActualPath(countPath: Bool) -> SignalProducer<[MKPlacemark], Error>
    func visitAnimal(_ animal: Animal)
    func goThroughExit()
    func getCloseAnimalInPath(latitude: Double, longitude: Double) -> SignalProducer<Animal?, Error>
    func getCountOfUnvisitedAnimals() -> SignalProducer<Int, Error>
    func getNextAnimalInThePath() -> SignalProducer<Animal?, Error>
}


/**
 This class is used for finding the shortest combination of routes with all animals in the actual path. It also finds shortest path between two placemarks
*/
class RouteWithAnimalsService: NSObject, MKMapViewDelegate, RouteWithAnimalsServicing {
    
    /// The repository for getting all animals with known coordinate.
    private var animalRepository: AnimalRepositoring
    /// The array of animals in the path.
    private var animalsInPath: [Animal] = []
    /// The array of non visited animals in path
    private var nonVisitedAnimalsInPath: [Animal] = []
    /// The array of placemarks of animals and the placemark for the actual location
    private var placemarks: [MKPlacemark] = []
    /// The actual coordinate.
    private var sourceLocality: CLLocationCoordinate2D!
    /// The coords of the closest exit from the actual position or the entrance which the user gone through.
    private var closestExitCoordinate: CLLocationCoordinate2D! = Constants.coordinatesOfExits[1]
    /// The coords of the closest entrance to the ZOO.
    private var entranceCoordinate: CLLocationCoordinate2D! = Constants.coordinatesOfEntrances[1]
    /// The boolean representing whether the coordinate of the exit from the ZOO was set.
    private var isExitSet = false
    /// The boolean representing whether the coordinate of the entrance to the ZOO was set.
    private var isEntranceSet = false
    
    
    /**
     - Parameters:
        - animalRepository: The repository for getting all animals with known coordinate.
    */
    init(animalRepository: AnimalRepositoring) {
        self.animalRepository = animalRepository
    }
    
    /**
     This function sets the list of animals in the actual path. It also sets the array of non visited animals to the array of all animals in the actual path.
     - Parameters:
        - animalsInRoute: The list of animals in the actual path.
     - Returns: A boolean representing whether the new list of animals differs or not.
    */
    func setAnimalsInPath(_ animalsInPath: [Animal]) -> Bool{
        
        var differ = animalsInPath.count != self.animalsInPath.count
        if (!differ) {
            for animalInPath in self.animalsInPath {
                var found = false
                for animal in animalsInPath {
                    if (animal.id == animalInPath.id) {
                        found = true
                        break
                    }
                }
                if(!found) {
                    differ = true
                    break
                }
            }
        }
        
        if (differ) {
            self.animalsInPath = animalsInPath
            self.nonVisitedAnimalsInPath = animalsInPath
        }
        return differ
    }
    
    
    /**
     This function ensures adding all animals with known coordinate to the actual path.
    */
    func addAllAnimalsToPath() {
        self.animalRepository.loadAndSaveDataIfNeeded()
        self.animalRepository.getAnimalsWithKnownCoordinate().producer.startWithResult { (animalsWithKnownCoordinateResult) in
            self.setAnimalsInPath(animalsWithKnownCoordinateResult.value!)
        }
    }
    
    /**
     This function sets the actual locality after the choosing the saved path, adding an animal to the actual path or removing an animal from the actual path.
     - Parameters:
        - sourceLocality: The actual locality after the choosing the saved path or editing the actual path.
    */
    func setSourceLocality(_ sourceLocality: CLLocationCoordinate2D){
        self.sourceLocality = sourceLocality
    }
    
    
    /**
     This function sets the coordinate of the closest exit which is used as the end of the path in the ZOO.
     - Parameters:
        - exitCoordinate: The coordinate (object with latitude and longitude) of the exit which is used as the end of the path in the ZOO.
    */
    func setExitCoordinate(_ exitCoordinate: CLLocationCoordinate2D) {
        self.closestExitCoordinate = exitCoordinate
        self.isExitSet = true
    }
    
    
    /**
     This function returns the coordinate of the exit which is used as the end of the path with animals in the ZOO.
     - Returns: The coordinate of the exit which is used as the end of the path in the ZOO.
    */
    func getExitCoordinate() -> CLLocationCoordinate2D? {
        return self.closestExitCoordinate
    }
    
    /**
     This function sets the coordinate of the entrance to the ZOO which the user go through.
     - Parameters:
        - entranceCoordinate: The coordinate of the entrance to the ZOO which the user go through.
    */
    func setEntranceCoordinate(_ entranceCoordinate: CLLocationCoordinate2D) {
        self.entranceCoordinate = entranceCoordinate
        self.isEntranceSet = true
    }
    
    
    /**
     This function returns the coordinate of the entrance to the ZOO which the user go through.
     - Returns: The coordinate of the entrance to the ZOO which the user go through.
    */
    func getEntranceCoordinate() -> CLLocationCoordinate2D? {
        return self.entranceCoordinate
    }
    
    /**
     This function counts the shortest path with all selected animals in the ZOO with entrance and exit if it is needed. This function returns an array of placemark representing animals and the exit from the ZOO in correct order in which the user should visit them.
     - Parameters:
        - countPath: The boolean representing whether the path in the ZOO must be counted or not.
     - Returns: An array of placemark representing animals and the exit from the ZOO in correct order in which the user should visit them.
     */
    func getPlacemarksForTheActualPath(countPath: Bool) -> SignalProducer<[MKPlacemark], Error> {
        let placemarkForActualPosition = MKPlacemark(coordinate: self.sourceLocality)
        if (countPath) {
            var placemarks: [MKPlacemark] = [placemarkForActualPosition]
            var placemarksForAnimals = self.getPlacemarksForAnimals()
            for placemarkForAnimal in placemarksForAnimals {
                placemarks.append(placemarkForAnimal)
            }
            if (placemarks.count > 1){
                let exitPlacemark = self.getPlacemarkForExit()
                placemarks.append(exitPlacemark)
            }
            self.placemarks = placemarks
        } else {
            if (self.placemarks.count == 0) {
                return SignalProducer(value: [placemarkForActualPosition])
            }
            self.placemarks[0] = placemarkForActualPosition
        }
        
        return SignalProducer(value: self.placemarks)
    }
    
    
    /**
     This function finds the closest exit from the actual location if the coordinate of the exit from the ZOO wasn't set. It returns a placemark with coordinate of the closest exit. If the coordinate of the exit was set, it returns a placemark with the set coordinate.
     - Returns: A placemark with coordinate of the closest exit. If the coordinate of exit was set, it returns a placemark with the set coordinate of the exit.
    */
    private func getPlacemarkForExit() -> MKPlacemark {
        if (self.isExitSet) {
            return MKPlacemark(coordinate: self.closestExitCoordinate)
        }
        
        for coordinateOfExit in Constants.coordinatesOfExits {
            if (self.closestExitCoordinate == nil) {
                self.closestExitCoordinate = coordinateOfExit
            } else {
                let latitudeDifference = (coordinateOfExit.latitude - self.sourceLocality.latitude)
                let longitudeDifference = (coordinateOfExit.longitude - self.sourceLocality.longitude)
                let distanceFromActualExit = sqrt((latitudeDifference * latitudeDifference) + (longitudeDifference * longitudeDifference))
                
                let smallestLatitudeDifference = (self.closestExitCoordinate.latitude - self.sourceLocality.latitude)
                let smallestLongitudeDifference = (self.closestExitCoordinate.longitude - self.sourceLocality.longitude)
                let smallestDistanceFromExit = sqrt((smallestLatitudeDifference * smallestLatitudeDifference) + (smallestLongitudeDifference * smallestLongitudeDifference))
                
                if (distanceFromActualExit < smallestDistanceFromExit) {
                    self.closestExitCoordinate = coordinateOfExit
                }
            }
        }
        
        return MKPlacemark(coordinate: self.closestExitCoordinate)
    }
    
    
    
    /**
     This function returns placemarks for animals in the correct order so that the path with all animals to visit would be the shortest possible.
     - Returns: The array of placemarks for animals to visit in the correct order.
    */
    private func getPlacemarksForAnimals() -> [MKPlacemark]{
        var placemarksForAnimals: [MKPlacemark] = []
        for animalInPath in self.animalsInPath {
            let coordinateOfAnimal = CLLocationCoordinate2D(latitude: animalInPath.latitude, longitude: animalInPath.longitude)
            let placemark = MKPlacemark(coordinate: coordinateOfAnimal)
            placemarksForAnimals.append(placemark)
        }
        
        if (placemarksForAnimals.count > 6) {
            return self.getPlacemarksForLargerCountOfAnimals(from: placemarksForAnimals)
        }
        
        var permutationsOfPlacemarks: [[MKPlacemark]] = []
        permutations(placemarksForAnimals.count, &placemarksForAnimals, allPermutations: &permutationsOfPlacemarks)
        
        
        var permutationWithShortestTotalDistance = placemarksForAnimals
        var shortestDistance = Double.infinity
        
        for permutationOfPlacemarks in permutationsOfPlacemarks {
            var sourcePlacemark = MKPlacemark(coordinate: self.sourceLocality)
            
            var totalDistance = 0.0
            for placemark in permutationOfPlacemarks {
                let distance = placemark.location!.distance(from: sourcePlacemark.location!)
                sourcePlacemark = placemark
                totalDistance += distance
            }
            
            let exitCoordinate = CLLocationCoordinate2D(latitude: self.closestExitCoordinate.latitude, longitude: self.closestExitCoordinate.longitude)
            let exitPlacemark = MKPlacemark(coordinate: exitCoordinate)
            let distanceFromExit = sourcePlacemark.location!.distance(from: exitPlacemark.location!)
            totalDistance += distanceFromExit
            
            if (totalDistance < shortestDistance) {
                shortestDistance = totalDistance
                permutationWithShortestTotalDistance = permutationOfPlacemarks
            }
        }
        
        return permutationWithShortestTotalDistance
    }
    
    /**
     This function counts the shortest possible path if there is many selected animals (6 or more).
     - Parameters:
        - unorderedPlacemarks: The array of placemarks for animals which are not ordered by the distance from the entrance or the distance from the exit.
     - Returns: The array of placemarks representing the shortest path.
    */
    private func getPlacemarksForLargerCountOfAnimals(from unorderedPlacemarks: [MKPlacemark]) -> [MKPlacemark] {
        let entranceCoordinate = CLLocationCoordinate2D(latitude: self.entranceCoordinate.latitude, longitude: self.entranceCoordinate.longitude)
        var entrancePlacemark = MKPlacemark(coordinate: entranceCoordinate)
        
        let exitCoordinate = CLLocationCoordinate2D(latitude: self.closestExitCoordinate.latitude, longitude: self.closestExitCoordinate.longitude)
        var exitPlacemark = MKPlacemark(coordinate: exitCoordinate)
        
        print(self.entranceCoordinate)
        
        var unprocessedPlacemarks = unorderedPlacemarks
        var placemarksForPath: [MKPlacemark] = []
        
        var index = 0
        while (unprocessedPlacemarks.count > 0) {
            
            if let closestPlacemarkFromEntrance = self.getClosestPlacemark(from: entrancePlacemark, in: unprocessedPlacemarks) as? MKPlacemark {
                if let indexToRemove = unprocessedPlacemarks.index(of: closestPlacemarkFromEntrance) {
                    placemarksForPath.insert(closestPlacemarkFromEntrance, at: index)
                    unprocessedPlacemarks.remove(at: indexToRemove)
                    entrancePlacemark = closestPlacemarkFromEntrance
                }
            }
            
            if let closestPlacemarkFromExit = self.getClosestPlacemark(from: exitPlacemark, in: unprocessedPlacemarks) as? MKPlacemark {
                if let indexToRemove = unprocessedPlacemarks.index(of: closestPlacemarkFromExit) {
                    placemarksForPath.insert(closestPlacemarkFromExit, at: index + 1)
                    unprocessedPlacemarks.remove(at: indexToRemove)
                    exitPlacemark = closestPlacemarkFromExit
                }
            }
            
            index += 1
        }
        
        return placemarksForPath
    }
    
    /**
     This function finds the closest placemark from the given placemark in the array of placemarks representing animals.
     - Parameters:
        - source: The source placemark
        - placemarks: The array of placemarks representing the selected animals in the actual path.
     - Returns: The closest placemark from the given placemark representing an animal.
    */
    private func getClosestPlacemark(from source: MKPlacemark, in placemarks: [MKPlacemark]) -> MKPlacemark? {
        var closestPlacemark: MKPlacemark? = nil
        var shortestDistance = 0.0
        /// loop through all unprocessed placemarks (unselected as the shortest from any other placemark)
        for placemark in placemarks {
            let distanceFromTheActualPlacemark = placemark.location!.distance(from: source.location!)
            
            if (closestPlacemark == nil) {
                closestPlacemark = placemark
                shortestDistance = distanceFromTheActualPlacemark
            } else if (distanceFromTheActualPlacemark < shortestDistance) {
                closestPlacemark = placemark
                shortestDistance = distanceFromTheActualPlacemark
            }
        }
        
        return closestPlacemark
    }
    
    /**
     - Parameters:
        - animal: The animal which is visited now.
    */
    func visitAnimal(_ animal: Animal) {
        let animalCoordinate = CLLocationCoordinate2D(latitude: animal.latitude, longitude: animal.longitude)
        
        var index: Int = 0
        for placemark in self.placemarks[1...] {
            if (placemark.coordinate.latitude == animalCoordinate.latitude &&
                placemark.coordinate.longitude == animalCoordinate.longitude) {
                self.placemarks.remove(at: index)
            }
            index += 1
        }
        
        var indexInArray: Int = 0
        for nonVisitedAnimalInPath in self.nonVisitedAnimalsInPath {
            if (animal.id == nonVisitedAnimalInPath.id) {
                self.nonVisitedAnimalsInPath.remove(at: indexInArray)
                break
            }
            indexInArray += 1
        }
    }
    
    
    /**
     This function ensures that there are not shown the path to the exit after the user gone through the exit from the ZOO.
    */
    func goThroughExit() {
        if (self.closestExitCoordinate == nil) {
            return
        }
        var index: Int = 0
        for placemark in self.placemarks {
            if (abs(placemark.coordinate.latitude - self.closestExitCoordinate.latitude) < 1e-7 &&
                abs(placemark.coordinate.longitude - self.closestExitCoordinate.longitude) < 1e-7) {
                self.placemarks.remove(at: index)
            }
            index += 1
        }
    }
    
    /**
     This recursive function finds all permutations of the array with placemarks at positions of animals for finding the shortest path with all selected animals in the actual path.
     - Parameters:
        - n: Number of elements to permutate
        - placemarksPermutation: The array of placemarks which is permutated
        - allPermutations: The array of all found permutations.
    */
    private func permutations(_ n: Int, _ placemarksPermutation: inout Array<MKPlacemark>, allPermutations: inout Array<Array<MKPlacemark> >) {
        if (n <= 1) {
            allPermutations.append(placemarksPermutation)
            return
        }
        
        for i in 0..<n-1 {
            permutations(n - 1, &placemarksPermutation, allPermutations: &allPermutations)
            placemarksPermutation.swapAt(n - 1, (n % 2 == 1) ? 0 : i)
        }
        permutations(n - 1, &placemarksPermutation, allPermutations: &allPermutations)
    }

    
    /**
     This function finds and returns an animal which is enough close (both coordinates of the animal can differ from the given ones not more than about 0,000045).
     - Parameters:
        - latitude: The first coordinate (latitude) of the actual location
        - longiture: The second coordinate (longitude) of the actual location
     - Returns: A signal producer with animals which is enough close or nil if there is no any enough close animal.
    */
    func getCloseAnimalInPath(latitude: Double, longitude: Double) -> SignalProducer<Animal?, Error> {
        for animalInPath in self.nonVisitedAnimalsInPath {
            if (abs(animalInPath.latitude - latitude) < Constants.closeDistance && abs(animalInPath.longitude - longitude) < Constants.closeDistance) {
                return SignalProducer(value: animalInPath)
            }
        }
        return SignalProducer(value: nil)
    }
    
    
    /**
    This function returns the number of unvisited animals in the actual path.
     - Returns: A signal producer with the number of unvisited animals in the path.
     */
    func getCountOfUnvisitedAnimals() -> SignalProducer<Int, Error> {
        return SignalProducer(value: self.nonVisitedAnimalsInPath.count)
    }
    
    
    /**
     This function returns a signal producer with the animal which should be visited by the user. If user visited all selected animals, it returns a signal producer with nil value.
     - Returns: A signal producer with the animal which should be visited by the user (or nil if user visited all selected animals).
    */
    func getNextAnimalInThePath() -> SignalProducer<Animal?, Error> {
        if (self.nonVisitedAnimalsInPath.count == 0 || self.placemarks.count < 2) {
            return SignalProducer(value: nil)
        }
        
        var nextAnimalInPath: Animal!
        for nonVisitedAnimalInPath in self.nonVisitedAnimalsInPath {
            if (abs(nonVisitedAnimalInPath.latitude - self.placemarks[1].coordinate.latitude) < 1e-7 &&
                abs(nonVisitedAnimalInPath.longitude - self.placemarks[1].coordinate.longitude) < 1e-7) {
                nextAnimalInPath = nonVisitedAnimalInPath
            }
        }
        return SignalProducer(value: nextAnimalInPath)
    }
}
