//
//  ChooseSavedPathViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 10/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class represents the screen for choosing any of saved path.
 */
class ChooseSavedPathViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    typealias ChoosePathDelegate = GoToLexiconDelegate & GoBackDelegate
    /// The view model with all important actions for selecting the saved path
    private let chooseSavedPathViewModel: ChooseSavedPathViewModel
    /// The array of all paths.
    private var allPaths: [Path] = []
    /// The table view in which the saved paths for choosing are shown.
    private var pathTableView: UITableView!
    /// The flow delegate for going to a different screen (back to main screen or to the main screen of the lexicon part of the application).
    var flowDelegate: ChoosePathDelegate?
    
    /**
     - Parameters:
        - chooseSavedPathViewModel: The view model with all important actions for selecting the saved path
    */
    init(chooseSavedPathViewModel: ChooseSavedPathViewModel){
        self.chooseSavedPathViewModel = chooseSavedPathViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.chooseSavedPathViewModel.getAllPaths.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function ensures binding this view controller with important view model action for getting the list of all paths for choosing.
    */
    override func setupBindingsWithViewModelActions() {
        self.chooseSavedPathViewModel.getAllPaths.values.producer.startWithValues { (allPaths) in
            self.allPaths = allPaths
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.screenBodyBackgroundColor.color

        // counting and setting the correct top offset
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let totalOffset = navigationBarHeight + statusBarHeight
        
        // adding a vertical menu
        let verticalMenu = VerticalMenu(width: 70, topOffset: totalOffset, parentView: self.view)
        
        let goToLexiconItem = VerticalMenuItem(actionString: "goToLexicon", actionText: L10n.goToLexicon, usedBackgroundColor: Colors.goToGuideOrLexiconButtonBackgroundColor.color)
        goToLexiconItem.addTarget(self, action: #selector(goToLexiconItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(goToLexiconItem, height: 120, last: true)
        
        // adding a view for the title on the screen
        let titleHeader = TitleHeader(title: L10n.guideTitle, menuInTheParentView: verticalMenu, parentView: self.view)
        
        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        self.pathTableView = UITableView(frame: CGRect(x: 0, y: 180, width: displayWidth, height: displayHeight))
        self.pathTableView.register(UITableViewCell.self, forCellReuseIdentifier: "pathCell")
        self.pathTableView.delegate = self
        self.pathTableView.dataSource = self
        self.view.addSubview(self.pathTableView)
    }

    
    /**
     This function ensures choosing the actual path after selecting a cell from the table.
     - Parameters:
        - tableView: The table view with the list of all saved paths
        - indexPath: The object represeting index (section and row number) of the cell which was selected.
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chooseSavedPathViewModel.chooseSavedPath(path: self.allPaths[indexPath.row])
        self.flowDelegate?.goBack(in: self)
    }
    
    
    /**
     This function returns the number of rows in the table. There is only one section so this function returns the count of allPaths independently on the number of the section.
     - Parameters:
        - tableView: The table view with all saved paths.
        - section: The number of the section.
     - Returns: The number of rows in the given section. There is only one section so it returns the number of saved paths.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allPaths.count
    }
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
     - tableView: The object representing the table view with the list of all saved paths.
     - indexPath: The object representing the index of the created cell
     
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.pathTableView.dequeueReusableCell(withIdentifier: "pathCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.allPaths[indexPath.row].title
        return cell
    }
    
    /**
     This function ensures going to the main screen of the lexicon part of the application after the tapping the item from the vertical menu.
     - Parameters:
        - sender: The item which has set this method as a target and was tapped.
    */
    @objc func goToLexiconItemTapped(_ sender: VerticalMenuItem) {
        flowDelegate?.goToLexicon(in: self)
    }
}
