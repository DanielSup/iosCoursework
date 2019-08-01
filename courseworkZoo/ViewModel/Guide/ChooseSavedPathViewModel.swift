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
    
    private let dependencies: Dependencies
    
    lazy var getAllPaths = Action<(), [Path], Error>{
        [unowned self] in
        return self.dependencies.pathRepository.getAllPaths()
    }
    
    // MARK - Constructor and other functions
    
    
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }

    func chooseSavedPath(path: Path){
        self.dependencies.pathRepository.selectPath(path: path)
    }
}
