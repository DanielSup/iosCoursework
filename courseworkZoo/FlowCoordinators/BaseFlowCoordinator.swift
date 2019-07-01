//
//  BaseFlowCoordinator.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is the parent class of any flow coordinator. It ensures printing when was a flow coordinator created or removed.
 */
class BaseFlowCoordinator{
    init(){
        NSLog("Flow coordinator created: \(self)")
    }
    
    deinit {
        NSLog("Flow coordinator deleted: \(self)")
    }
}
