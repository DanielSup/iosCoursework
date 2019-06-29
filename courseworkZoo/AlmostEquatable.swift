//
//  AlmostEquatable.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 29/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

precedencegroup AlmostEqualPrecedence{
    associativity: left
    higherThan: ComparisonPrecedence
}

infix operator =+-=: AlmostEqualPrecedence
infix operator !=+-=: AlmostEqualPrecedence

protocol AlmostEquatable{
    static func =+-=(lhs: Self, rhs: Self) -> Bool
}

extension AlmostEquatable {
    static func !=+-=(lhs: Self, rhs: Self) -> Bool {
        return !(lhs =+-= rhs)
    }
}
