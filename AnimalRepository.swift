//
//  AnimalRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 04/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

protocol HasAnimalRepository {
    var animalRepository: AnimalRepositoring { get }
}

protocol AnimalRepositoring{
    var animals: MutableProperty<[Animal]?>{ get }
    func reload()
    func findAnimalInCloseness(latitude: Double, longitude: Double) -> SignalProducer<Animal?, LoadError>
}

class AnimalRepository: AnimalRepositoring {
    lazy var animals = MutableProperty<[Animal]?>([])
    private var lastEdited: Date = Date()
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
        if(animals.value == nil){
            let result = self.getAnimals()
            if (result != nil){
                animals.value = result
                self.lastEdited = Date()
            }
        } else if(animals.value!.count == 0){
            let result = self.getAnimals()
            if (result != nil){
                animals.value = result
                self.lastEdited = Date()
            }
        } else {
            let threeHoursAgo:Date = Date(timeIntervalSinceNow: -3*60*60)
            if (self.lastEdited < threeHoursAgo){
                let result = self.getAnimals()
                if (result != nil){
                    animals.value = result
                    self.lastEdited = Date()
                }
            }
        }
    }
    
    func findAnimalInCloseness(latitude: Double, longitude: Double) -> SignalProducer<Animal?, LoadError>{
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
