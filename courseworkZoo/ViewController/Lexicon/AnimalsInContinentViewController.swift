//
//  AnimalsInContinentViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 30/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for the screen with the list of animals living in the given continent or animals which don't live anywhere in nature if the option was selected.
 */
class AnimalsInContinentViewController: BaseLexiconViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model with the important action for getting the list of animals living in the given continent (or list of animals which don't live anywhere in nature)
    private let animalsInContinentViewModel: AnimalsInContinentViewModel
    /// The list of animals living in the given continent (or list of animals which don't live anywhere in nature).
    private var animalsInContinent: [Animal] = []
    /// The table view for showing the list of animals living in the given continent (or list of animals which don't live anywhere in nature).
    private var animalsInContinentTableView: UITableView!
    
    
    /**
     - Parameters:
        - animalsInContinentViewModel: The view model with the important action for getting the list of animals living in the given continent (or list of animals which don't live anywhere in nature).
    */
    init(animalsInContinentViewModel: AnimalsInContinentViewModel) {
        self.animalsInContinentViewModel = animalsInContinentViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.animalsInContinentViewModel.getAnimalsInContinent.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     This function binds the view controller with the action of the view model for getting the list of animals living in the given continent (or animals which don't live anywhere in nature).
    */
    override func setupBindingsWithViewModelActions() {
        self.animalsInContinentViewModel.getAnimalsInContinent.values.producer.startWithValues {
            (animalsInContinent) in
            self.animalsInContinent = animalsInContinent
        }
    }
    
    override func viewDidLoad() {
        let textForSubtitle = L10n.animalList + " " + self.animalsInContinentViewModel.getLocativeOfContinentWithPreposition()
        super.setTextForSubtitle(textForSubtitle)
        
        super.viewDidLoad()

        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let subtitleHeight = self.subtitleLabel.bounds.size.height
        
        self.animalsInContinentTableView = UITableView(frame: CGRect(x: super.verticalMenuWidth, y: barHeight + 180 + subtitleHeight, width: displayWidth - super.verticalMenuWidth, height: displayHeight - barHeight - subtitleHeight - 180))
        self.animalsInContinentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "animalInContinentCell")
        self.animalsInContinentTableView.dataSource = self
        self.animalsInContinentTableView.delegate = self
        self.view.addSubview(self.animalsInContinentTableView)
    }
    
    
    
    /**
     This method ensures going to a screen with detailed information about the selected animal.
     
     - Parameters:
        - tableView: The object representing the whole table with animals living in the given continent (or list of animals which don't live anywhere in nature).
        - indexPath: The object representing which cell the user was selected.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.flowDelegate?.goToAnimalDetail(in: self, to: self.animalsInContinent[indexPath.row])
    }
    
    
    /**
     This function returns the number of animals in the selected continent.
     - Parameters:
        - tableView: The object representing the table view with the list of animals
        - section: The number of section (there is only one section)
     
     - Returns: The number of created rows = number of animals in the result of searching or number of all animals - in the start
     
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animalsInContinent.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
     - tableView: The object representing the table view with the list of animals living in the given continent.
     - indexPath: The object representing the index of the created cell
     
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.animalsInContinentTableView.dequeueReusableCell(withIdentifier: "animalInContinentCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.animalsInContinent[indexPath.row].title
        return cell
    }
    
}
