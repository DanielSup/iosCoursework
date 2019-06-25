//
//  Repository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift

class Repository<T: Codable> {
    lazy var entities = MutableProperty<[T]?>([])
    private var lastEdited: Date = Date()
    private let url: String
    init(url: String){
        self.url = url
    }
    
    func getEntities() -> [T]? {
        let result: String = APIService.getResultsOfAPICall(url: Constants.server + url)
        if(result == "error" || result == "content could not be loaded"){
            return nil
        }
        var entities: [T] = []
        let entitiesInJson = result.parseJSONString
        let decoder = JSONDecoder()
        for entityInJson in entitiesInJson{
            let entityObject = try? decoder.decode(T.self, from: entityInJson)
            if let entity = entityObject as? T {
                entities.append(entity)
            }
        }
        return entities
    }
    /**
     This function ensures loading data from server and
     */
    func reload(){
        // if data were loaded unsuccessfully after the starting of the application
        if (entities.value == nil){
            // updating of result in case that data could not be loaded previously
            let result = self.getEntities()
            if (result != nil){
                entities.value = result
                self.lastEdited = Date()
            }
            
        // after the starting of the application
        } else if (entities.value!.count == 0){
            // loading of the data in the beginning
            let result = self.getEntities()
            entities.value = result
            self.lastEdited = Date()
            
        // in other cases - data were loaded successfully last time
        } else {
            // updating of loaded data each 3 hours
            let threeHoursAgo:Date = Date(timeIntervalSinceNow: -3*60*60)
            
            // updating of loaded data when data was loaded more than 3 hours ago
            if (self.lastEdited < threeHoursAgo){
                let result = self.getEntities()
                if (result != nil){
                    entities.value = result
                    self.lastEdited = Date()
                }
            }
        }
    }
    
}
