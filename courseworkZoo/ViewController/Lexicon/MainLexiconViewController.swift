//
//  MainLexiconViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 08/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/**
 This class represents the main screen of the lexicon part of this application.
 */
class MainLexiconViewController: BaseLexiconViewController, UITableViewDelegate, UITableViewDataSource{
    /// The view model with important actions for this view controller
    private let mainLexiconViewModel: MainLexiconViewModel
    /// The table view in which the animals are shown
    private var animalTableView: UITableView!
    /// The list of all animals
    private var animalList: [Animal] = []

    /**
     - Parameters:
     - mainLexiconViewModel: The view model with actions important for correct functionality of this screen (getting list of animals)
    */
    init(mainLexiconViewModel: MainLexiconViewModel){
        self.mainLexiconViewModel = mainLexiconViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.mainLexiconViewModel.getAllAnimalsAction.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function binds the view controller with the action for getting all animals from the view model.
    */
    override func setupBindingsWithViewModelActions() {
        self.mainLexiconViewModel.getAllAnimalsAction.values.producer.startWithValues{
            (animalList) in
            self.animalList = animalList
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        // creating and setting the table view for rendering the list of all animals from the table view of the superclass
        self.animalTableView = UITableView(frame: CGRect(x: super.verticalMenuWidth, y: barHeight + 180, width: displayWidth - super.verticalMenuWidth, height: displayHeight - barHeight - 180))
        self.animalTableView.register(UITableViewCell.self, forCellReuseIdentifier: "animalCell")
        self.animalTableView.dataSource = self
        self.animalTableView.delegate = self
        self.view.addSubview(self.animalTableView)
        
    }
    
    
    /**
     This method ensures going to a screen with detailed information about the selected animal.
     
     - Parameters:
     - tableView: The object representing the whole table with animals in the result of searching or list of all animals
     - indexPath: The object representing which cell the user was selected.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.flowDelegate?.goToAnimalDetail(in: self, to: self.animalList[indexPath.row])
    }
    
    
    /**
     - Parameters:
     - tableView: The object representing the table view with the list of animals
     - section: The number of section (there is only one section)
     
     - Returns: The number of created rows = number of animals in the result of searching or number of all animals - in the start
     
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animalList.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
     - tableView: The object representing the table view with the list of animals.
     - indexPath: The object representing the index of the created cell
     
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.animalTableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.animalList[indexPath.row].title
        return cell
    }

}
