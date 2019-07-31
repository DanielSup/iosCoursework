//
//  BiotopesViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view model for the screen with the list of biotopes. There are no dependencies used.
*/
class BiotopesViewModel: BaseViewModel {
    
    /**
     This function returns the list of all biotopes as an array. There are added all 11 biotopes (there are 11 biotopes - it is known number).
    */
    func getBiotopes() -> [Biotope]{
        var allBiotopes: [Biotope] = []
        for i in 1...11 {
            let biotope = Biotope.getBiotopeWithId(id: i)
            allBiotopes.append(biotope)
        }
        return allBiotopes
    }
}
