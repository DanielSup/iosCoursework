//
//  AnimalDetailViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit

/**
 This class represents a screen with detailed information about an animal. This view controller is usually called from a list of animals.
 */
class AnimalDetailViewController: BaseLexiconViewController {
    /// Object representing the selected animal.
    private let animal: Animal
    /// The view model for getting information about the selected animal such as food, biotopes and continents
    private let animalDetailViewModel: AnimalDetailViewModel
    /// Array of continents in which the animal lives
    private var continents: [Continent] = []
    /// Array of biotopes in which the animal lives
    private var biotopes: [Biotope] = []
    /// Array of kinds of foods which the animal eats
    private var foods: [Food] = []
    /// The scroll view for scrolling the content about the animal on the screen
    private let scrollView: UIScrollView = UIScrollView()
    /// The view with all information about the animal and a picture of the animal
    private let contentView: UIView = UIView()
    /// The indent of the content.
    var indentOfContent: CGFloat = 15

    
    /**
     In the constructor there are registered and started action of the view model for getting continents where the animal lives, biotopes where the animal lives and food which the animal eats.
     - Parameters:
        - animal: The object with basic information and some further information about the animal. This object represents the animal.
        - animalDetailViewModel: The view model object for getting data about the animal for the screen
    */
    init(animal: Animal, animalDetailViewModel: AnimalDetailViewModel){
        self.animal = animal
        self.animalDetailViewModel = animalDetailViewModel
        
        super.init()
        self.setupBindingsWithViewModelActions()
        
        // starting of action to get continents, biotopes and food
        self.animalDetailViewModel.getContinentsOfAnimal.apply().start()
        self.animalDetailViewModel.getBiotopesOfAnimal.apply().start()
        self.animalDetailViewModel.getFoodsOfAnimal.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     This function binds the view controller with the action of the view model for getting biotopes and continents where the animal lives and kinds of food which the animal eats.
    */
    override func setupBindingsWithViewModelActions() {
        self.animalDetailViewModel.getContinentsOfAnimal.values.producer.startWithValues{
            (continents) in
            self.continents = continents
        }
        self.animalDetailViewModel.getBiotopesOfAnimal.values.producer.startWithValues {
            (biotopes) in
            self.biotopes = biotopes
        }
        self.animalDetailViewModel.getFoodsOfAnimal.values.producer.startWithValues {
            (foods) in
            self.foods = foods
        }
    }
    
    
    override func viewDidLoad() {
        let textForSubtitle = self.animal.title
        super.setTextForSubtitle(textForSubtitle)
        
        self.setupScrollView()
        super.setParentView(self.contentView)
        
        super.viewDidLoad()
        self.contentView.backgroundColor = .white
        
        
        // indicating whether image is successfully loaded
        var imageSuccessfullyLoaded = false
        
        //adding an image of the animal
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width))
        let url = URL(string: self.animal.image.replacingOccurrences(of: "https:", with: "http:"))
        // we add image to the screen only if the data from the url can be loaded
        if(url != nil){
            let data = try? Data(contentsOf: url!)
            if (data != nil){
                // adding an image of the animal when data can be loaded
                image.image = UIImage(data: data!)
                self.contentView.addSubview(image)
                
                // finding out correct dimensions (especially the correct height of the image so that the image would be correctly loaded and shown)
                let imageWidth = image.image?.size.width
                let imageHeight = image.image?.size.height
                let heightWidthRatio = Float(imageHeight!) / Float(imageWidth!)
                let widthOfContentView = self.view.bounds.width
                let correctHeight = 2.0 / 3.0 * Float(widthOfContentView) * heightWidthRatio
                
                // setting constraints of the image view
                image.snp.makeConstraints{ (make) in
                    make.top.equalTo(super.subtitleLabel.snp.bottom).offset(10)
                    make.centerX.equalToSuperview().offset(super.verticalMenuWidth / 2.0)
                    make.width.equalToSuperview().multipliedBy(2.0 / 3.0)
                    make.height.equalTo(correctHeight)
                }
                
                imageSuccessfullyLoaded = true
            }
        }

        
        let lastView: UIView = imageSuccessfullyLoaded ? image : super.subtitleLabel
        let classInformation = self.getLabelsForInformation(header: L10n.classInfo, content: self.animal.classOfAnimal, note: nil, previousView: lastView, last: false)
        

        let orderInformation = self.getLabelsForInformation(header: L10n.orderInfo, content: self.animal.order, note: nil, previousView: classInformation.last!, last: false)
        
        
        let descriptionInformation = self.getLabelsForInformation(header: L10n.descriptionInfo, content: self.animal.description, note: nil, previousView: orderInformation.last!, last: false)
        
        let biotopesInformation = self.getLabelsForInformation(header: L10n.biotopesInfo, content: self.getTextForBiotopesContentLabel(), note: nil, previousView: descriptionInformation.last!, last: false)
        
        let continentsInformation = self.getLabelsForInformation(header: L10n.continentsAndPlacesInfo, content: self.getTextForContinentsContentLabel(), note: nil, previousView: biotopesInformation.last!, last: false)
        
        let foodInformation = self.getLabelsForInformation(header: L10n.foodInfo, content: self.getTextForFoodContentLabel(), note: nil, previousView: continentsInformation.last!, last: false)
     
        let proportionsInformation = self.getLabelsForInformation(header: L10n.proportionsInfo, content: self.animal.proportions, note: nil, previousView: foodInformation.last!, last: false)
        
        let reproductionInformation = self.getLabelsForInformation(header: L10n.reproductionInfo, content: self.animal.reproduction, note: nil, previousView: proportionsInformation.last!, last: false)
        
        let attractionsInformation = self.getLabelsForInformation(header: L10n.attractionsInfo, content: self.animal.attractions, note: nil, previousView: reproductionInformation.last!, last: false)
        
        let breedingInformation = self.getLabelsForInformation(header: L10n.breedingInfo, content: self.animal.breeding, note: nil, previousView: attractionsInformation.last!, last: self.animal.actualities.count == 0)
        
        
        if (self.animal.actualities.count > 0) {
            let actualitiesTitleLabel = UILabel()
            actualitiesTitleLabel.text = L10n.actualitiesInfoTitle
            actualitiesTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            self.contentView.addSubview(actualitiesTitleLabel)
            actualitiesTitleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(breedingInformation.last!.snp.bottom).offset(12)
                make.centerX.equalToSuperview().offset(super.verticalMenuWidth / 2.0)
            }
            
            
            var lastViewBeforeActuality: UIView = actualitiesTitleLabel
            
            for actuality in self.animal.actualities {
                let actualityTitleLabel = UILabel()
                actualityTitleLabel.text = actuality.title
                actualityTitleLabel.font = UIFont.boldSystemFont(ofSize: 21)
                self.contentView.addSubview(actualityTitleLabel)
                actualityTitleLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(lastViewBeforeActuality.snp.bottom).offset(12)
                    make.centerX.equalToSuperview().offset(super.verticalMenuWidth / 2.0)
                }
                
                let actualityPerexLabel = UILabel ()
                actualityPerexLabel.text = actuality.perex
                actualityPerexLabel.font = UIFont.italicSystemFont(ofSize: UIFont.labelFontSize)
                actualityPerexLabel.textAlignment = .justified
                actualityPerexLabel.numberOfLines = 0
                actualityPerexLabel.lineBreakMode = .byWordWrapping
                actualityPerexLabel.preferredMaxLayoutWidth = self.view.bounds.size.width - super.verticalMenuWidth - 60
                actualityPerexLabel.sizeToFit()
                self.contentView.addSubview(actualityPerexLabel)
                actualityPerexLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(actualityTitleLabel.snp.bottom).offset(8)
                    make.left.equalToSuperview().offset(super.verticalMenuWidth)
                }
                
                let actualityTextLabel = UILabel()
                actualityTextLabel.text = actuality.textOfArticle
                actualityTextLabel.textAlignment = .justified
                actualityTextLabel.numberOfLines = 0
                actualityTextLabel.lineBreakMode = .byWordWrapping
                actualityTextLabel.preferredMaxLayoutWidth = self.view.bounds.size.width - super.verticalMenuWidth - 60
                actualityTextLabel.sizeToFit()
                self.contentView.addSubview(actualityTextLabel)
                actualityTextLabel.snp.makeConstraints{ (make) in
                    make.top.equalTo(actualityPerexLabel.snp.bottom).offset(8)
                    make.left.equalToSuperview().offset(super.verticalMenuWidth)
                }
                lastViewBeforeActuality = actualityTextLabel
            }
            
            lastViewBeforeActuality.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
            }
        }
        
    }
    
    
    /**
     This function ensures setting up the scroll view for elements with informaiton about the animal. This function sets up the scroll view and the content view which is added to the scroll view.
     */
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // adding scroll view to main view and content view to the scroll view
        view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        //adding constraints to scroll view
        scrollView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        //adding constraints to content view
        contentView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
    }
    
    
    /**
    This function returns a string with continents where the animal lives. This string is determined for showing it in a label.
     - Returns: String with continents where tha animal lives.
     */
    func getTextForContinentsContentLabel() -> String{
        var continentString: String = ""
        var noVisitedElement: Bool = true
        for continent in self.continents{
            if (noVisitedElement){
                continentString += continent.title
            } else {
                continentString += ", "+continent.title
            }
            noVisitedElement = false
        }
        if (noVisitedElement){
            continentString += Continent.notInNature.title
        }
        return continentString
    }
    
    
    /**
     This function adds header label and content label for the given information with the given content. There could be added a note. For the note there is created another label under the label for the content. This function returns the array of created labels for the given information.
     - Parameters:
        - header: The content of the header label describing the information.
        - content: The text for the content label. The information about the animal.
        - note: Further note belonging to the information.
        - previousView: The previous view above the header label.
        - last: Boolean representing whether it is the last information in the screen.
     - Returns: The array of created labels for the information about the animal.
     */
    func getLabelsForInformation(header: String, content: String, note: String?, previousView: UIView, last: Bool) -> [UILabel]{
        let headerLabel = UILabel()
        headerLabel.text = header
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.contentView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(previousView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(verticalMenuWidth + indentOfContent)
        }
        
        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.textAlignment = .justified
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.preferredMaxLayoutWidth = self.view.bounds.size.width - verticalMenuWidth - indentOfContent - 60
        contentLabel.sizeToFit()
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(headerLabel.snp.bottom)
            make.left.equalTo(headerLabel.snp.left).offset(indentOfContent)
            if (last && note == nil){
                make.bottom.equalToSuperview()
            }
        }
        
        if (note != nil) {
            let noteLabel = UILabel()
            noteLabel.text = note!
            noteLabel.textAlignment = .justified
            noteLabel.numberOfLines = 0
            noteLabel.lineBreakMode = .byWordWrapping
            noteLabel.preferredMaxLayoutWidth = self.view.bounds.size.width - verticalMenuWidth -  indentOfContent - 60
            noteLabel.sizeToFit()
            self.contentView.addSubview(noteLabel)
            noteLabel.snp.makeConstraints{ (make) in
                make.top.equalTo(contentLabel.snp.bottom)
                make.left.equalTo(contentLabel.snp.left)
                if (last) {
                    make.bottom.equalToSuperview()
                }
            }
            return [headerLabel, contentLabel, noteLabel]
        } else {
            return [headerLabel, contentLabel]
        }
        
    }
    
    
    /**
     This function returns a string with biotopes where the animal lives. This string is determined for showing it in a label.
     - Returns: String with biotopes in which the animal lives.
     */
    func getTextForBiotopesContentLabel() -> String {
        var biotopeString: String = ""
        var firstElement: Bool = true
        for biotope in self.biotopes{
            if (firstElement){
                biotopeString += biotope.title
            } else {
                biotopeString += ", "+biotope.title
            }
            firstElement = false
        }
        return biotopeString
    }
    
    
    /**
     This function returns a string with kinds of food which the animal eats. This string is determined for showing it in a label.
     - Returns: String with kinds of foods which the animal eats.
     */
    func getTextForFoodContentLabel() -> String {
        var foodString: String = ""
        var firstElement: Bool = true
        for food in self.foods{
            if (firstElement){
                foodString += food.title
            } else {
                foodString += ", "+food.title
            }
            firstElement = false
        }
        return foodString
    }

}
