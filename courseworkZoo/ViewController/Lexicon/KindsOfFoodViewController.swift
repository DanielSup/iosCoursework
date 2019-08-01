//
//  KindsOfFoodViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 31/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for the screen with the list of kinds of food which animals can eat.
*/
class KindsOfFoodViewController: BaseLexiconViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model for getting the list of kinds of food
    private var kindsOfFoodViewModel: KindsOfFoodViewModel
    /// The array of kinds of food
    private var kindsOfFood: [Food] = []
    /// The table view for showing the list of kinds of food
    private var kindsOfFoodTableView: UITableView!
    
    
    /**
     - Parameters:
        - kindsOfFoodViewModel: The view model for getting the list of kinds of food.
    */
    init(kindsOfFoodViewModel: KindsOfFoodViewModel) {
        self.kindsOfFoodViewModel = kindsOfFoodViewModel
        self.kindsOfFood = kindsOfFoodViewModel.getKindsOfFood()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        let textForSubtitle = NSLocalizedString("kindsOfFood", comment: "")
        super.setTextForSubtitle(textForSubtitle)
        
        super.viewDidLoad()

        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let subtitleHeight = self.subtitleLabel.bounds.size.height
        
        self.kindsOfFoodTableView = UITableView(frame: CGRect(x: super.verticalMenuWidth, y: barHeight + 180 + subtitleHeight, width: displayWidth - super.verticalMenuWidth, height: displayHeight - barHeight - subtitleHeight - 180))
        self.kindsOfFoodTableView.register(UITableViewCell.self, forCellReuseIdentifier: "kindOfFoodCell")
        self.kindsOfFoodTableView.dataSource = self
        self.kindsOfFoodTableView.delegate = self
        self.view.addSubview(self.kindsOfFoodTableView)
        
    }
    

    /**
     This function ensures going to the screen with the list of kinds of food which animals can eat.
     - Parameters:
        - tableView: The table view with the list of kinds of food
        - indexPath: The object representing the index of the selected row (section and number).
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flowDelegate?.goToAnimalsEatingKindOfFood(in: self, kindOfFood: self.kindsOfFood[indexPath.row])
    }
    
    /**
     This function returns the number of all kinds of food which animals can eat.
     - Parameters:
        - tableView: The table view with the list of kinds of food
        - section: The number of the section (there is only one section).
     - Returns: The number of all kinds of food which animals can eat.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.kindsOfFood.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
     - tableView: The object representing the table view with the list of kinds of food which animals can eat.
     -   indexPath: The object representing the index of the created cell
     ß
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.kindsOfFoodTableView.dequeueReusableCell(withIdentifier: "kindOfFoodCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.kindsOfFood[indexPath.row].title
        return cell
    }
}
