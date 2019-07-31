//
//  APIService.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 12/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is used for working with the NodeJS server. This class ensures getting the array of entities from the result in JSON. */
class APIService {
    // The base URL of the NodeJS server.
    private static let serverUrl = Constants.serverUrl
    
    /**
     This function ensures getting the array of entities of the given type which is ancestor of Codable. It is used for getting an array of entities from the NodeJS server.
     - Parameters:
        - relativeUrl: The relative URL within the NodeJS server. It contains the path to the script with entities of the given type.
     - Returns: An array of entities got from JSON output from the page on the NodeJS server.
     */
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
