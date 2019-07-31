//
//  ContinentsViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 30/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for the screen with the list of continents where animals could live including the option that there could be animals which don't live anywhere in nature.
*/
class ContinentsViewController: BaseLexiconViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model for getting the list of continents
    private var continentsViewModel: ContinentsViewModel
    /// The list of continents and the option that there could be animals which don't live anywhere in nature.
    private var continents: [Continent]
    /// The table view for showing the list of continents including the option that there could be animals which don't live anywhere in nature.
    private var continentsTableView: UITableView!
    
    
    /**
     - Parameters:
        - continentsViewModel: The view model for getting the list of continents.
     */
    init(continentsViewModel: ContinentsViewModel) {
        self.continentsViewModel = continentsViewModel
        self.continents = continentsViewModel.getContinents()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        let textForSubtitle = NSLocalizedString("continents", comment: "")
        super.setTextForSubtitle(textForSubtitle)
        
        super.viewDidLoad()

        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let subtitleHeight = self.subtitleLabel.bounds.size.height
        
        self.continentsTableView = UITableView(frame: CGRect(x: super.verticalMenuWidth, y: barHeight + 180 + subtitleHeight, width: displayWidth - super.verticalMenuWidth, height: displayHeight - barHeight - subtitleHeight - 180))
        self.continentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "continentCell")
        self.continentsTableView.dataSource = self
        self.continentsTableView.delegate = self
        self.view.addSubview(self.continentsTableView)
    }
    

    /**
     This function ensures going to the screen with the list of animals living in the selected continent or animals not living in nature if the option was selected.
     - Parameters:
     - tableView: The table view with the list of continents
     - indexPath: The object representing the index of the selected row (section and number).
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.flowDelegate?.goToAnimalsInContinent(in: self, continent: self.continents[indexPath.row])
    }
    
    /**
     This function returns the number of all continets in which animals can live including the option that there could be animals which don't live anywhere in nature.
     - Parameters:
     - tableView: The table view with the list of continent
     - section: The number of the section (there is only one section).
     - Returns: The number of all continents including the option that there could be animals which don't live anywhere in nature.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.continents.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
     - tableView: The object representing the table view with the list continents including the option that there could be animals which don't live anywhere in nature.
     -   indexPath: The object representing the index of the created cell
     
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.continentsTableView.dequeueReusableCell(withIdentifier: "continentCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.continents[indexPath.row].title
        return cell
    }
    
}
