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
    /// The biotop bound with this screen.
    var biotope: Biotope?
    /// The class or order bound with this screen.
    var classOrOrder: Class?
    /// The locality (probably pavilion) bound with this screen.
    var pavilion: Locality?
    
    /**
     - Parameters:
         - title: The title of the screen.
         - animal: The animal bound with this screen.
         - biotope: The biotope bound with this screen.
         - classOrOrder: The class or order of animals bound with this screen.
         - pavilion: The locality (probably pavilion) bound with this screen.
    */
    init(title: String, animal: Animal?, biotope: Biotope?, classOrOrder: Class?, pavilion: Locality?){
        self.title = title
        self.animal = animal
        self.biotope = biotope
        self.classOrOrder = classOrOrder
        self.pavilion = pavilion
    }
}
