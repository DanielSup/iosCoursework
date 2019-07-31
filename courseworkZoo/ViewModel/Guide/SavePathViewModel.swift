//
//  SavePathViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 11/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This view model is used for the popover view controller for saving the actual path.
*/
class SavePathViewModel: BaseViewModel {
    typealias Dependencies = HasPathRepository
    
    // The object with a path repository for saving paths.
    private var dependencies: Dependencies
    
    /**
     - Parameters:
        - dependencies: The object with a path repository for saving paths.
    */
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init()
    }
    
    /**
     This function ensures saving the actual path with the given title.
     - Parameters:
        - title: The title which we save the actual path with.
    */
    func saveActualPath(with title: String){
        self.dependencies.pathRepository.saveActualPath(with: title)
    }
}
