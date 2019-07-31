//
//  ContinentsViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 30/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view model for the screen with the list of continents where animals can live. In this screen is shown that there could be animal which don't live anywhere in nature.
*/
class ContinentsViewModel: BaseViewModel {
    /**
     This function returns an array of continents where animals can live. One of these continents represents that there could be an animal which doesn't live anywhere in nature.
     - Returns: The array of continents and one option representing that an animal doesn't live anywhere in nature.
    */
    func getContinents() -> [Continent] {
        var continents: [Continent] = []
        for i in 1...7 {
            let continent = Continent.getContinentWithId(id: i)
            continents.append(continent)
        }
        return continents
    }
}
