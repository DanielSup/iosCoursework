//
//  BaseFlowCoordinator.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

class BaseFlowCoordinator{
    init(){
        NSLog("Flow coordinator created: \(self)")
    }
    
    deinit {
        NSLog("Flow coordinator deleted: \(self)")
    }
}
