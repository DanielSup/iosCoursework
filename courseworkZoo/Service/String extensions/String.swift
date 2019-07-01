//
//  String.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 14/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

extension String {
    /**
     This property is used for getting an array of entities from JSON output from the NodeJS server.
     - Returns: An array of Data entities for retrieving entity from the result from server in JSON.
     */
    var parseJSONString: [Data]
    {
        var arrayOfJsons: [Data] = []
        let entities = self.components(separatedBy: "},{")
        
        for entity in entities{
            let startIndex = entity.index(entity.startIndex, offsetBy: 2)
            let endIndex = entity.index(entity.endIndex, offsetBy: -2)
            
            if (entity[..<startIndex] == "[{"){
                let indexOfBracket = entity.index(entity.startIndex, offsetBy: 1)
                let newEntity = entity[indexOfBracket...]+"}"
                if let jsonData = newEntity.data(using: .utf8){
                    arrayOfJsons.append(jsonData)
                }
                
            } else if(entity[endIndex...] == "}]"){
                let indexOfEndBracket = entity.index(entity.endIndex, offsetBy: -1)
                let newEntity = "{"+entity[..<indexOfEndBracket]
                if let jsonData = newEntity.data(using: .utf8){
                    arrayOfJsons.append(jsonData)
                }
                
            } else {
                let newEntity = "{"+entity+"}"
                if let jsonData = newEntity.data(using: .utf8){
                    arrayOfJsons.append(jsonData)
                }
            }
        }
        
        return arrayOfJsons
    }
}
