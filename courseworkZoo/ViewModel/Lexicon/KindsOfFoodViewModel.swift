//
//  KindsOfFoodViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 31/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view model for the screen with the list of kinds of food which animals can eat.
*/
class KindsOfFoodViewModel: BaseViewModel {
    
    /**
     This function returns all nine kinds of food which animals can eat.
     - Returns: The list of kinds of food which animals can eat.
    */
    func getKindsOfFood() -> [Food] {
        var kindsOfFood: [Food] = []
        for i in 1...9 {
            let kindOfFood = Food.getFoodWithId(id: i)
            kindsOfFood.append(kindOfFood)
        }
        return kindsOfFood
    }
}
