//
//  BaseViewModel.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 15/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController{
    init(){
        super.init(nibName: nil, bundle: nil)
        NSLog("Created ViewController \(self)")
        
    }
    deinit{
        NSLog("Removing ViewController \(self)")
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseViewModel {
    static let closeDistance = 0.000045
    static var visited:[Coords] = []
    static func existsPosition(latitude: Double, longitude: Double) -> Bool{
        for position in visited{
            if(position.latitude == latitude && position.longitude == longitude){
                return true
            }
        }
        return false
    }
    init(){
        NSLog("Created ViewModel: \(self)")
    }
    deinit{
        NSLog("Removing ViewModel: \(self)")
    }
}
