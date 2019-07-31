//
//  UIVerticalMenu.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 08/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit

class UIVerticalMenu: UIView {
    /// The list of already added items in the menu
    private var menuItems: [UIVerticalMenuItem] = []
    /// The width of the menu
    private var width: Float
    /// The top offset of the menu where it is placed
    private var topOffset: Float
    /// The parent view of the menu (there it is usually a view of the ViewController)
    private let parentView: UIView
    
    /**
     - Parameters:
        - width: The width of the menu
        - heightOffset: The top offset of the menu where it is placed
        - parentView: The parent view of the menu (there it is usually a view of the ViewController)
    */
    init(width: Float, topOffset: CGFloat, parentView: UIView){
        self.width = width
        self.parentView = parentView
        self.topOffset = Float(topOffset)
        super.init(frame: parentView.frame)
        // adding to the given parent view and setting constraints
        self.parentView.addSubview(self)
        self.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(self.topOffset)
            make.left.equalToSuperview()
            make.width.equalTo(self.width)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.width = 0
        self.topOffset = 0
        self.parentView = UIView()
        super.init(coder: aDecoder)
    }
    
    
    /**
     This function ensures adding an item to the menu. It also sets the bottom of this menu if the added item is marked as last.
     - Parameters:
        - item: The menu item which is added to this menu.
        - last: A boolean representing whether the added item will be last in the menu.
    */
    func addItem(_ item: UIVerticalMenuItem, height: CGFloat, last: Bool){
        self.addSubview(item)
            
        item.snp.makeConstraints{ (make) in
            if (self.menuItems.count == 0){
                make.top.equalToSuperview()
            } else {
                make.top.equalTo(self.menuItems.last!.snp.bottom)
            }
            make.left.equalToSuperview()
            make.height.equalTo(height)
            
            make.width.equalToSuperview()
            if(last == true){
                make.bottom.equalToSuperview()
            }
        }
        item.addActionLabel()
        item.addIcon()
        self.menuItems.append(item)
    }
    
    
    /**
     This function returns the item at the given numeric index.
     - Parameters:
        - index: The numeric index of the found item.
     - Returns: The item of this menu at the given numeric index.
    */
    func getItemAt(index: Int) -> UIVerticalMenuItem?{
        var actualIndex: Int = 0
        for menuItem in self.menuItems{
            if(actualIndex == index){
                return menuItem
            }
            actualIndex += 1
        }
        return nil
    }
    
    
    /**
     This function replaces the item of the menu at the given index with the new given item.
    */
    func replaceItemAtIndex(with item: UIVerticalMenuItem, index: Int){
        self.getItemAt(index: index)?.removeFromSuperview()
        
    }
    
    /**
     It returns the width of the menu.
     - Returns: The width of the menu.
    */
    func getWidth() -> Float{
        return self.width
    }
    
}
