//
//  LocalityViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 15/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit
import ReactiveSwift

class LocalityViewModel: BaseViewModel {
    fileprivate var localityRepository: LocalityRepository
    fileprivate var speechService: SpeechService
    private var localityList = MutableProperty<[Locality]>([])
    private var latitude = MutableProperty<Double>(-1)
    private var longitude = MutableProperty<Double>(-1)
    
    lazy var localityInClosenessAction = Action<(), Locality?, LoadError> { [unowned self] in
        print(self.latitude.value)
        if let localities = self.localityList.value as? [Locality] {
            return self.localityRepository.findLocalityInCloseness(latitude: self.latitude.value, longitude: self.longitude.value)
        } else {
            return SignalProducer<Locality?, LoadError>(error: .noLocalities)
        }
    }
    
    lazy var getAllLocalitiesAction = Action<(), [Locality], LoadError>{
        [unowned self] in
        self.localityRepository.reload()
        if let localities = self.localityRepository.localities.value as? [Locality] {
            return SignalProducer<[Locality], LoadError>(value: localities)
        } else {
            return SignalProducer<[Locality], LoadError>(error: .noLocalities)
        }
    }
    
    lazy var getLocalitiesAction = Action<(), [Locality], LoadError>{
        [unowned self] in
        print("get localities action")
        self.localityRepository.reload()
        if let localities = self.localityRepository.localities.value as? [Locality] {
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
    
    func updateLocation(latitude: Double, longitude: Double){
        self.latitude.value = latitude
        self.longitude.value = longitude
    }
    
    init(localityRepository: LocalityRepository, speechService: SpeechService){
        self.localityRepository = localityRepository
        self.speechService = speechService
        if let localities = self.localityRepository.localities.value as? [Locality] {
            self.localityList.value = localities
        }
        super.init()
    }
    
    func getAnnotationsForMap() -> [MKPointAnnotation] {
        var annotationsForMap: [MKPointAnnotation] = []
        let localitiesList = self.getLocalitiesAction.values.producer.startWithValues{ (localitiesList) in
            for locality in localitiesList{
                if(locality.latitude < 0){
                    continue
                }
                let annotation: MKPointAnnotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: locality.latitude, longitude: locality.longitude)
                annotation.coordinate = coordinate
                annotation.title = locality.title
                annotationsForMap.append(annotation)
            }
        }
        return annotationsForMap
    }
    
    func sayInformationAboutLocality(locality: Locality?){
        if let localityForSaying = locality as? Locality {
            let latitude = localityForSaying.latitude
            let longitude = localityForSaying.longitude
            let coords = Coords(latitude: latitude, longitude: longitude)
            let existsPosition = BaseViewModel.existsPosition(latitude: latitude, longitude: longitude)
            if(!existsPosition){
                BaseViewModel.visited.append(coords)
                let title = localityForSaying.title.replacingOccurrences(of: "Pavilon", with: "Pavilonu")
                speechService.sayText(text: "Vítejte v "+title)
            }
        }
    }
}
