//
//  AnimalsInBiotopeViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 21/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for the screen with the list of animals living in the given biotope.
*/
class AnimalsInBiotopeViewController: BaseLexiconViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model with the important action for getting the list of animals living in the given biotope
    private let animalsInBiotopeViewModel: AnimalsInBiotopeViewModel
    /// The table view for showing animals living in the given biotope.
    private var animalsInBiotopeTableView: UITableView!
    /// The list of animals living in the given biotope.
    private var animalsInBiotope: [Animal] = []
    
    /**
     - Parameters:
        - animalsInBiotopeViewModel: The view model with the important action for getting the list of animals in the given biotope.
    */
    init(animalsInBiotopeViewModel: AnimalsInBiotopeViewModel){
        self.animalsInBiotopeViewModel = animalsInBiotopeViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.animalsInBiotopeViewModel.getAnimalsInBiotopeAction.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function binds the view controller with the action for getting the list of animals living in the given biotope from the view model.
    */
    override func setupBindingsWithViewModelActions() {
        self.animalsInBiotopeViewModel.getAnimalsInBiotopeAction.values.producer.startWithValues {
            (animalsInBiotope) in
            self.animalsInBiotope = animalsInBiotope
        }
    }
    
    override func viewDidLoad() {
        let textForSubtitle = NSLocalizedString("animalList", comment: "") + " " + self.animalsInBiotopeViewModel.getLocativeOfBiotopeTitleWithPreposition()
        super.setTextForSubtitle(textForSubtitle)
        
        super.viewDidLoad()
        
        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let subtitleHeight = self.subtitleLabel.bounds.size.height
        
        self.animalsInBiotopeTableView = UITableView(frame: CGRect(x: super.verticalMenuWidth, y: barHeight + 180 + subtitleHeight, width: displayWidth - super.verticalMenuWidth, height: displayHeight - barHeight - subtitleHeight - 180))
        self.animalsInBiotopeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "animalInBiotopeCell")
        self.animalsInBiotopeTableView.dataSource = self
        self.animalsInBiotopeTableView.delegate = self
        self.view.addSubview(self.animalsInBiotopeTableView)
        
    }
    
    
    /**
     This method ensures going to a screen with detailed information about the selected animal.
     
     - Parameters:
        - tableView: The object representing the whole table with the list of animals living in the given biotope
        - indexPath: The object representing which cell the user was selected.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.flowDelegate?.goToAnimalDetail(in: self, to: self.animalsInBiotope[indexPath.row])
    }
    
    
    /**
     This function returns the number of animals in the selected biotope.
     - Parameters:
        - tableView: The object representing the table view with the list of animals living in the given biotope.
        - section: The number of section (there is only one section)
     
     - Returns: The number of created rows = number of animals living in the given biotope.
     
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animalsInBiotope.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
        - tableView: The object representing the table view with the list of animals living in the given biotope.
        - indexPath: The object representing the index of the created cell
     
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.animalsInBiotopeTableView.dequeueReusableCell(withIdentifier: "animalInBiotopeCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.animalsInBiotope[indexPath.row].title
        return cell
    }

}
