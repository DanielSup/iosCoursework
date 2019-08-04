//
//  AnimalsInPavilionViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 22/07/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit

/**
 This class is a view controller for the screen with the list of animals in the choosed locality.
*/
class AnimalsInPavilionViewController: BaseLexiconViewController, UITableViewDelegate, UITableViewDataSource {
    /// The view model with the important action for getting the list of animals in the choosed locality.
    private let animalsInPavilionViewModel: AnimalsInPavilionViewModel
    /// The table view for showing the list of animals in the choosed pavilion.
    private var animalsInPavilionTableView: UITableView!
    /// The array of animals in the choosed pavilion.
    private var animalsInPavilion: [Animal] = []
    
    /**
     - Parameters:
        - animalsInPavilionViewModel: The view model with the important action for getting the list of animals in the choosed locality.
    */
    init(animalsInPavilionViewModel: AnimalsInPavilionViewModel){
        self.animalsInPavilionViewModel = animalsInPavilionViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
        self.animalsInPavilionViewModel.getAnimalsInLocality.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     This function binds the view controller with the important action for getting the list of animals in the choosed locality from the view model.
    */
    override func setupBindingsWithViewModelActions() {
        self.animalsInPavilionViewModel.getAnimalsInLocality.values.producer.startWithValues{
            (animalsInPavilion) in
            self.animalsInPavilion = animalsInPavilion
        }
    }
    
    override func viewDidLoad() {
        
        self.setAttributedStringForSubtitle(self.getAttributedStringForLocality())
        super.viewDidLoad()
        
        // getting sizes of display and the height of the top bar with search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let subtitleHeight = super.subtitleLabel.bounds.size.height
        
        self.animalsInPavilionTableView = UITableView(frame: CGRect(x: super.verticalMenuWidth, y: barHeight + 180 + subtitleHeight, width: displayWidth - super.verticalMenuWidth, height: displayHeight - barHeight - subtitleHeight - 180))
        self.animalsInPavilionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "animalInPavilionCell")
        self.animalsInPavilionTableView.delegate = self
        self.animalsInPavilionTableView.dataSource = self
        self.view.addSubview(self.animalsInPavilionTableView)
    }
    
    /**
     This function returns an attributed string for the subtitle with the name of the selected locality (pavilion).
     - Returns: Attributed strings containing the name of the selected locality.
     */
    func getAttributedStringForLocality() -> NSAttributedString{
        let normalSubtitleText = L10n.animalsInLocality + " "
        let attributesOfNormalSubtitleText = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]
        let attributedSubtitle = NSMutableAttributedString(string: normalSubtitleText, attributes: attributesOfNormalSubtitleText)
        
        
        let titleOfLocality = "\"" + self.animalsInPavilionViewModel.getLocalityTitle() + "\""
        let attributesOfTitleOfLocality = [NSAttributedString.Key.font : UIFont(name: "SnellRoundhand-Bold", size: 30)]
        let attributedStringOfTitleOfLocality = NSMutableAttributedString(string: titleOfLocality, attributes: attributesOfTitleOfLocality)
        attributedSubtitle.append(attributedStringOfTitleOfLocality)
        
        return attributedSubtitle
    }
    
    /**
     This function ensures taking the user on the screen about the choosed animal.
     - Parameters:
        - tableView: The table view with the animals in the choosed pavilion.
        - indexPath: The object representing which cell (animal) the user was choosed.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flowDelegate?.goToAnimalDetail(in: self, to: self.animalsInPavilion[indexPath.row])
    }
    
    
    /**
     - Parameters:
        - tableView: The object representing the table view with the list of animals in the choosed locality.
        - section: The number of section (there is only one section)
     - Returns: The number of created rows = number of animals in the choosed locality.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animalsInPavilion.count
    }
    
    
    /**
     This method ensures creating of the cell for the given index path by reusing a cell prototype.
     
     - Parameters:
        - tableView: The object representing the table view with the list of animals in the choosed locality
        - indexPath: The object representing the index of the created cell
     
     - Returns: The object representing the cell for the given concrete index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.animalsInPavilionTableView.dequeueReusableCell(withIdentifier: "animalInPavilionCell", for: indexPath as IndexPath)
        cell.textLabel!.text = self.animalsInPavilion[indexPath.row].title
        return cell
    }
    
}
