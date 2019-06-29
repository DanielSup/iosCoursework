//
//  AnimalRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 04/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift


protocol AnimalRepositoring{
    var entities: MutableProperty<[Animal]?> { get }
    func loadAndSaveDataIfNeeded()
    func findAnimalById(id: Int) -> SignalProducer<Animal?, LoadError>
    func findAnimalInCloseness(latitude: Double, longitude: Double) -> SignalProducer<Animal?, LoadError>
}


class AnimalRepository: Repository<Animal>, AnimalRepositoring{
    
    func findAnimalById(id: Int) -> SignalProducer<Animal?, LoadError> {
        if let animalList = self.entities.value as? [Animal] {
            for animal in animalList{
                if(animal.id == id){
                    return SignalProducer(value: animal)
                }
            }
            return SignalProducer(value: nil)
        } else {
            return SignalProducer(error: .noAnimals)
        }
    }
    
    func findAnimalInCloseness(latitude: Double, longitude: Double) -> SignalProducer<Animal?, LoadError> {
        if let animalList = self.entities.value as? [Animal] {
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
