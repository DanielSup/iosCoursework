//
//  ClassViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 18/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for the screen with the list of classes.
*/
class ClassViewController: BaseLexiconViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model for getting the list of classes in which animals can belong.
    private var classViewModel: ClassViewModel
    /// The array of loaded classes.
    private var classes: [Class] = []
    /// The table view where classes are shown
    private var classTableView: UITableView!
    
    /**
     - Parameters:
        - classViewModel: The view model for getting the list of classes in which can animals belong.
    */
    init(classViewModel: ClassViewModel){
        self.classViewModel = classViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.classViewModel.getClassesAction.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function binds the view controller with the action of the view model for getting the list of classes.
    */
    override func setupBindingsWithViewModelActions() {
        self.classViewModel.getClassesAction.values.producer.startWithValues{ (classes) in
            self.classes = classes
        }
    }
    
    override func viewDidLoad() {
        let textForSubtitle = NSLocalizedString("classList", comment: "")
        super.setTextForSubtitle(textForSubtitle)

        super.viewDidLoad()
        
        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let subtitleHeight = super.subtitleLabel.bounds.size.height
        
        self.classTableView = UITableView(frame: CGRect(x: super.verticalMenuWidth, y: barHeight + 180 + subtitleHeight, width: displayWidth - super.verticalMenuWidth, height: displayHeight - barHeight - subtitleHeight - 180))
        self.classTableView.register(UITableViewCell.self, forCellReuseIdentifier: "classCell")
        self.classTableView.dataSource = self
        self.classTableView.delegate = self
        self.view.addSubview(self.classTableView)
        
    }

    
    /**
     This function ensures going to the screen with the list of orders in the selected class.
     - Parameters:
        - tableView: The table view with classes.
        - indexPath: The object representing the index of the selected cell with class (section and number).
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.flowDelegate?.goToOrders(in: self, of: self.classes[indexPath.row])
    }
    
    
    /**
    This function returns the number of all classes where animals can belong.
     - Parameters:
        - tableView: The table view with classes.
        - section: The index of the section (there is only one section)
     - Returns: The number of all classes where animals can belong.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classes.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     - Parameters:
         - tableView: The object representing the table view with the list of classes.
         - indexPath: The object representing the index of the created cell.
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.classTableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.classes[indexPath.row].title
        return cell
    }
    
    
}
