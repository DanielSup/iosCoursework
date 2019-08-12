//
//  LegendView.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 08/08/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

/**
 This class represents the view for the legend under the map view in the main screen.
*/
class LegendView: UIView {
    /// The parent view of the whole legend with items (content view of the scroll view in the main screen).
    private var parentView: UIView
    /// The map view which the legend belongs under.
    private var zooPlanMapView: MKMapView
    /// The
    private var lastItem: LegendViewItem!
    
    
    /**
     - Parameters:
        - parentView: The parent view of the whole legend with items (content view of the scroll view in the main screen).
    */
    init(parentView: UIView, zooPlanMapView: MKMapView) {
        self.parentView = parentView
        self.zooPlanMapView = zooPlanMapView
        super.init(frame: parentView.frame)
        
        self.backgroundColor = .white
        self.parentView.addSubview(self)
        self.snp.makeConstraints{ make in
            make.top.equalTo(self.zooPlanMapView.snp.bottom)
            make.left.equalTo(self.zooPlanMapView.snp.left)
            make.width.equalTo(self.zooPlanMapView.snp.width)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     This function adds the given item to the legend and saves the added item as the last added item.
     - Parameters:
        - item: The item of the legend which is added.
        - last: The boolean representing whether the item is last in the legend or not.
    */
    func addItem(_ item: LegendViewItem, last: Bool) {
        self.addSubview(item)
        item.snp.makeConstraints { make in
            if (lastItem == nil) {
                make.top.equalToSuperview()
            } else {
                make.top.equalTo(self.lastItem.snp.bottom)
            }
            
            make.left.equalToSuperview()
            
            if (last) {
                make.bottom.equalToSuperview()
            }
            make.width.equalToSuperview()
        }
        item.addImageAndText()
        
        self.lastItem = item
    }
}
