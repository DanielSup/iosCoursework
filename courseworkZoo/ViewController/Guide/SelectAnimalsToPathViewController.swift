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
    /// The callback which is called when an animal is added to the actual path.
    var addAnimalCallback: (String) -> Void = {(animal: String) in}
    /// The callback which is called when an animal is removed from the actual path.
    var removeAnimalCallback: (String) -> Void = {(animal: String) in}
    /// The callback which is called when the popover with table view is closed.
    var closeCallback: () -> Void = {}
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
        self.view.backgroundColor = Colors.backgroundOfPopoverColor.color

        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        self.animalTableView = UITableView(frame: CGRect(x: 0, y: barHeight + 150, width: displayWidth - 145, height: displayHeight - barHeight - 180))
        self.animalTableView.register(AnimalWithActionCell.self, forCellReuseIdentifier: "animalCell")
        self.animalTableView.dataSource = self
        self.animalTableView.delegate = self
        self.view.addSubview(self.animalTableView)
        
        
        
        let removeAllAnimalsButton = UIButton()
        removeAllAnimalsButton.backgroundColor = UIColor(red: 0.4, green: 0.1, blue: 0.8, alpha: 1.0)
        removeAllAnimalsButton.setTitle(L10n.removeAllAnimalsFromPath, for: .normal)
        removeAllAnimalsButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        removeAllAnimalsButton.addTarget(self, action: #selector(removeAllAnimalsButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(removeAllAnimalsButton)
        removeAllAnimalsButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.animalTableView.snp.top)
            make.right.equalTo(self.animalTableView.snp.right)
            make.height.equalTo(32)
        }
        
        let addAllAnimalsButton = UIButton()
        addAllAnimalsButton.backgroundColor = UIColor(red: 0.1, green: 0.55, blue: 0.2, alpha: 1.0)
        addAllAnimalsButton.setTitle(L10n.addAllAnimalsToPath, for: .normal)
        addAllAnimalsButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        addAllAnimalsButton.addTarget(self, action: #selector(addAllAnimalsButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(addAllAnimalsButton)
        addAllAnimalsButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(removeAllAnimalsButton.snp.top)
            make.right.equalTo(self.animalTableView.snp.right)
            make.height.equalTo(32)
        }
        
        let closeButton = UIButton()
        closeButton.backgroundColor = UIColor(red: 0.8, green: 0.4, blue: 0.3, alpha: 1.0)
        closeButton.setTitle(L10n.closeAnimalsToPath, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(addAllAnimalsButton.snp.top)
            make.right.equalTo(self.animalTableView.snp.right)
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return self.animalsInPath.count
        }
        return self.animalsForSelecting.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AnimalWithActionCell = tableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath) as! AnimalWithActionCell
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
    @objc func actionButtonForAddingTapped(_ sender: ButtonWithAnimalProperty){
        self.selectAnimalsToPathViewModel.addAnimalToPath(animal: sender.animal!)
        self.selectAnimalsToPathViewModel.getAnimalsForSelecting.apply().start()
        self.selectAnimalsToPathViewModel.getAnimalsInPath.apply().start()
        self.addAnimalCallback(sender.animal!.title)
        self.animalTableView.reloadData()
    }
    
    
    /**
     This function removes the animal from the given table cell from the actual unsaved path after tapping the action button. It also refreshes the whole table view so the user could see what animals are added in the actual unsaved path.
     - Parameters:
        - sender: The button with this method as a target which was tapped.
     */
    @objc func actionButtonForRemovingTapped(_ sender: ButtonWithAnimalProperty){
        self.selectAnimalsToPathViewModel.removeAnimalFromPath(animal: sender.animal!)
        self.selectAnimalsToPathViewModel.getAnimalsForSelecting.apply().start()
        self.selectAnimalsToPathViewModel.getAnimalsInPath.apply().start()
        self.removeAnimalCallback(sender.animal!.title)
        self.animalTableView.reloadData()
    }
    
    /**
     This function ensures closing the table with the list of all animals for adding to the actual path or removing from the actual path and takes the user back to the main screen after tapping the close button.
     - Parameters:
        - sender: The button which was tapped and has set this method as a target.
    */
    @objc func closeButtonTapped(_ sender: UIButton) {
        self.view.removeFromSuperview()
        self.closeCallback()
    }
    
    /**
     This function ensures removing all animals from the actual unsaved path after tapping the button.
     - Parameters:
        - sender: The button which was tapped and has set this method as a target.
    */
    @objc func removeAllAnimalsButtonTapped(_ sender: UIButton) {
        self.selectAnimalsToPathViewModel.removeAllAnimalsFromPath()
        self.selectAnimalsToPathViewModel.getAnimalsForSelecting.apply().start()
        self.selectAnimalsToPathViewModel.getAnimalsInPath.apply().start()
        self.animalTableView.reloadData()
    }
    
    
    /**
     This function ensures adding all animals to the actual unsaved path after tapping the button.
     - Parameters:
        - sender: The button which was tapped and has set this method as a target.
     */
    @objc func addAllAnimalsButtonTapped(_ sender: UIButton) {
        self.selectAnimalsToPathViewModel.addAllAnimalsToPath()
        self.selectAnimalsToPathViewModel.getAnimalsForSelecting.apply().start()
        self.selectAnimalsToPathViewModel.getAnimalsInPath.apply().start()
        self.animalTableView.reloadData()
    }
}
