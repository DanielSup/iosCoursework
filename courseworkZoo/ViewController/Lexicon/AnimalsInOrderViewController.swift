//
//  AnimalsInOrderViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for the screen with the list of animals in the given order.
*/
class AnimalsInOrderViewController: BaseLexiconViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model with the important action for getting the list of animals in the given order.
    private let animalsInOrderViewModel: AnimalsInOrderViewModel
    /// The array of animals in the given order.
    private var animalsInOrder: [Animal] = []
    /// The table view with the animals in the given order.
    private var animalsInOrderTableView: UITableView!
    
    
    /**
     - Parameters:
        - animalsInOrderViewModel: The view model with the important action for getting the list of animals in the given order.
     */
    init(animalsInOrderViewModel: AnimalsInOrderViewModel) {
        self.animalsInOrderViewModel = animalsInOrderViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.animalsInOrderViewModel.getAnimalsInOrderAction.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
    This function binds the view controller with the action for getting the list of animals from the view model.
     */
    override func setupBindingsWithViewModelActions() {
        self.animalsInOrderViewModel.getAnimalsInOrderAction.values.producer.startWithValues { (animalsInOrder) in
            self.animalsInOrder = animalsInOrder
        }
    }
    
    override func viewDidLoad() {
        let textForSubtitle = NSLocalizedString("animalsInOrderList", comment: "") + " " + self.animalsInOrderViewModel.getOrderTitle()
        super.setTextForSubtitle(textForSubtitle)

        super.viewDidLoad()
        
        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let subtitleHeight = self.subtitleLabel.bounds.size.height
        
        self.animalsInOrderTableView = UITableView(frame: CGRect(x: super.verticalMenuWidth, y: barHeight + 180 + subtitleHeight, width: displayWidth - super.verticalMenuWidth, height: displayHeight - barHeight - subtitleHeight - 180))
        self.animalsInOrderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "animalInOrderCell")
        self.animalsInOrderTableView.dataSource = self
        self.animalsInOrderTableView.delegate = self
        self.view.addSubview(self.animalsInOrderTableView)
        
    }
    
    
    /**
     This method ensures going to a screen with detailed information about the selected animal.
     
     - Parameters:
     - tableView: The object representing the whole table with animals in the result of searching or list of all animals
     - indexPath: The object representing which cell the user was selected.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.flowDelegate?.goToAnimalDetail(in: self, to: self.animalsInOrder[indexPath.row])
    }
    
    
    /**
     - Parameters:
     - tableView: The object representing the table view with the list of animals
     - section: The number of section (there is only one section)
     
     - Returns: The number of created rows = number of animals in the result of searching or number of all animals - in the start
     
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animalsInOrder.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
     - tableView: The object representing the table view with the list of animals.
     - indexPath: The object representing the index of the created cell
     
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.animalsInOrderTableView.dequeueReusableCell(withIdentifier: "animalInOrderCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.animalsInOrder[indexPath.row].title
        return cell
    }

}
