//
//  SettingParametersOfVisitViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 12/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 This class is a view model fot the screen for setting the parameters of the actual visit of the ZOO (walk speed and time spent at one animal).
 */
class SettingParametersOfVisitViewModel: BaseViewModel {
    typealias Dependencies = HasParametersOfVisitRepository
    
    /// The object with dependencies important for the actions in this view model.
    private var dependencies: Dependencies
    
    // MARK - Actions
    
    /**
     This action returns the walk speed during the visit of the ZOO.
    */
    lazy var getWalkSpeed = Action<(), Float, Error>{
        [unowned self] in
        return self.dependencies.parametersOfVisitRepository.getWalkSpeed()
    }
    
    /**
     This action returns the time spent at one animal during the visit of the ZOO.
    */
    lazy var getTimeSpentAtOneAnimal = Action<(), Float, Error>{
        [unowned self] in
        return self.dependencies.parametersOfVisitRepository.getTimeSpentAtOneAnimal()
    }
    
    // MARK - Constructor and other methods
    
    /**
     - Parameters:
        - dependencies: The object with dependencies important for the action in this view model.
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
    
    
    /**
     This function ensures setting the parameters of the visit of the ZOO.
     - Parameters:
        - walkSpeed: The walk speed during the visit of the ZOO.
        - timeSpentAtOneAnimal: The time spent at any one animal during the visit of the ZOO.
    */
    func setParameters(walkSpeed: Float, timeSpentAtOneAnimal: Float){
        self.dependencies.parametersOfVisitRepository.setParameters(walkSpeed: walkSpeed, timeSpentAtOneAnimal: timeSpentAtOneAnimal)
    }
}
