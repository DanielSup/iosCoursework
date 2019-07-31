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
    func setAnimalsInPath(_ animalsInPath: [Animal])
    func getPlacemarksForTheActualPath(countPath: Bool) -> SignalProducer<[MKPlacemark], Error>
    func visitAnimal(_ animal: Animal)
}


/**
 This class is used for finding the shortest combination of routes with all animals in the actual path. It also finds shortest path between two placemarks
*/
class RouteWithAnimalsService: NSObject, MKMapViewDelegate, RouteWithAnimalsServicing {
    
    private var mapView: MKMapView = MKMapView()
    /// The array of animals in the path.
    private var animalsInPath: [Animal] = []
    /// The array of placemarks of animals and the placemark for the actual location
    private var placemarks: [MKPlacemark] = []
    /// The actual coordinate.
    private var sourceLocality: CLLocationCoordinate2D!
    
    
    
    /**
     This function sets the list of animals in the actual path.
     - Parameters:
        - animalsInRoute: The list of animals in the actual path.
    */
    func setAnimalsInPath(_ animalsInPath: [Animal]){
        self.animalsInPath = animalsInPath
    }
    
    /**
     This function sets the actual locality after the choosing the saved path, adding an animal to the actual path or removing an animal from the actual path.
     - Parameters:
        - sourceLocality: The actual locality after the choosing the saved path or editing the actual path.
    */
    func setSourceLocality(_ sourceLocality: CLLocationCoordinate2D){
        self.sourceLocality = sourceLocality
    }
    
    
    func getPlacemarksForTheActualPath(countPath: Bool) -> SignalProducer<[MKPlacemark], Error> {
        let placemarkForActualPosition = MKPlacemark(coordinate: self.sourceLocality)
        if (countPath) {
            var placemarks: [MKPlacemark] = [placemarkForActualPosition]
            var placemarksForAnimals = self.getPlacemarksForAnimals()
            for placemarkForAnimal in placemarksForAnimals {
                placemarks.append(placemarkForAnimal)
            }
            self.placemarks = placemarks
        } else {
            self.placemarks[0] = placemarkForActualPosition
        }
    
        return SignalProducer(value: self.placemarks)
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
            
            if (totalDistance < shortestDistance) {
                shortestDistance = totalDistance
                permutationWithShortestTotalDistance = permutationOfPlacemarks
            }
        }
        
        return permutationWithShortestTotalDistance
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

    
}
