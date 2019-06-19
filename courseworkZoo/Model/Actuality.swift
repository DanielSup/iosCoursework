//
//  Actuality.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 17/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

class Actuality: Codable {
    let title: String
    let perex: String
    let textOfArticle: String
    enum CodingKeys: String, CodingKey{
        case title, perex, textOfArticle
    }}
