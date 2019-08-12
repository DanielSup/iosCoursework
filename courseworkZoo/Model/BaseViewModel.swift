//
//  BaseViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 15/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represents a base view model. It is used for checking possible memory leaks and finding out whether localities and animals were visited or not.
 */
class BaseViewModel {
    
    init(){
        NSLog("Created ViewModel: \(self)")
    }
    
    deinit{
        NSLog("Removing ViewModel: \(self)")
    }
}
