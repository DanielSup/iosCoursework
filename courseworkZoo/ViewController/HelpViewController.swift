//
//  HelpViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 27/08/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit

/**
 This class is a view controller for the help screen.
*/
class HelpViewController: BaseViewController {
    /// The delegate for going back to the previous screen.
    var flowDelegate: GoBackDelegate?
    /// The array of all paragraphs in the help for the whole application.
    private let paragraphs = [L10n.helpParagraph1,
    L10n.helpParagraph2,
    L10n.helpParagraph3,
    L10n.helpParagraph4,
    L10n.helpParagraph5,
    L10n.helpParagraph6,
    L10n.helpParagraph7,
    L10n.helpParagraph8,
    L10n.helpParagraph9,
    L10n.helpParagraph10,
    L10n.helpParagraph11,
    L10n.helpParagraph12,
    L10n.helpParagraph13,
    L10n.helpParagraph14,
    L10n.helpParagraph15,
    L10n.helpParagraph16,
    L10n.helpParagraph17,
    L10n.helpParagraph18,
    L10n.helpParagraph19,
    L10n.helpParagraph20,
    L10n.helpParagraph21,
    L10n.helpParagraph21,
    L10n.helpParagraph22,
    L10n.helpParagraph23,
    L10n.helpParagraph24,
    L10n.helpParagraph25,
    L10n.helpParagraph26,
    L10n.helpParagraph27,
    L10n.helpParagraph28,
    L10n.helpParagraph29,
    L10n.helpParagraph30,
    L10n.helpParagraph31,
    L10n.helpParagraph32,
    L10n.helpParagraph33,
    L10n.helpParagraph34,
    L10n.helpParagraph35,
    L10n.helpParagraph36,
    L10n.helpParagraph37,
    L10n.helpParagraph38]
    
    /// The scroll view for scrolling the main screen with map and information about any enough close animal
    private let scrollView: UIScrollView = UIScrollView()
    /// The view inside the scroll view with map and information about any enough close animal
    private let contentView: UIView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScrollView()
        self.view.backgroundColor = Colors.screenBodyBackgroundColor.color
        self.contentView.backgroundColor = Colors.screenBodyBackgroundColor.color

        // adding a vertical menu
        let verticalMenu = VerticalMenu(width: 70, topOffset: 0, parentView: self.contentView)
        
        let goBackItem = VerticalMenuItem(actionString: "goBack", actionText: L10n.goBack, usedBackgroundColor: Colors.goToGuideOrLexiconButtonBackgroundColor.color)
        goBackItem.addTarget(self, action: #selector(goBackItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(goBackItem, height: 120, last: true)
        
        // adding a view for the title on the screen
        let titleHeader = TitleHeader(title: L10n.help, menuInTheParentView: verticalMenu, parentView: self.contentView)
        
        
        var lastParagraphLabel: UILabel!
        
        for paragraph in paragraphs {
            let paragraphLabel = UILabel()
            paragraphLabel.text = paragraph
            paragraphLabel.numberOfLines = 0
            paragraphLabel.lineBreakMode = .byWordWrapping
            paragraphLabel.preferredMaxLayoutWidth = self.view.bounds.width - 70
            paragraphLabel.sizeToFit()
            self.contentView.addSubview(paragraphLabel)
            paragraphLabel.snp.makeConstraints { (make) in
                if (lastParagraphLabel != nil) {
                    make.top.equalTo(lastParagraphLabel.snp.bottom).offset(10)
                } else {
                    make.top.equalTo(goBackItem.snp.bottom)
                }
                make.left.equalToSuperview().offset(30)
            }
            
            lastParagraphLabel = paragraphLabel
        }
        
        lastParagraphLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
        }
        
    }

    
    /**
     This function ensures setting up the scroll view for elements with informaiton about the animal. This function sets up the scroll view and the content view which is added to the scroll view.
     */
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // adding scroll view to main view and content view to the scroll view
        view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        //adding constraints to scroll view
        scrollView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        //adding constraints to content view
        contentView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    // MARK - Actions
    
    /**
     This function ensures going back to the previous screen after tapping the item.
     - Parameters:
        - sender: The link to the previous screen which was tapped and has set this function as a target.
    */
    @objc func goBackItemTapped(_ sender: VerticalMenuItem) {
        flowDelegate?.goBack(in: self)
    }
    
}
