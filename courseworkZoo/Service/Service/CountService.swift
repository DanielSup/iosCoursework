//
//  CountService.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 09/08/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit

/**
 This service is used for counting whether the entrance is on the path between the actual position and the first animal.
*/
class CountService {

    /**
     This function returns the coordinate of the entrance to the ZOO which is at the line. If there is no entrance at the line, it returns nil.
     - Returns: The coordinate of the entrance at the line or nil if there is no entrance at the line.
    */
    static func entranceAtTheLine(a: CLLocationCoordinate2D, b: CLLocationCoordinate2D) -> CLLocationCoordinate2D?{
        for coordinateOfEntrance in Constants.coordinatesOfEntrances {
            if (CountService.isEntranceAtTheLine(a: a, b: b, entrance: coordinateOfEntrance)) {
                return coordinateOfEntrance
            }
        }
        return nil
    }
    
    /**
     This function finds out and returns whether the entrance to ZOO is at the line or not.
     - Parameters:
        - a: The start point of the line
        - b: The end point of the line
    */
    static func isEntranceAtTheLine(a: CLLocationCoordinate2D, b: CLLocationCoordinate2D, entrance: CLLocationCoordinate2D) -> Bool{
        
        let mainLine = Line(x1: a.latitude, y1: a.longitude, x2: b.latitude, y2: b.longitude)
        
        var constant = Constants.closeDistance * (-mainLine.b) * abs(mainLine.a / mainLine.b)
        
        let upperLine = Line(a: mainLine.a, b: mainLine.b, c: mainLine.c + constant)
        let bottomLine = Line(a: mainLine.a, b: mainLine.b, c: mainLine.c - constant)
    
        let startLine = Line(x: a.latitude, y: a.longitude, v1: mainLine.a, v2: mainLine.b)
        let destinationLine = Line(x: b.latitude, y: b.longitude, v1: mainLine.a, v2: mainLine.b)
        
        if (upperLine.isPointOnUnderOrAbove(x: entrance.latitude, y: entrance.longitude) == 1 || bottomLine.isPointOnUnderOrAbove(x: entrance.latitude, y: entrance.longitude) == -1) {
            return false
        }
        
        if (startLine.isPointOnUnderOrAbove(x: entrance.latitude, y: entrance.longitude) == 1 && destinationLine.isPointOnUnderOrAbove(x: entrance.latitude, y: entrance.longitude) == 1) {
            return false
        }
        
        if (startLine.isPointOnUnderOrAbove(x: entrance.latitude, y: entrance.longitude) == -1 && destinationLine.isPointOnUnderOrAbove(x: entrance.latitude, y: entrance.longitude) == -1) {
            return false
        }
        
        return true
    }
}
