//
//  PavilionsViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for the screen with the list of localities (especially pavilions) in the ZOO.
*/
class PavilionsViewController: BaseLexiconViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model with the important action for getting the list of localities in the ZOO.
    private let pavilionsViewModel: PavilionsViewModel
    /// The table view for showing the list of localities in the ZOO.
    private var pavilionsTableView: UITableView!
    /// The list of localities in the ZOO.
    private var pavilions: [Locality] = []
    
    /**
     - Parameters:
        - pavilionsViewModel: The view model with the important action for getting the list of localities in the ZOO.
    */
    init(pavilionsViewModel: PavilionsViewModel){
        self.pavilionsViewModel = pavilionsViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.pavilionsViewModel.getLocalities.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
    This function binds the view model with the view model action for getting the list of localities in th e ZOO.
     */
    override func setupBindingsWithViewModelActions() {
        self.pavilionsViewModel.getLocalities.values.producer.startWithValues{ (pavilions) in
            self.pavilions = pavilions
        }
    }
    
    override func viewDidLoad() {
        let textForSubtitle = L10n.pavilions
        super.setTextForSubtitle(textForSubtitle)
        
        super.viewDidLoad()
        
        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let subtitleHeight = super.subtitleLabel.bounds.size.height
        
        self.pavilionsTableView = UITableView(frame: CGRect(x: super.verticalMenuWidth, y: barHeight + 180 + subtitleHeight, width: displayWidth - super.verticalMenuWidth, height: displayHeight - barHeight - subtitleHeight - 180))
        self.pavilionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "pavilionCell")
        self.pavilionsTableView.dataSource = self
        self.pavilionsTableView.delegate = self
        self.view.addSubview(self.pavilionsTableView)
    }
    
    
    /**
     This function ensures taking the user on the screen with the list of animals in the selected locality.
     - Parameters:
        - tableView: The table view with the localities.
        - indexPath: The object representing which cell (locality) the user was selected.
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flowDelegate?.goToAnimalsInPavilion(in: self, pavilion: self.pavilions[indexPath.row])
    }
    
    
    /**
     - Parameters:
        - tableView: The object representing the table view with the list of localities
        - section: The number of section (there is only one section)
     - Returns: The number of created rows = number of all localities in the ZOO.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pavilions.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
        - tableView: The object representing the table view with the list of localities (especially pavilions)
        - indexPath: The object representing the index of the created cell
     
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.pavilionsTableView.dequeueReusableCell(withIdentifier: "pavilionCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.pavilions[indexPath.row].title
        return cell
    }
}
