//
//  Animal.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 03/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

struct Animal: Codable{
    let title: String
    let latinTitle: String
    let classOfAnimal: String
    let order: String
    let description: String
    let image: String
    let imageAlt: String
    let continent: Continent
    let spread: String
    let food: String
    let foodNote: String
    let biotope: String
    let attractions: String
    let breeding: String
    let localities: String
    let actualities: [Actuality]
    let latitude: Double
    let longitude: Double
    enum CodingKeys: String, CodingKey{
        case title, latinTitle = "latin_title", classOfAnimal="classes", order, description, image="image_src", imageAlt="image_alt", continent="continents", spread="spread_note", food, foodNote="food_note", biotope="biotop", attractions, breeding, localities="localities_title", actualities, latitude="gps_x",longitude="gps_y"
    }
    
}
