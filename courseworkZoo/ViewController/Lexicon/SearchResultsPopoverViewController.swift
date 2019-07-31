//
//  SearchResultsPopoverViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 24/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for showing the list of results from the search bar in any screen in the lexicon part of the application.
*/
class SearchResultsPopoverViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    /// The array of screens in the result.
    private var results: [Screen]
    /// The table view with results of searching from the BaseLexiconViewController.
    private var tableView: UITableView!
    /// The width of the table for results
    var widthOfTable: CGFloat = 210
    /// The flow delegate for going to any screen after selecting any result from the list.
    var flowDelegate: LexiconDelegate?
    
    
    /**
     - Parameters:
        - results: The list of screens which will be in the result.
    */
    init(results: [Screen]){
        self.results = results
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    This function ensures changing the list of result. This method is called after changing the text in the text field in the search bar at the top of any screen in the lexicon part of the application. This method ensures the change of the result in the table view.
     - Parameters:
        - results: The list of results which will be saved here and shown in the table view.
     */
    func setResults(_ results: [Screen]){
        self.results = results
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: widthOfTable, height: 350))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
    }
    
    /**
     This function ensures taking the user to the correct screen. The user can select detail of any animal, list of animals in order, list of orders in a class, list of classes, list of biotopes, list of animals in a biotope, list of pavilions or list of animals in a pavilion.
     - Parameters:
        - tableView: The table view with the results of actual searching.
        - indexPath: The object representing the index of the selected screen (section and number in the section).
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let screen = self.results[indexPath.row]
        if (screen.animal != nil){
            flowDelegate?.goToAnimalDetail(in: self, to: screen.animal!)
        } else if (screen.biotope != nil) {
            flowDelegate?.goToAnimalsInBiotope(in: self, biotope: screen.biotope!)
        } else if (screen.classOrOrder != nil) {
            if (screen.classOrOrder!.type == "class") {
                flowDelegate?.goToOrders(in: self, of: screen.classOrOrder!)
            } else {
                flowDelegate?.goToAnimalsInOrder(in: self, order: screen.classOrOrder!)
            }
        } else if (screen.pavilion != nil) {
            flowDelegate?.goToAnimalsInPavilion(in: self, pavilion: screen.pavilion!)
        } else if (screen.title == NSLocalizedString("biotopes", comment: "")){
            flowDelegate?.goToBiotopes(in: self)
        } else if (screen.title == NSLocalizedString("classes", comment: "")){
            flowDelegate?.goToClasses(in: self)
        } else if (screen.title == NSLocalizedString("pavilions", comment: "")){
            flowDelegate?.goToPavilions(in: self)
        }
    }
    
    /**
     This function returns the number of screens in the result.
     - Parameters:
        - tableView: The table view with the list of screens in the result.
        - section: The index of the section (there is only one section).
     - Returns: The number of screens in the result.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     - Parameters:
        - tableView: The object representing the table view with the list of screens in the result.
        - indexPath: The object representing the index of the created cell
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.textLabel!.text = self.results[indexPath.row].title
        cell.textLabel!.font = UIFont.systemFont(ofSize: 10)
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = .byCharWrapping
        cell.textLabel!.preferredMaxLayoutWidth = 160
        cell.textLabel!.sizeToFit()
        return cell
    }

}
