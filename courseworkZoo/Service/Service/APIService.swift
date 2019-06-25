//
//  APIService.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 12/05/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

class APIService: NSObject {
    static func getResultsOfAPICall(url: String) -> String{
        if let url = URL(string: url){
            do {    
                let contents = try String(contentsOf: url)
                return contents
            } catch {
                return "content could not be loaded"
            }
        } else {
            return "error"
        }
    }
}
