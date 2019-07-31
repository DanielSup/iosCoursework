//
//  ParametersOfVisitRepository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 10/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This protocol is used for the dependency injection. It ensures working with any implementation of a repository for setting the parameters of the visit of the ZOO (walk speed and time spent at one animal).
*/
protocol ParametersOfVisitRepositoring{
    func setParameters(walkSpeed: Float, timeSpentAtOneAnimal: Float)
    func getWalkSpeed() -> SignalProducer<Float, Error>
    func getTimeSpentAtOneAnimal() -> SignalProducer<Float, Error>
}

/**
 This class is used for setting the parameters of the actual visit of ZOO.
*/
class ParametersOfVisitRepository : ParametersOfVisitRepositoring {
    /// The key for saving the walk speed through the ZOO.
    static var walkSpeedKey = "WalkSpeedThroughZOO"
    /// The time spent at one animal during the visit of the ZOO.
    static var timeSpentAtOneAnimalKey = "TimeSpentAtOneAnimal"

    
    /**
     This function ensures setting and saving values of parameters of the visit of the ZOO (walk speed and time spent at one animal).
     - Parameters:
        - walkSpeed: The walk speed during the visit of the ZOO.
        - timeSpentAtOneAnimal: The time spent at one animal during the visit of the ZOO.
    */
    func setParameters(walkSpeed: Float, timeSpentAtOneAnimal: Float){
        UserDefaults.standard.set(walkSpeed, forKey: ParametersOfVisitRepository.walkSpeedKey)
        UserDefaults.standard.set(timeSpentAtOneAnimal, forKey: ParametersOfVisitRepository.timeSpentAtOneAnimalKey)
        UserDefaults.standard.synchronize()
    }
    
    /**
     This function returns the walk speed during the visit of the ZOO.
     - Returns: A signal producer with the walk speed during the visit of the ZOO.
    */
    func getWalkSpeed() -> SignalProducer<Float, Error>{
        let walkSpeed = UserDefaults.standard.float(forKey: ParametersOfVisitRepository.walkSpeedKey)
        if (walkSpeed <= 0){
            return SignalProducer(value: 3.0)
        }
        return SignalProducer(value: walkSpeed)
    }
    
    /**
     This function returns the time spent at one animal during the visit of the ZOO.
     - Returns: A signal producer with the time spent at one animal during the visit of the ZOO.
    */
    func getTimeSpentAtOneAnimal() -> SignalProducer<Float, Error> {
        let timeSpentAtOneAnimal = UserDefaults.standard.float(forKey: ParametersOfVisitRepository.timeSpentAtOneAnimalKey)
        if (timeSpentAtOneAnimal <= 0){
            return SignalProducer(value: 3.0)
        }
        return SignalProducer(value: timeSpentAtOneAnimal)
    }
}
