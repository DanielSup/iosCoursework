//
//  UITitleHeader.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 08/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit

/**
 This class represents a component with a title which is placed on the top of the screen.
 */
class TitleHeader: UIView {
    /// The title in the header
    private let title: String
    /// The menu in the parentView
    private let menuInTheParentView: VerticalMenu
    /// The parent view of the header
    private let parentView: UIView
    /// The label with the title inside the header
    private var titleLabel: UILabel = UILabel()
    
    
    /**
     - Parameters:
        - title: The title which is shown in the header at the top of the screen.
        - menuWidth: The width of the vertical menu.
        - parentView: The view of the screen where the header with title is added.
    */
    init(title: String, menuInTheParentView: VerticalMenu, parentView: UIView){
        self.title = title
        self.menuInTheParentView = menuInTheParentView
        self.parentView = parentView
        super.init(frame: parentView.frame)
        
        self.backgroundColor = Colors.titleBackgroundColor.color
        /// adding this view with title to the parent view
        self.parentView.addSubview(self)
        self.snp.makeConstraints{ (make) in
            make.top.equalTo(self.menuInTheParentView.snp.top)
            make.left.equalTo(self.menuInTheParentView.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(self.menuInTheParentView.getItemAt(index: 0)?.snp.height ?? 0)
        }
        self.addTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function ensures adding the title to this view.
    */
    private func addTitle(){
        self.titleLabel = UILabel()
        self.titleLabel.text = self.title
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.preferredMaxLayoutWidth = self.parentView.bounds.size.width - CGFloat(self.menuInTheParentView.getWidth()) / 2.0
        self.titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(5)
            make.center.equalToSuperview()
        }
    }
}
