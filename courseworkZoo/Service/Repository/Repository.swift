//
//  Repository.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import ReactiveSwift


class Repository<T: LoadedEntity>{
    /// array of entities which is used for storing information loaded from the NodeJS server
    lazy var entities = MutableProperty<[T]?>([])
    /// date of last editation or loading of array of entities
    private var lastEdited: Date = Date()
    
    
    /**
     This function ensures loading data from server and
     */
    func loadAndSaveDataIfNeeded(){
        // if data were loaded unsuccessfully after the starting of the application
        if (entities.value == nil){
            // updating of result in case that data could not be loaded previously
            let result: [T]? = APIService.getEntitiesGotByAPICall(relativeUrl: T.relativeUrl)
            if (result != nil){
                entities.value = result
                self.lastEdited = Date()
            }
            
        // after the starting of the application
        } else if (entities.value!.count == 0){
            // loading of the data in the beginning
            let result: [T]? = APIService.getEntitiesGotByAPICall(relativeUrl: T.relativeUrl)
            entities.value = result
            self.lastEdited = Date()
            
        // in other cases - data were loaded successfully last time
        } else {
            // updating of loaded data each 3 hours
            let threeHoursAgo:Date = Date(timeIntervalSinceNow: -3*60*60)
            
            // updating of loaded data when data was loaded more than 3 hours ago
            if (self.lastEdited < threeHoursAgo){
                let result: [T]? = APIService.getEntitiesGotByAPICall(relativeUrl: T.relativeUrl)
                if (result != nil){
                    entities.value = result
                    self.lastEdited = Date()
                }
            }
        }
    }
    
}
