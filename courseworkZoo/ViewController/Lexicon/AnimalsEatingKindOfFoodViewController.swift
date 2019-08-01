//
//  AnimalsEatingKindOfFoodViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 01/08/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for the screen with the list of animals eating the given kind of food.
*/
class AnimalsEatingKindOfFoodViewController: BaseLexiconViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model for getting the list of animals eating the kind of food.
    private var animalsEatingKindOfFoodViewModel: AnimalsEatingKindOfFoodViewModel
    /// The list of animals which eat the kind of food.
    private var animalsEatingKindOfFood: [Animal] = []
    /// The table view for showing the list of animals eating the kind of food.
    private var animalsEatingKindOfFoodTableView: UITableView!

    /**
     - Parameters:
        - animalsEatingKindOfFoodViewModel: The view model for getting the list of animals eating the kind of food.
    */
    init(animalsEatingKindOfFoodViewModel: AnimalsEatingKindOfFoodViewModel) {
        self.animalsEatingKindOfFoodViewModel = animalsEatingKindOfFoodViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.animalsEatingKindOfFoodViewModel.getAnimalsEatingKindOfFood.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function binds the view controller with the action of view model for getting the list of animals eating the given kind of food.
    */
    override func setupBindingsWithViewModelActions() {
    
        self.animalsEatingKindOfFoodViewModel.getAnimalsEatingKindOfFood.values.producer.startWithValues {
            (animalsEatingKindOfFood) in
            self.animalsEatingKindOfFood = animalsEatingKindOfFood
        }
    }
    
    override func viewDidLoad() {
        let textForSubtitle = NSLocalizedString("listOfAnimalsEating", comment: "") + " " + self.animalsEatingKindOfFoodViewModel.getInstrumentalOfTitleOfKindOfFood()
        super.setTextForSubtitle(textForSubtitle)
        
        super.viewDidLoad()

        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let subtitleHeight = self.subtitleLabel.bounds.size.height
        
        self.animalsEatingKindOfFoodTableView = UITableView(frame: CGRect(x: super.verticalMenuWidth, y: barHeight + 180 + subtitleHeight, width: displayWidth - super.verticalMenuWidth, height: displayHeight - barHeight - subtitleHeight - 180))
        self.animalsEatingKindOfFoodTableView.register(UITableViewCell.self, forCellReuseIdentifier: "animalEatingKindOfFoodCell")
        self.animalsEatingKindOfFoodTableView.dataSource = self
        self.animalsEatingKindOfFoodTableView.delegate = self
        self.view.addSubview(self.animalsEatingKindOfFoodTableView)
    }

    /**
     This method ensures going to a screen with detailed information about the selected animal.
     
     - Parameters:
     - tableView: The object representing the whole table with animals eating the given kind of food.
     - indexPath: The object representing which cell the user was selected.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.flowDelegate?.goToAnimalDetail(in: self, to: self.animalsEatingKindOfFood[indexPath.row])
    }
    
    
    /**
     This function returns the number of animals eating the given kind of food.
     - Parameters:
        - tableView: The object representing the table view with the list of animals
        - section: The number of section (there is only one section)
     
     - Returns: The number of created rows = number of animals eating the given kind of food
     
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animalsEatingKindOfFood.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
        - tableView: The object representing the table view with the list of animals eating the given kind of food.
        - indexPath: The object representing the index of the created cell
     
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.animalsEatingKindOfFoodTableView.dequeueReusableCell(withIdentifier: "animalEatingKindOfFoodCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.animalsEatingKindOfFood[indexPath.row].title
        return cell
    }
}
