//
//  DisplayInformationPopoverViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 20/08/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for the popover for showing the information for user (why the user action was successful)
*/
class DisplayInformationPopoverViewController: BaseViewController {
    /// The string representing the success of the user action.
    private let text: String
    
    
    /**
     - Parameters:
        - text: The string representing the success of the user action.
    */
    init(text: String) {
        self.text = text
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.backgroundOfPopoverColor.color
        // Adding the view of the popover
        let popoverView = UIView()
        popoverView.backgroundColor = Colors.screenBodyBackgroundColor.color
        self.view.addSubview(popoverView)
        popoverView.snp.makeConstraints{ (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(20)
        }
        
        let textLabel = UILabel()
        textLabel.text = self.text
        textLabel.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.1, alpha: 1.0)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.preferredMaxLayoutWidth = self.view.bounds.width / 2.0 - 40.0
        textLabel.sizeToFit()
        popoverView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
        }
        
    }
    

}
