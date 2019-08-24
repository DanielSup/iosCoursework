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
    typealias SelectInformationDelegate = GoToLexiconDelegate & GoBackDelegate
    /// The view model with action for getting the actual setting the information which are machine-read.
    private var selectInformationViewModel: SelectInformationViewModel
    /// The actual setting of machine-read information.
    private var actualSetting: [SaidInfo: Bool] = [:]
    /// The boolean representing whether the voice for machine-reading is on or off.
    private var isVoiceOn: Bool = true
    /// The boolean representing whether the guide says other information and instructions.
    private var isInformationFromGuideSaid = true
    /// The flow delegate for going to the main screen of the lexicon part of the application.
    var flowDelegate: SelectInformationDelegate?
    
    init(selectInformationViewModel: SelectInformationViewModel){
        self.selectInformationViewModel = selectInformationViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.selectInformationViewModel.getInformationSetting.apply().start()
        self.selectInformationViewModel.isVoiceOn.apply().start()
        self.selectInformationViewModel.isInformationFromGuideSaid.apply().start()
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
        
        self.selectInformationViewModel.isVoiceOn.values.producer.startWithValues { (isVoiceOn) in
            self.isVoiceOn = isVoiceOn
        }
        
        self.selectInformationViewModel.isInformationFromGuideSaid.values.producer.startWithValues { (isInformationFromGuideSaid) in
            self.isInformationFromGuideSaid = isInformationFromGuideSaid
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
        let verticalMenu = VerticalMenu(width: 70, topOffset: totalOffset, parentView: self.view)
        
        let goToLexiconItem = VerticalMenuItem(actionString: "goToLexicon", actionText: L10n.goToLexicon, usedBackgroundColor: Colors.goToGuideOrLexiconButtonBackgroundColor.color)
        goToLexiconItem.addTarget(self, action: #selector(goToLexiconItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(goToLexiconItem, height: 120, last: true)
        
        // adding a view for the title on the screen
        let titleHeader = TitleHeader(title: L10n.guideTitle, menuInTheParentView: verticalMenu, parentView: self.view)
        
        var index: Int = 0
        
        var lastInformationSwitch: UISwitch!
        
        for information in SaidInfo.values{
            let informationLabel = UILabel()
            informationLabel.text = information.title
            informationLabel.font = UIFont.systemFont(ofSize: 12)
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
            
            lastInformationSwitch = informationSwitch
            
            index += 1
        }
        
        let saveButton = UIButton()
        saveButton.setTitle(L10n.saveSettings, for: .normal)
        saveButton.backgroundColor = Colors.saveButtonColor.color
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(lastInformationSwitch.snp.bottom).offset(10)
            make.right.equalTo(lastInformationSwitch.snp.right)
            make.width.equalToSuperview().offset(-50)
        }
        
        let goBackButton = UIButton()
        goBackButton.setTitle(L10n.goBackToMainScreen, for: .normal)
        goBackButton.backgroundColor = Colors.goBackButtonColor.color
        goBackButton.layer.cornerRadius = 5
        goBackButton.layer.borderWidth = 1
        goBackButton.layer.borderColor = UIColor.black.cgColor
        goBackButton.addTarget(self, action: #selector(goBackButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(goBackButton)
        goBackButton.snp.makeConstraints { (make) in
            make.top.equalTo(saveButton.snp.bottom).offset(10)
            make.right.equalTo(saveButton.snp.right)
            make.width.equalToSuperview().offset(-50)
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
    }
    
    
    /**
     This function ensures going to the lexicon part of the application from the actual screen after tapping the item from the vertical menu.
     - Parameters:
        - sender: The item from the vertical menu which is tapped.
    */
    @objc func goToLexiconItemTapped(_ sender: VerticalMenuItem) {
        flowDelegate?.goToLexicon(in: self)
    }

    
    /**
     This function ensures saving the setting of the machine-read information and going back to the main screen after tapping the save button.
     - Parameters:
        - sender: The save button which was tapped and has set this method as a target.
    */
    @objc func saveButtonTapped(_ sender: UIButton) {
        self.selectInformationViewModel.setInformationSetting(self.actualSetting)
        
        let displayInformationPopoverVC = DisplayInformationPopoverViewController(text: L10n.saveSettingsSpeech)
        self.addChild(displayInformationPopoverVC)
        displayInformationPopoverVC.view.frame = self.view.frame
        self.view.addSubview(displayInformationPopoverVC.view)
        displayInformationPopoverVC.didMove(toParent: self)
        
        if (!self.isVoiceOn || !self.isInformationFromGuideSaid) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                displayInformationPopoverVC.view.removeFromSuperview()
                self.flowDelegate?.goBack(in: self)
            })
            return
        }
        
        self.selectInformationViewModel.stopSpeaking()
        
        self.selectInformationViewModel.setCallbacksOfSpeechService(startCallback: {
        }, finishCallback: {
            self.flowDelegate?.goBack(in: self)
        })
        
        self.selectInformationViewModel.sayText(text: L10n.saveSettingsSpeech)
    }
    
    
    /**
     This function ensures going back to the main screen without saving the actual setting of machine-read information after tapping the button.
     - Parameters:
        - The button for going to the main screen which was tapped and has set this method as a target.
    */
    @objc func goBackButtonTapped(_ sender: UIButton) {
        flowDelegate?.goBack(in: self)
    }
}
