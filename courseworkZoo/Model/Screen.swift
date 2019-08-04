//
//  Screen.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 25/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represents a screen where the user can go from the result of search by the search bar in the lexicon part of the application.
*/
class Screen{
    /// The title of the screen
    var title: String
    /// The animal bound with this screen.
    var animal: Animal?
    /// The class or order bound with this screen.
    var classOrOrder: Class?
    /// The continent bound with this screen.
    var continent: Continent?
    /// The biotope bound with this screen.
    var biotope: Biotope?
    /// The kind of food bound with this screen.
    var kindOfFood: Food?
    /// The locality (probably pavilion) bound with this screen.
    var pavilion: Locality?
    
    /**
     - Parameters:
         - title: The title of the screen.
         - animal: The animal bound with this screen.
         - classOrOrder: The class or order of animals bound with this screen.
         - continent: The continent bound with this screeen.
         - biotope: The biotope bound with this screen.
         - kindOfFood: The kind of food bound with this screen.
         - pavilion: The locality (probably pavilion) bound with this screen.
    */
    init(title: String, animal: Animal?, classOrOrder: Class?, continent: Continent?, biotope: Biotope?, kindOfFood: Food?, pavilion: Locality?){
        self.title = title
        self.animal = animal
        self.classOrOrder = classOrOrder
        self.continent = continent
        self.biotope = biotope
        self.kindOfFood = kindOfFood
        self.pavilion = pavilion
    }
}
