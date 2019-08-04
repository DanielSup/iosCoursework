//
//  ChooseSavedPathViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 10/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//


import UIKit
import ReactiveSwift

/**
 This class is a view model for the screen for choosing a path from the saved paths.
 */
class ChooseSavedPathViewModel: BaseViewModel {
    typealias Dependencies = HasPathRepository
    /// The object with the path repository for working with paths (getting all paths and choosing a saved path).
    private let dependencies: Dependencies
    
    /**
     This action returns a signal producer with the list of saved paths.
    */
    lazy var getAllPaths = Action<(), [Path], Error>{
        [unowned self] in
        return self.dependencies.pathRepository.getAllPaths()
    }
    
    // MARK - Constructor and other functions
    
    
    /**
     - Parameters:
     - dependencies: The object with the path repository for working with paths (getting all saved paths and choosing a saved path).
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }

    /**
     This function ensures choosing the given saved path with a list of animals. The saved path contains animals which the user will visit during the visit of the ZOO.
     - Parameters:
        - path: The path with the list of animals for visit which is choosed.
    */
    func chooseSavedPath(path: Path){
        self.dependencies.pathRepository.selectPath(path: path)
    }
}
