//
//  BiotopesViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for the screen with the list of biotopes in which animals can live.
*/
class BiotopesViewController: BaseLexiconViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model with the list of biotopes as an array (only function, not action).
    private var biotopesViewModel: BiotopesViewModel
    /// The table view for the biotopes.
    private var biotopesTableView: UITableView!
    /// The list of biotopes.
    private var biotopes: [Biotope]
    
    /**
     - Parameters:
        - biotopesViewModel: The view model with the list of biotpes as an array (only function).
    */
    init(biotopesViewModel: BiotopesViewModel){
        self.biotopesViewModel = biotopesViewModel
        self.biotopes = biotopesViewModel.getBiotopes()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let textForSubtitle = NSLocalizedString("biotopes", comment: "")
        super.setTextForSubtitle(textForSubtitle)
        
        super.viewDidLoad()

        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let subtitleHeight = self.subtitleLabel.bounds.size.height

        self.biotopesTableView = UITableView(frame: CGRect(x: super.verticalMenuWidth, y: barHeight + 180 + subtitleHeight, width: displayWidth - super.verticalMenuWidth, height: displayHeight - barHeight - subtitleHeight - 180))
        self.biotopesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "biotopeCell")
        self.biotopesTableView.dataSource = self
        self.biotopesTableView.delegate = self
        self.view.addSubview(self.biotopesTableView)
        
    }
    
    
    /**
     This function ensures going to the screen with the list of animals in the selected biotope.
     - Parameters:
        - tableView: The table view with the list of biotopes
        - indexPath: The object representing the index of the selected row (section and number).
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flowDelegate?.goToAnimalsInBiotope(in: self, biotope: self.biotopes[indexPath.row])
    }
    
    /**
     This function returns the number of all biotopes in which animals can live.
     - Parameters:
        - tableView: The table view with the list of biotopes
        - section: The number of the section (there is only one section).
     - Returns: The number of all biotopes.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.biotopes.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
        - tableView: The object representing the table view with the list of biotopes.
     -   indexPath: The object representing the index of the created cell
     
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.biotopesTableView.dequeueReusableCell(withIdentifier: "biotopeCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.biotopes[indexPath.row].title
        return cell
    }
    
}
