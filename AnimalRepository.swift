//
//  AnimalRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 04/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

class AnimalRepository: NSObject {
    lazy var animals = MutableProperty<[Animal]?>([])
    
    func getAnimals() -> [Animal]? {
        print("Getting animals")
        let result: String = APIService.getResultsOfAPICall(url: Constants.server+Constants.animals)
        if(result == "error" || result == "content could not be loaded"){
            return nil
        }
        var animals :[Animal] = []
        let animalsInJson = result.parseJSONString
        let decoder = JSONDecoder()
        for animalInJson in animalsInJson{
            let animalObject = try? decoder.decode(Animal.self, from: animalInJson)
            if let animal = animalObject as? Animal {
                animals.append(animal)
            }
        }
        return animals
    }
    
    func reload(){
        animals.value = self.getAnimals()
    }
    
    func findAnimalInCloseness(latitude: Double, longitude: Double) -> SignalProducer<Animal?, LoadError>{
        print("finding animal in closeness ")
        print(latitude)
        print(longitude)
        if let animalList = self.animals.value as? [Animal] {
            for animal in animalList{
                if(abs(animal.latitude - latitude) < BaseViewModel.closeDistance && abs(animal.longitude - longitude) < BaseViewModel.closeDistance){
                    return SignalProducer(value: animal)
                }
            }
            return SignalProducer(value: nil)
        } else {
            return SignalProducer(error: .noAnimals)
        }
    }
}
