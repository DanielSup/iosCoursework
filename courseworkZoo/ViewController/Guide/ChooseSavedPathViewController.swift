//
//  ChooseSavedPathViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 10/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represents the screen for choosing any of saved path.
 */
class ChooseSavedPathViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    typealias ChoosePathDelegate = GoToLexiconDelegate & GoBackDelegate
    /// The view model with all important actions for selecting the saved path
    private let chooseSavedPathViewModel: ChooseSavedPathViewModel
    /// The array of all paths.
    private var allPaths: [Path] = []
    /// The boolean representing whether the voice for machine-reading is on or off.
    private var isVoiceOn: Bool = true
    /// The boolean representing whether the guide says other information and instructions.
    private var isInformationFromGuideSaid = true
    /// The flow delegate for going to a different screen (back to main screen or to the main screen of the lexicon part of the application).
    var flowDelegate: ChoosePathDelegate?
    /// The table view in which the saved paths for choosing are shown.
    private var pathTableView: UITableView!
    
    
    /**
     - Parameters:
        - chooseSavedPathViewModel: The view model with all important actions for selecting the saved path
    */
    init(chooseSavedPathViewModel: ChooseSavedPathViewModel){
        self.chooseSavedPathViewModel = chooseSavedPathViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.chooseSavedPathViewModel.getAllPaths.apply().start()
        self.chooseSavedPathViewModel.isVoiceOn.apply().start()
        self.chooseSavedPathViewModel.isInformationFromGuideSaid.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function ensures binding this view controller with important view model action for getting the list of all paths for choosing.
    */
    override func setupBindingsWithViewModelActions() {
        self.chooseSavedPathViewModel.getAllPaths.values.producer.startWithValues { (allPaths) in
            self.allPaths = allPaths
        }
        
        self.chooseSavedPathViewModel.isVoiceOn.values.producer.startWithValues { (isVoiceOn) in
            self.isVoiceOn = isVoiceOn
        }
        
        self.chooseSavedPathViewModel.isInformationFromGuideSaid.values.producer.startWithValues { (isInformationFromGuideSaid) in
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
        
        let goBackButton = UIButton()
        goBackButton.setTitle(L10n.goBackToMainScreen, for: .normal)
        goBackButton.backgroundColor = Colors.goBackButtonColor.color
        goBackButton.addTarget(self, action: #selector(goBackButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(goBackButton)
        goBackButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let goBackButtonHeight: CGFloat = goBackButton.bounds.size.height + 25

        self.pathTableView = UITableView(frame: CGRect(x: 0, y: 180, width: displayWidth, height: displayHeight - goBackButtonHeight - barHeight - 180))
        self.pathTableView.register(PathWithActionsCell.self, forCellReuseIdentifier: "pathCell")
        self.pathTableView.delegate = self
        self.pathTableView.dataSource = self
        self.view.addSubview(self.pathTableView)
    }

    
    
    /**
     This function returns the number of rows in the table. There is only one section so this function returns the count of allPaths independently on the number of the section.
     - Parameters:
        - tableView: The table view with all saved paths.
        - section: The number of the section.
     - Returns: The number of rows in the given section. There is only one section so it returns the number of saved paths.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allPaths.count
    }
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
     - tableView: The object representing the table view with the list of all saved paths.
     - indexPath: The object representing the index of the created cell
     
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.pathTableView.dequeueReusableCell(withIdentifier: "pathCell", for: indexPath as IndexPath) as! PathWithActionsCell
        cell.selectButton.path = self.allPaths[indexPath.row]
        cell.selectButton.addTarget(self, action: #selector(selectButtonTapped(_:)), for: .touchUpInside)
        if (indexPath.row == 0) {
            /// Removing the remove button from the cell because the first path with all animals is preset.
            cell.removeButton.removeFromSuperview()
            cell.selectButton.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-5)
            }
        } else {
            cell.removeButton.path = self.allPaths[indexPath.row]
            cell.removeButton.addTarget(self, action: #selector(removeButtonTapped(_:)), for: .touchUpInside)
        }
        cell.pathTitleLabel.text = self.allPaths[indexPath.row].title
        return cell
    }
    
    /**
     This function ensures going to the main screen of the lexicon part of the application after the tapping the item from the vertical menu.
     - Parameters:
        - sender: The item which has set this method as a target and was tapped.
    */
    @objc func goToLexiconItemTapped(_ sender: VerticalMenuItem) {
        flowDelegate?.goToLexicon(in: self)
    }
    
    
    /**
     This function ensures going back to the main screen of the application (main screen of the guide part) after tapping the button.
     - Parameters:
        - sender: The button which was tapped and has set this method as a target.
    */
    @objc func goBackButtonTapped(_ sender: UIButton) {
        flowDelegate?.goBack(in: self)
    }
    
    /**
     This function shows the dialog that the path was selected and ensures selecting the path after tapping the button.
     - Parameters:
        - sender: The button for selecting the path which was tapped and has set this function as a target.
    */
    
    @objc func selectButtonTapped(_ sender: ButtonWithPathProperty) {
        let path = sender.path as! Path
        self.chooseSavedPathViewModel.chooseSavedPath(path: path)
        
        let textForShowingAndMachineReading = L10n.chooseSavedPathSpeech + " " + path.title
        
        let displayInformationPopoverVC = DisplayInformationPopoverViewController(text: textForShowingAndMachineReading)
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
        
        self.chooseSavedPathViewModel.stopSpeaking()
        
        self.chooseSavedPathViewModel.setCallbacksOfSpeechService(startCallback: {
        }, finishCallback: {
            displayInformationPopoverVC.view.removeFromSuperview()
            self.flowDelegate?.goBack(in: self)
        })
        
        self.chooseSavedPathViewModel.sayText(text: textForShowingAndMachineReading)
    }
    
    
    /**
     This function ensures removing the selected path after tapping the button at the path.
     - Parameters:
        - sender: The button for removing the path which was tapped and has set this method as a target.
    */
    @objc func removeButtonTapped(_ sender: ButtonWithPathProperty) {
        let path = sender.path as! Path
        self.chooseSavedPathViewModel.removePath(path: path)
        self.chooseSavedPathViewModel.getAllPaths.apply().start()
        self.pathTableView.reloadData()
    }
}
