//
//  APIService.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 12/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

class APIService {
    private static let serverUrl = Constants.serverUrl
    
    static func getEntitiesGotByAPICall<T: Codable> (relativeUrl: String) -> [T]?{
        if let url = URL(string: serverUrl + relativeUrl){
            do {    
                let content = try String(contentsOf: url)
                
                var entitiesFromAPICall: [T] = []
                let entitiesInJson =  content.parseJSONString
                let decoder = JSONDecoder()
                for entityInJson in entitiesInJson{
                    let entityObject = try? decoder.decode(T.self, from: entityInJson)
                    if let entity = entityObject as? T {
                        entitiesFromAPICall.append(entity)
                    }
                }
                return entitiesFromAPICall
                
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}
