//
//  SelectAnimalsToPathViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 10/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
This class represents the screen for selecting animals to the actual path and removing animals from the actual path.
 */
class SelectAnimalsToPathViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model with important action for this view controller
    private let selectAnimalsToPathViewModel: SelectAnimalsToPathViewModel
    /// The delegate which ensure going to the lexicon part of the application.
    var flowDelegate: GoToLexiconDelegate?
    /// The array of animals which can be added to the actual path.
    private var animalsForSelecting: [Animal] = []
    /// The array of animals in the actual path.
    private var animalsInPath: [Animal] = []
    /// The table view for showing non selected and selected animals
    private var animalTableView: UITableView!
    
    /**
     - Parameters:
        - selectAnimalsToPathViewModel: The view model with actions with important actions for this view controller.
    */
    init(selectAnimalsToPathViewModel: SelectAnimalsToPathViewModel){
        self.selectAnimalsToPathViewModel = selectAnimalsToPathViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.selectAnimalsToPathViewModel.getAnimalsForSelecting.apply().start()
        self.selectAnimalsToPathViewModel.getAnimalsInPath.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    This function ensures binding the view controller with important actions of the view model.
     */
    override func setupBindingsWithViewModelActions() {
        self.selectAnimalsToPathViewModel.getAnimalsForSelecting.values.producer.startWithValues{ (animalsForSelecting) in
            self.animalsForSelecting = animalsForSelecting
        }
        
        self.selectAnimalsToPathViewModel.getAnimalsInPath.values.producer.startWithValues { (animalsInPath) in
            self.animalsInPath = animalsInPath
            print(self.animalsInPath.count)
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
        
        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        self.animalTableView = UITableView(frame: CGRect(x: 0, y: barHeight + 180, width: displayWidth, height: displayHeight - barHeight - 180))
        self.animalTableView.register(UIAnimalWithActionCell.self, forCellReuseIdentifier: "animalCell")
        self.animalTableView.dataSource = self
        self.animalTableView.delegate = self
        self.view.addSubview(self.animalTableView)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return self.animalsInPath.count
        }
        return self.animalsForSelecting.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UIAnimalWithActionCell = tableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath) as! UIAnimalWithActionCell
        if (indexPath.section == 0){
            cell.actionButton.animal = self.animalsInPath[indexPath.row]
            cell.animalTitleLabel.text = self.animalsInPath[indexPath.row].title
            cell.actionButton.removeTarget(self, action: #selector(actionButtonForAddingTapped(_:)), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(actionButtonForRemovingTapped(_:)), for: .touchUpInside)
            cell.actionButton.setTitle(L10n.removeFromPath, for: .normal)
        } else {
            cell.actionButton.animal = self.animalsForSelecting[indexPath.row]
            cell.animalTitleLabel.text = self.animalsForSelecting[indexPath.row].title
            cell.actionButton.removeTarget(self, action: #selector(actionButtonForRemovingTapped(_:)), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(actionButtonForAddingTapped(_:)), for: .touchUpInside)
            cell.actionButton.setTitle(L10n.addToPath, for: .normal)
        }
        return cell
    }
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return L10n.animalsInPath
        }
        return L10n.animalsForSelectionToPath
    }
    
    // MARK - Actions
    
    /**
     This function adds the animal from the given table cell to the actual unsaved path after the tapping the action button. It also refreshes the whole table view so the user could see what animals are added in the actual unsaved path.
     - Parameters:
        - sender: The button with this method as a target which was tapped.
     */
    @objc func actionButtonForAddingTapped(_ sender: UIButtonWithAnimalProperty){
        self.selectAnimalsToPathViewModel.addAnimalToPath(animal: sender.animal!)
        self.selectAnimalsToPathViewModel.getAnimalsForSelecting.apply().start()
        self.selectAnimalsToPathViewModel.getAnimalsInPath.apply().start()
        self.animalTableView.reloadData()
    }
    
    
    /**
     This function removes the animal from the given table cell from the actual unsaved path after tapping the action button. It also refreshes the whole table view so the user could see what animals are added in the actual unsaved path.
     - Parameters:
        - sender: The button with this method as a target which was tapped.
     */
    @objc func actionButtonForRemovingTapped(_ sender: UIButtonWithAnimalProperty){
        self.selectAnimalsToPathViewModel.removeAnimalFromPath(animal: sender.animal!)
        self.selectAnimalsToPathViewModel.getAnimalsForSelecting.apply().start()
        self.selectAnimalsToPathViewModel.getAnimalsInPath.apply().start()
        self.animalTableView.reloadData()
    }
    
    
    /**
    This function ensures going to the main screen of the lexicon part of the application after the tapping the item from the vertical menu.
     - Parameters:
        - sender: The item from the vertical menu which has set this method as a target and was tapped.
    */
    @objc func goToLexiconItemTapped(_ sender: UIVerticalMenuItem) {
        flowDelegate?.goToLexicon(in: self)
    }
}
