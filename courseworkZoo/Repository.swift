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
    
    func reload(){
        if (entities.value == nil){
            let result = self.getEntities()
            if (result != nil){
                entities.value = result
                self.lastEdited = Date()
            }
        } else if (entities.value!.count == 0){
            let result = self.getEntities()
            entities.value = result
            self.lastEdited = Date()
        } else {
            let threeHoursAgo:Date = Date(timeIntervalSinceNow: -3*60*60)
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
