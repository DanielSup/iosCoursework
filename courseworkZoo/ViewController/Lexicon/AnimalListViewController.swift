//
//  AnimalListViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit


/**
 This controller ensures showing the list of animals to the screen. Above the list of animals there is also a search bar for finding animals by title.
 */
class AnimalListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    /// The view model for getting the list of animals.
    private var animalListViewModel: AnimalListViewModel
    /// The delegate for going to the screen with the detailed information about an animal.
    weak var animalDetailFlowDelegate: GoToAnimalDetailDelegate?
    /// The table view with the animals according to the search or all animals (before any search).
    private var animalTableView: UITableView!
    /// list of animals to show in the table view, result of searching animals by title
    var animalList:[Animal] = []
    
    
    /**
     This is the constructor of this class. It ensures setting the view model and then loading the list of all animals before any search.
     
     - Parameters:
        - viewModel: The view model for getting the list of animals
     */
    init(animalListViewModel: AnimalListViewModel){
        self.animalListViewModel = animalListViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.animalListViewModel.getAllAnimalsAction.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.animalListViewModel = AnimalListViewModel(dependencies: AppDependency.shared)
        super.init()
        self.setupBindingsWithViewModelActions()
        self.animalListViewModel.getAllAnimalsAction.apply().start()
    }
    
    
    /**
     This function ensures binding the view controller with the action of the view model for getting all animals.
    */
    override func setupBindingsWithViewModelActions() {
        self.animalListViewModel.getAllAnimalsAction.values.producer.startWithValues{
            (animals) in
            self.animalList = animals
            print(String(self.animalList.count))
        }
    }
    
    
    /**
     This method ensures adding search bar and the list of animals to the screen.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        // creating and settings of the search bar above the list of animal
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        // creating and setting the table view for rendering the list of all animals
        self.animalTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        self.animalTableView.register(UITableViewCell.self, forCellReuseIdentifier: "animalCell")
        self.animalTableView.dataSource = self
        self.animalTableView.delegate = self
        self.view.addSubview(self.animalTableView)
    }
    
    
    /**
     This method is called every time when user changes the text in the search field. This method ensures getting the list of animals which contain the text from the search field in their title.
     
     - Parameters:
        - searchController: The object representing the search field
    */
    func updateSearchResults(for searchController: UISearchController) {
        var animalsInResult: [Animal] = []
        guard let text = searchController.searchBar.text else { return }
        let capitalizedText = text.capitalized
        // finding animals which have the text from the search field in the title
        self.animalListViewModel.getAllAnimalsAction.values.producer.startWithValues{
            (animalList) in
            for animal in animalList{
                if(animal.title.contains(text) || animal.title.contains(capitalizedText) || text == ""){
                    animalsInResult.append(animal)
                }
            }
        }
        self.animalListViewModel.getAllAnimalsAction.apply().start()
        animalList = animalsInResult
        // ensuring reloading data after finding the list of animal representing the result of search
        self.animalTableView.reloadData()
    }
    
    
    /**
     This method ensures going to a screen with detailed information about the selected animal.
     
     - Parameters:
        - tableView: The object representing the whole table with animals in the result of searching or list of all animals
        - indexPath: The object representing which cell the user was selected.
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.animalDetailFlowDelegate?.goToAnimalDetail(in: self, to: self.animalList[indexPath.row])
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
