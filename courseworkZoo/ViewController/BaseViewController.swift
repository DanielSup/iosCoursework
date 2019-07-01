//
//  BaseViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 26/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represents a view controller. This class is good for checking when instances of a view controller are created and when they are destroyed.
 */
class BaseViewController: UIViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil)
        NSLog("Created ViewController \(self)")
    }
    
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function registers all important actions of the view model.
    */
    func registerViewModelActions(){
    }
    
    deinit{
        NSLog("Removing ViewController \(self)")
    }
}

