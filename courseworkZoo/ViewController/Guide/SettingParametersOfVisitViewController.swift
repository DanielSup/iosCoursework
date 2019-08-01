//
//  SettingParametersOfVisitViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 12/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit

/**
 This class represents the screen for setting the parameters of the visit of the ZOO (walk speed and time spent at one animal).
 */
class SettingParametersOfVisitViewController: BaseViewController {
    /// The walk speed during the visit of the ZOO.
    private var walkSpeed: Float = 3.0
    /// The time spent at any one animal during the visit of the ZOO.
    private var timeSpentAtOneAnimal: Float = 3.0
    /// The view model with important actions for getting and setting the parameters of the visit of the ZOO.
    private var settingParametersOfVisitViewModel: SettingParametersOfVisitViewModel
    /// The text field for setting the walk speed
    private var walkSpeedField: UITextField!
    /// The text field for setting the time spent at one animal
    private var timeSpentAtOneAnimalField: UITextField!
    
    var flowDelegate: GoBackDelegate?
    
    
    /**
     - Parameters:
        - settingsParametersOfVisitViewModel: The view model with important actions for getting and setting the parameters of the visit of the ZOO.
    */
    init(settingParametersOfVisitViewModel: SettingParametersOfVisitViewModel){
        self.settingParametersOfVisitViewModel = settingParametersOfVisitViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.settingParametersOfVisitViewModel.getWalkSpeed.apply().start()
        self.settingParametersOfVisitViewModel.getTimeSpentAtOneAnimal.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settingParametersOfVisitViewModel = SettingParametersOfVisitViewModel(dependencies: AppDependency.shared)
        super.init(coder: aDecoder)
        self.setupBindingsWithViewModelActions()
        self.settingParametersOfVisitViewModel.getWalkSpeed.apply().start()
        self.settingParametersOfVisitViewModel.getTimeSpentAtOneAnimal.apply().start()
    }
    
    
    /**
     This function binds the view controller with important actions for getting the parameters of the visit of the ZOO of the view model.
     */
    override func setupBindingsWithViewModelActions() {
        self.settingParametersOfVisitViewModel.getWalkSpeed.values.producer.startWithValues{
            (walkSpeed) in
            self.walkSpeed = walkSpeed
        }
        
        self.settingParametersOfVisitViewModel.getTimeSpentAtOneAnimal.values.producer.startWithValues{
            (timeSpentAtOneAnimal) in
            self.timeSpentAtOneAnimal = timeSpentAtOneAnimal
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
        
        let goToLexiconItem = UIVerticalMenuItem(actionString: "goToLexicon", usedBackgroundColor: Colors.goToGuideOrLexiconButtonBackgroundColor.color)
        verticalMenu.addItem(goToLexiconItem, height: 120, last: false)
        
        // adding a view for the title on the screen
        let titleHeader = UITitleHeader(title: "guideTitle", menuInTheParentView: verticalMenu, parentView: self.view)
        
        let setParametersHelpLabel = UILabel()
        setParametersHelpLabel.text = NSLocalizedString("setParametersByOwnJudgment", comment: "")
        setParametersHelpLabel.numberOfLines = 0
        setParametersHelpLabel.lineBreakMode = .byWordWrapping
        setParametersHelpLabel.preferredMaxLayoutWidth = self.view.bounds.width - 20
        setParametersHelpLabel.sizeToFit()
        self.view.addSubview(setParametersHelpLabel)
        setParametersHelpLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(titleHeader.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
        }
        
        
        let walkSpeedFieldLabel = UILabel()
        walkSpeedFieldLabel.text = NSLocalizedString("walkSpeed", comment: "")
        walkSpeedFieldLabel.numberOfLines = 0
        walkSpeedFieldLabel.lineBreakMode = .byWordWrapping
        walkSpeedFieldLabel.preferredMaxLayoutWidth = self.view.bounds.width - 50
        walkSpeedFieldLabel.sizeToFit()
        self.view.addSubview(walkSpeedFieldLabel)
        walkSpeedFieldLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(setParametersHelpLabel.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(40)
        }
        
        let walkSpeedField = UITextField()
        walkSpeedField.text = String(self.walkSpeed)
        walkSpeedField.textColor = UIColor.black
        walkSpeedField.borderStyle = .roundedRect
        self.view.addSubview(walkSpeedField)
        walkSpeedField.snp.makeConstraints{ (make) in
            make.top.equalTo(walkSpeedFieldLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.width.equalToSuperview().offset(-150)
            make.height.equalTo(30)
        }
        self.walkSpeedField = walkSpeedField
        
        let walkSpeedFieldUnitLabel = UILabel()
        walkSpeedFieldUnitLabel.text = "km/h"
        walkSpeedFieldUnitLabel.textAlignment = .right
        self.view.addSubview(walkSpeedFieldUnitLabel)
        walkSpeedFieldUnitLabel.snp.makeConstraints{ (make) in
            make.centerY.equalTo(walkSpeedField.snp.centerY)
            make.left.equalTo(walkSpeedField.snp.right)
            make.width.equalTo(70)
        }
        
        
        let timeSpentAtOneAnimalFieldLabel = UILabel()
        timeSpentAtOneAnimalFieldLabel.text = NSLocalizedString("timeSpentAtOneAnimal", comment: "")
        timeSpentAtOneAnimalFieldLabel.numberOfLines = 0
        timeSpentAtOneAnimalFieldLabel.lineBreakMode = .byWordWrapping
        timeSpentAtOneAnimalFieldLabel.preferredMaxLayoutWidth = self.view.bounds.width - 50
        timeSpentAtOneAnimalFieldLabel.sizeToFit()
        self.view.addSubview(timeSpentAtOneAnimalFieldLabel)
        timeSpentAtOneAnimalFieldLabel.snp.makeConstraints { (make) in
            make.top.equalTo(walkSpeedField.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(40)
        }
        
        let timeSpentAtOneAnimalField = UITextField()
        timeSpentAtOneAnimalField.text = String(self.timeSpentAtOneAnimal)
        timeSpentAtOneAnimalField.textColor = UIColor.black
        timeSpentAtOneAnimalField.borderStyle = .roundedRect
        self.view.addSubview(timeSpentAtOneAnimalField)
        timeSpentAtOneAnimalField.snp.makeConstraints{ (make) in
            make.top.equalTo(timeSpentAtOneAnimalFieldLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.width.equalToSuperview().offset(-150)
            make.height.equalTo(30)
        }
        self.timeSpentAtOneAnimalField = timeSpentAtOneAnimalField
        
        let timeSpentAtOneAnimalFieldUnitLabel = UILabel()
        timeSpentAtOneAnimalFieldUnitLabel.text = "min"
        timeSpentAtOneAnimalFieldUnitLabel.textAlignment = .right
        self.view.addSubview(timeSpentAtOneAnimalFieldUnitLabel)
        timeSpentAtOneAnimalFieldUnitLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeSpentAtOneAnimalField.snp.centerY)
            make.left.equalTo(timeSpentAtOneAnimalField.snp.right)
            make.width.equalTo(70)
        }
        
        
        let setParametersButton = UIButton()
        setParametersButton.setTitle(NSLocalizedString("setParameters", comment: ""), for: .normal)
        setParametersButton.setTitleColor(UIColor.white, for: .normal)
        setParametersButton.backgroundColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1)
        setParametersButton.layer.cornerRadius = 5
        setParametersButton.layer.borderWidth = 1
        setParametersButton.layer.borderColor = UIColor.black.cgColor
        setParametersButton.addTarget(self, action: #selector(setParametersButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(setParametersButton)
        setParametersButton.snp.makeConstraints{ (make) in
            make.top.equalTo(timeSpentAtOneAnimalField.snp.bottom).offset(25)
            make.width.equalToSuperview().offset(-140)
            make.left.equalToSuperview().offset(100)
        }
    }
    
    /**
     This function ensures the setting the parameters of the visit of the ZOO to the values from the text fields after the tapping the submit button. The walk speed is the value from the first text field and the time spent at one animal is the value from the second text field.
     - Parameters:
        - sender: The button with this method as a target which was tapped.
     */
    @objc func setParametersButtonTapped(_ sender: UIButton){
        let walkSpeedFieldValue: Float = (self.walkSpeedField.text! as NSString).floatValue
        let timeSpentAtOneAnimalFieldValue: Float = (self.timeSpentAtOneAnimalField.text! as NSString).floatValue
        self.settingParametersOfVisitViewModel.setParameters(walkSpeed: walkSpeedFieldValue, timeSpentAtOneAnimal: timeSpentAtOneAnimalFieldValue)
        flowDelegate?.goBack(in: self)
    }
}
