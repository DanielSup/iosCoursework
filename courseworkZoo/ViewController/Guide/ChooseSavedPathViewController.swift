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
    // The view model with all important actions for selecting the saved path
    private let chooseSavedPathViewModel: ChooseSavedPathViewModel
    // The array of all paths.
    private var allPaths: [Path] = []
    // The table view in which the saved paths for choosing are shown.
    private var pathTableView: UITableView!
    
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
        let verticalMenu = UIVerticalMenu(width: 70, topOffset: totalOffset, parentView: self.view)
        
        let goToLexiconItem = UIVerticalMenuItem(actionString: "goToLexicon", usedBackgroundColor: Colors.goToGuideOrLexiconButtonBackgroundColor.color)
        verticalMenu.addItem(goToLexiconItem, height: 120, last: false)
        
        // adding a view for the title on the screen
        let titleHeader = UITitleHeader(title: "guideTitle", menuInTheParentView: verticalMenu, parentView: self.view)
        
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

    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chooseSavedPathViewModel.chooseSavedPath(path: self.allPaths[indexPath.row])
        self.flowDelegate?.goBack(in: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allPaths.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.pathTableView.dequeueReusableCell(withIdentifier: "pathCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.allPaths[indexPath.row].title
        return cell
    }
    
}
