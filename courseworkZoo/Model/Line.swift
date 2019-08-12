//
//  Line.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 09/08/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represents a line. It is represented by this expression: ax + by + c = 0
 */
class Line{
    /// The first parameter before x (a)
    var a: Double
    /// The second parameter before y (b)
    var b: Double
    /// The third parameter (the constant c)
    var c: Double
    
    /**
    This constructor counts the parameters a, b, c by the given two points.
     - Parameters:
        - x1: The x coord of the first point
        - y1: The y coord of the first point
        - x2: The x coord of the second point
        - y2: The y coord of the second point
    */
    init(x1: Double, y1: Double, x2: Double, y2: Double) {
        let s1 = x2 - x1
        let s2 = y2 - y1
        
        let n1 = s2
        let n2 = -s1
        
        self.a = n1
        self.b = n2
        self.c = -(n1 * x1 + n2 * y1)
    }
    
    
    /**
     This constructor counts the parameters a, b, c by the given point and directional vector.
     - Parameters:
         - x: The x coord of the point
         - y: The y coord of the point
         - v1: The first dimension of the directional vector
         - v2: The second dimension of the directional vector
    */
    init(x: Double, y: Double, v1: Double, v2: Double) {
        self.a = v2
        self.b = -v1
        self.c = -(v2 * x  - v1 * y)
    }
    
    
    /**
     This constructor sets the parameters a, b, c.
     - Parameters:
         - a: The first parameter before x
         - b: The second parameter before y
         - c: The third parameter (constant)
    */
    init(a: Double, b: Double, c: Double) {
        self.a = a
        self.b = b
        self.c = c
    }
    
    
    /**
     This function finds out and returns whether the given point is above the line, on the line or under the line. If the given point is on the line, it returns 0. If the given point is under the line, it returns -1. Else it returns 1.
     - Parameters:
         - x: The x coord of the point
         - y: The y coord of the point
     - Returns: An integer representing whether the given point is under the line, on the line or above the line.
    */
    func isPointOnUnderOrAbove(x: Double, y: Double) -> Int {
        let value = self.a * x + self.b * y + self.c
        if (abs(value) < 1e-12) {
            return 0
        } else if ((value < 0 && self.b > 0) || (value > 0 && self.b < 0)) {
            return -1
        } else {
            return 1
        }
    }
}
