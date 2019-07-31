//
//  UIVerticalMenuItem.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 08/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit

/**
 This class represents an item of the vertical menu. The item is represented by a button.
 */
class UIVerticalMenuItem: UIButton{
    /// The string representing the action of the item represented by a button.
    private var actionString: String
    /// The used background color of the item represented by a button
    private var usedBackgroundColor: UIColor
    /// The used icon on the item
    private var icon: UIImageView = UIImageView()
    /// The used label with action string on the item
    private var actionLabel: UILabel = UILabel()
    /// A boolean representing whether the label with a string representing an action was added (actionLabel was added or not)
    private var actionLabelAdded = false
    
    
    /**
     In this constructor there are set the parameters - actionString and usedBackgroundColor
     - Parameters:
        - actionString: The string representing the action of the item. It also sets the string in the label in this item.
        - usedBackgroundColor: The background color.
    */
    init(actionString: String, usedBackgroundColor: UIColor){
        self.actionString = actionString
        self.usedBackgroundColor = usedBackgroundColor
        super.init(frame: .zero)
        // setting properties of this menu item (background color and border)
        self.backgroundColor = usedBackgroundColor
        self.layer.cornerRadius = 1
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.actionString = ""
        self.usedBackgroundColor = UIColor.black
        super.init(coder: aDecoder)
    }

    
    /**
     This function ensures adding an icon representing the given action to the menu item represented by a button.
    */
    func addIcon(){
        if (self.actionLabelAdded){
            self.icon = UIImageView()
            self.icon.image = UIImage(named: self.actionString)
            self.icon.contentMode = .scaleToFill
            self.addSubview(self.icon)
            self.icon.snp.makeConstraints{ (make) in
                make.top.equalTo(self.actionLabel.snp.bottom).offset(2)
                make.width.equalTo(43)
                make.height.equalTo(48)
                make.centerX.equalToSuperview()
            }
        }
    }
    
    
    /**
     This function ensures adding a text label with a string representing the given action to the menu item represented by a button.
    */
    func addActionLabel(){
        self.actionLabel = UILabel()
        self.actionLabel.textColor = .black
        self.actionLabel.text = NSLocalizedString(self.actionString.replacingOccurrences(of: "Selected", with: ""), comment: "")
        self.actionLabel.textAlignment = .center
        
        if (self.usedBackgroundColor == Colors.goToGuideOrLexiconButtonBackgroundColor.color){
            self.actionLabel.font = self.actionLabel.font.withSize(12)
        } else {
            self.actionLabel.font = self.actionLabel.font.withSize(8)
        }
        
        self.actionLabel.numberOfLines = 0
        self.actionLabel.lineBreakMode = .byWordWrapping
        self.actionLabel.preferredMaxLayoutWidth = 54
        self.actionLabel.sizeToFit()
        self.addSubview(self.actionLabel)
        self.actionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(4)
        }
        
        self.actionLabelAdded = true
    
    }
    
    
    /**
     This function ensures changing the action of the item.
     - Parameters:
        - actionString: The string representing the new action of this item.
    */
    func changeActionString(actionString: String){
        self.actionString = actionString
        self.actionLabel.removeFromSuperview()
        self.icon.removeFromSuperview()
        self.addActionLabel()
        self.addIcon()
    }
    
}
