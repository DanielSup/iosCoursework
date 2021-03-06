//
//  SavePathPopoverViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 11/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit

/**
 This class represents the popover for saving the actual path with the title from the text field.
 */
class SavePathPopoverViewController: BaseViewController {
    /// The view model for saving the actual path
    private let savePathViewModel: SavePathViewModel
    /// The boolean representing whether the voice for machine-reading is on or off.
    private var isVoiceOn: Bool = true
    /// The boolean representing whether the guide says other information and instructions.
    private var isInformationFromGuideSaid = true
    /// The text field for filling the title which the actual path will be saved with.
    var titleTextField: UITextField!
    
    /**
     - Parameters:
        - savePathViewModel: The view model for saving the actual path with the title from the text field.
    */
    init(savePathViewModel: SavePathViewModel){
        self.savePathViewModel = savePathViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.savePathViewModel.isVoiceOn.apply().start()
        self.savePathViewModel.isInformationFromGuideSaid.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     This function binds the view controller with the action of the view model for getting whether the voice for machine-reading is on or off and action for getting whether the guide can say other information and instructions.
    */
    override func setupBindingsWithViewModelActions() {
        self.savePathViewModel.isVoiceOn.values.producer.startWithValues { (isVoiceOn) in
            self.isVoiceOn = isVoiceOn
        }
        
        self.savePathViewModel.isInformationFromGuideSaid.values.producer.startWithValues { (isInformationFromGuideSaid) in
            self.isInformationFromGuideSaid = isInformationFromGuideSaid
        }
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
            make.height.equalToSuperview().dividedBy(2)
        }
        
        
        let titleTextField: UITextField = UITextField(frame: CGRect(x: 20, y: 70, width: self.view.bounds.size.width / 2.0 - 40, height: 30))
        titleTextField.borderStyle = .roundedRect
        popoverView.addSubview(titleTextField)
        self.titleTextField = titleTextField
        
        let titleTextFieldLabel = UILabel()
        titleTextFieldLabel.text = L10n.pathTitle
        titleTextFieldLabel.textColor = UIColor.black
        popoverView.addSubview(titleTextFieldLabel)
        titleTextFieldLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(titleTextField.snp.left)
            make.bottom.equalTo(titleTextField.snp.top)
        }
        
        let savePathButton: UIButton = UIButton()
        savePathButton.setTitle(L10n.savePath, for: .normal)
        savePathButton.setTitleColor(UIColor(red: 0, green: 128.0 / 255.0, blue: 1.0, alpha: 1.0), for: .normal)
        savePathButton.backgroundColor = UIColor.white
        savePathButton.layer.cornerRadius = 5
        savePathButton.layer.borderWidth = 1
        savePathButton.layer.borderColor = UIColor.black.cgColor
        savePathButton.addTarget(self, action: #selector(savePathButtonTapped(_:)), for: .touchUpInside)
        popoverView.addSubview(savePathButton)
        savePathButton.snp.makeConstraints{ (make) in
            make.top.equalTo(titleTextField.snp.bottom).offset(15)
            make.left.equalTo(titleTextField.snp.left)
            make.width.equalToSuperview().dividedBy(2).offset(-21)
        }
        
        let cancelButton: UIButton = UIButton()
        cancelButton.setTitle(L10n.cancel, for: .normal)
        cancelButton.setTitleColor(UIColor(red: 1.0, green: 0.25, blue: 0, alpha: 1.0), for: .normal)
        cancelButton.backgroundColor = UIColor.white
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        popoverView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints{ (make) in
            make.top.equalTo(titleTextField.snp.bottom).offset(15)
            make.left.equalTo(savePathButton.snp.right).offset(2)
            make.width.equalToSuperview().dividedBy(2).offset(-21)
        }
    }
    
    
    // MARK - Actions
    
    /**
     This function saves the actual unsaved path with the title from the text field after the tapping the savePathButton button. It also closes the popover.
     - Parameters:
     - sender: The button with this method as a target which was tapped.
     */
    @objc func savePathButtonTapped(_ sender: UIButton){
        
        let titleOfThePath = self.titleTextField.text!
        self.savePathViewModel.saveActualPath(with: titleOfThePath)
        
        let textForShowingAndMachineReading = L10n.savePathSpeech + " " + titleOfThePath

        let displayInformationPopoverVC = DisplayInformationPopoverViewController(text: textForShowingAndMachineReading)
        self.addChild(displayInformationPopoverVC)
        displayInformationPopoverVC.view.frame = self.view.frame
        self.view.addSubview(displayInformationPopoverVC.view)
        displayInformationPopoverVC.didMove(toParent: self)

        if (!self.isVoiceOn || !self.isInformationFromGuideSaid) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                displayInformationPopoverVC.view.removeFromSuperview()
                self.view.removeFromSuperview()
            })
            return
        }
        
        self.savePathViewModel.stopSpeaking()
        
        self.savePathViewModel.setCallbacksOfSpeechService(startCallback: {
        }, finishCallback: {
            displayInformationPopoverVC.view.removeFromSuperview()
            self.view.removeFromSuperview()
            
        })
        self.savePathViewModel.sayText(L10n.savePathSpeech + " " + titleOfThePath)
    }
    
    /**
     This function closes the popover after tapping the cancel buttonß.
     - Parameters:
        - sender: The button with this method as a target which was tapped.
     */
    @objc func cancelButtonTapped(_ sender: UIButton){
        self.view.removeFromSuperview()
    }
}
