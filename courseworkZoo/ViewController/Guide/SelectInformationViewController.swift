//
//  SelectInformationViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 14/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit

/**
 This class represents the screen for selecting information which are be machine-read.
*/
class SelectInformationViewController: BaseViewController {
    /// The view model with action for getting the actual setting the information which are machine-read.
    private var selectInformationViewModel: SelectInformationViewModel
    /// The actual setting of machine-read information.
    private var actualSetting: [SaidInfo: Bool] = [:]
    /// The flow delegate for going to the main screen of the lexicon part of the application.
    var flowDelegate: GoToLexiconDelegate?
    
    init(selectInformationViewModel: SelectInformationViewModel){
        self.selectInformationViewModel = selectInformationViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.selectInformationViewModel.getInformationSetting.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function ensures binding the view controller with the view model action for getting the actual setting of machine-read information.
    */
    override func setupBindingsWithViewModelActions() {
        self.selectInformationViewModel.getInformationSetting.values.producer.startWithValues{
            (actualSetting) in
            self.actualSetting = actualSetting
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.screenBodyBackgroundColor.color
        
        // counting and setting the correct top offset
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let totalOffset = navigationBarHeight + statusBarHeight
        
        // adding a vertical menu
        let verticalMenu = UIVerticalMenu(width: 70, topOffset: totalOffset, parentView: self.view)
        
        let goToLexiconItem = UIVerticalMenuItem(actionString: "goToLexicon", actionText: L10n.goToLexicon, usedBackgroundColor: Colors.goToGuideOrLexiconButtonBackgroundColor.color)
        goToLexiconItem.addTarget(self, action: #selector(goToLexiconItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(goToLexiconItem, height: 120, last: true)
        
        // adding a view for the title on the screen
        let titleHeader = UITitleHeader(title: L10n.guideTitle, menuInTheParentView: verticalMenu, parentView: self.view)
        
        var index: Int = 0
        
        for information in SaidInfo.values{
            let informationLabel = UILabel()
            informationLabel.text = information.title
            self.view.addSubview(informationLabel)
            informationLabel.snp.makeConstraints{ (make) in
                make.top.equalTo(titleHeader.snp.bottom).offset(index * 30 + 20)
                make.left.equalToSuperview().offset(20)
            }
            
            let informationSwitch = UISwitch()
            informationSwitch.isOn = self.actualSetting[information] ?? false
            informationSwitch.setOn(self.actualSetting[information] ?? false, animated: true)
            informationSwitch.tag = index
            informationSwitch.addTarget(self, action: #selector(informationSwitchStateChanged(_:)), for: .valueChanged)
            self.view.addSubview(informationSwitch)
            informationSwitch.snp.makeConstraints{ (make) in
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalTo(informationLabel.snp.centerY)
            }
            index += 1
        }
    }
    
    // MARK - Actions
    
    /**
     This function ensures the machine-reading (if the switch is newly on) or skipping the selected information (if the switch is newly off). The selected information is given by the tag of the switch whose value was changed.ti This function changes the setting machine-read information about a close animal after changing value of any switch.
     - Parameters:
        - sender: The switch whose value was changed
     */
    @objc func informationSwitchStateChanged(_ sender: UISwitch){
        let information = SaidInfo.values[sender.tag]
        self.actualSetting[information] = sender.isOn
        self.selectInformationViewModel.setInformationSetting(self.actualSetting)
    }
    
    
    /**
     This function ensures going to the lexicon part of the application from the actual screen after tapping the item from the vertical menu.
     - Parameters:
        - sender: The item from the vertical menu which is tapped.
    */
    @objc func goToLexiconItemTapped(_ sender: UIVerticalMenuItem) {
        flowDelegate?.goToLexicon(in: self)
    }

}
