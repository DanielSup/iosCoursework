//
//  AnimalListViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

protocol GoBackDelegate: class{
    func goBackTapped(in viewController: BaseViewController)
}

protocol GoToAnimalListDelegate: class{
    func goToAnimalListTapped(in viewController: BaseViewController)
    func goForSelectionOfLocality(in viewController: BaseViewController)
    func goToSettings(in viewController: BaseViewController)
}

protocol GoToAnimalDetailDelegate: class{
    func goToAnimalDetail(in viewController: BaseViewController, to animal: Animal)
}

class AnimalListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        var animalsInResult: [Animal] = []
        guard let text = searchController.searchBar.text else { return }
        let capitalizedText = text.capitalized
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
        self.animalTableView.reloadData()
    }
    
    
    private var animalListViewModel: AnimalListViewModelling
    weak var flowDelegate: GoBackDelegate?
    weak var animalDetailFlowDelegate: GoToAnimalDetailDelegate?
    private var animalTableView: UITableView!
    var animalList:[Animal] = []
    
    func loadAnimals(){
        self.animalListViewModel.getAllAnimalsAction.values.producer.startWithValues{
            (animals) in
            self.animalList = animals
        }
        self.animalListViewModel.getAllAnimalsAction.apply().start()
        
    }
    
    init(viewModel: AnimalListViewModelling){
        self.animalListViewModel = viewModel
        super.init()
        self.loadAnimals()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.animalListViewModel = AnimalListViewModel(dependencies: AppDependency.shared)
        super.init()
        self.loadAnimals()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        self.animalTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        self.animalTableView.register(UITableViewCell.self, forCellReuseIdentifier: "animalCell")
        self.animalTableView.dataSource = self
        self.animalTableView.delegate = self
        self.view.addSubview(self.animalTableView)
        
        self.view.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.animalDetailFlowDelegate?.goToAnimalDetail(in: self, to: self.animalList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.animalTableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.animalList[indexPath.row].title
        return cell
    }
    
    @objc
    func goBackTapped(_ sender: UIButton){
        flowDelegate?.goBackTapped(in: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
