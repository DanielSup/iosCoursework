//
//  ClassRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 18/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This protocol is used for the dependency injection. This protocol ensures working with a repository for getting a list of classes and orders in a class.
*/
protocol ClassRepositoring {
    var entities: MutableProperty<[Class]?> { get }
    func loadAndSaveDataIfNeeded()
    func getClasses() -> SignalProducer<[Class], LoadError>
    func getOrdersInCategory(_ category: Class) -> SignalProducer<[Class], LoadError>
}

/**
 This class is a child class of Repository class for working with categories of animals (especially classes and orders). This class ensures getting the list of classes and list of orders in a given class.
*/
class ClassRepository: Repository<Class>, ClassRepositoring {
    
    /**
     This function gets the list of categories, which are classes. If the classes could not be loaded, this function returns an error.
     - Returns: A signal producer with the list of classes or with an error meaning that categories (classes) could not be loaded.
    */
    func getClasses() -> SignalProducer<[Class], LoadError> {
        if let classEntities = self.entities.value as? [Class]{
            var onlyClasses: [Class] = []
            for classEntity in classEntities {
                if (classEntity.type == "class"){
                    onlyClasses.append(classEntity)
                }
            }
            return SignalProducer(value: onlyClasses)
        } else {
            return SignalProducer(error: .noClasses)
        }
    }
    
    /**
     This function gets the list of orders which are in the given class. If the classes could not be loaded, this function returns an error.
     - Returns: A signal producer with the list of orders which are in the given class or with an error meaning that categories (classes and orders) could not be loaded.
    */
    func getOrdersInCategory(_ category: Class) -> SignalProducer<[Class], LoadError> {
        if let classEntities = self.entities.value as? [Class]{
            var ordersInCategory: [Class] = []
            for classEntity in classEntities {
                if (classEntity.type == "order" && category.id == classEntity.parentCategory){
                    ordersInCategory.append(classEntity)
                }
            }
            return SignalProducer(value: ordersInCategory)
        } else {
            return SignalProducer(error: .noClasses)
        }
    }
}
