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
 This class represents a screen with detailed information about an animal. This view controller is usually called from the list of animals.
 */
class AnimalDetailViewController: BaseViewController {
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
    /// Delegate ensuring going to the list of animals
    weak var flowDelegate: GoBackDelegate?

    
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
        
        // registering of actions to get continents, biotopes and foods from the view model
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
        
        // starting of action to get continents, biotopes and food
        self.animalDetailViewModel.getContinentsOfAnimal.apply().start()
        self.animalDetailViewModel.getBiotopesOfAnimal.apply().start()
        self.animalDetailViewModel.getFoodsOfAnimal.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     - Returns: String with continents where tha animal lives.
    */
    func stringForContinentsLabel() -> String{
        var continentString: String = "Kontinenty, kde se vyskytuje: "
        var first: Bool = true
        for continent in self.continents{
            if (first){
                continentString += continent.title
            } else {
                continentString += ", "+continent.title
            }
            first = false
        }
        if (first){
            continentString += Continent.notInNature.title
        }
        return continentString
    }
    
    
    /**
     - Returns: String with biotopes in which the animal lives.
     */
    func stringForBiotopesLabel() -> String {
        var biotopeString: String = "Biotopy, kde se vyskytuje: "
        var first: Bool = true
        for biotope in self.biotopes{
            if (first){
                biotopeString += biotope.title
            } else {
                biotopeString += ", "+biotope.title
            }
            first = false
        }
        return biotopeString
    }
    
    
    /**
     - Returns: String with kinds of foods which the animal eats.
    */
    func stringForFoodsLabel() -> String {
        var foodString: String = "Potrava: "
        var first: Bool = true
        for food in self.foods{
            if (first){
                foodString += food.title
            } else {
                foodString += ", "+food.title
            }
            first = true
        }
        return foodString
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
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        //adding constraints to content view
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScrollView()
        
        view.backgroundColor = .white
        //adding a label with the name of the animal
        let titleLabel = UILabel()
        titleLabel.text = self.animal.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize * 5 / 2 )
        titleLabel.textColor = .black
        self.contentView.addSubview(titleLabel)
        //setting constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        
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
                let correctWidth = 2.0 / 3.0 * Float(widthOfContentView) * heightWidthRatio
                
                // setting constraints of the image view
                image.translatesAutoresizingMaskIntoConstraints = false
                image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
                image.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
                image.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2/3).isActive = true
                image.heightAnchor.constraint(equalToConstant: CGFloat(correctWidth)).isActive = true
                
                imageSuccessfullyLoaded = true
            }
        }
        
        // adding a multiline text label with description of the animal
        let descriptionLabel = UILabel()
        descriptionLabel.text = self.animal.description
        descriptionLabel.textAlignment = .justified
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.preferredMaxLayoutWidth = self.view.bounds.width * 10 / 11
        descriptionLabel.sizeToFit()
        self.contentView.addSubview(descriptionLabel)
         // setting constraints dependent on whether the image of the animal could be loaded
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        if(imageSuccessfullyLoaded){
            descriptionLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10).isActive = true
        } else {
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        }
        
        
        // adding of a text label with continents where the animal lives
        let continentsLabel = UILabel()
        continentsLabel.text = self.stringForContinentsLabel()
        continentsLabel.textColor = .black
        self.contentView.addSubview(continentsLabel)
        // setting constraints
        continentsLabel.translatesAutoresizingMaskIntoConstraints = false
        continentsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        continentsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        
        
        // adding of a text label with biotopes where the animal lives
        let biotopesLabel = UILabel()
        biotopesLabel.text = self.stringForBiotopesLabel()
        biotopesLabel.textColor = .black
        self.contentView.addSubview(biotopesLabel)
        // setting contraints
        biotopesLabel.translatesAutoresizingMaskIntoConstraints = false
        biotopesLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        biotopesLabel.topAnchor.constraint(equalTo: continentsLabel.bottomAnchor, constant: 10).isActive = true
        
        
        // adding of a text label with foods which the animal eats
        let foodsLabel = UILabel()
        foodsLabel.text = self.stringForFoodsLabel()
        foodsLabel.textColor = .black
        self.contentView.addSubview(foodsLabel)
        // setting constraints
        foodsLabel.translatesAutoresizingMaskIntoConstraints = false
        foodsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        foodsLabel.topAnchor.constraint(equalTo: biotopesLabel.bottomAnchor, constant: 10).isActive = true
        
        
        // adding of a multiline text label with the information about proportions of the animal
        let proportionsLabel = UILabel()
        proportionsLabel.text = "Proporce: "+self.animal.proportions
        proportionsLabel.textColor = .black
        proportionsLabel.textAlignment = .justified
        proportionsLabel.numberOfLines = 0
        proportionsLabel.lineBreakMode = .byWordWrapping
        proportionsLabel.preferredMaxLayoutWidth = self.view.bounds.width * 10 / 11
        proportionsLabel.sizeToFit()
        self.contentView.addSubview(proportionsLabel)
         // setting constraints
        proportionsLabel.translatesAutoresizingMaskIntoConstraints = false
        proportionsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        proportionsLabel.topAnchor.constraint(equalTo: foodsLabel.bottomAnchor, constant: 10).isActive = true
        
        
        // adding a text label with information about reproduction of the animal
        let reproductionLabel = UILabel()
        reproductionLabel.text = self.animal.reproduction
        reproductionLabel.textColor = .black
        reproductionLabel.textAlignment = .justified
        self.contentView.addSubview(reproductionLabel)
        reproductionLabel.translatesAutoresizingMaskIntoConstraints = false
        // setting constraints
        reproductionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        reproductionLabel.topAnchor.constraint(equalTo: proportionsLabel.bottomAnchor, constant: 10).isActive = true
        
        
        // adding a multiline text label with attractions about the animal
        let attractionsLabel = UILabel()
        attractionsLabel.text = self.animal.attractions
        attractionsLabel.textColor = .black
        attractionsLabel.textAlignment = .justified
        attractionsLabel.numberOfLines = 0
        attractionsLabel.lineBreakMode = .byWordWrapping
        attractionsLabel.preferredMaxLayoutWidth = self.view.bounds.width * 10 / 11
        attractionsLabel.sizeToFit()
        self.contentView.addSubview(attractionsLabel)
        // setting constraints
        attractionsLabel.translatesAutoresizingMaskIntoConstraints = false
        attractionsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        attractionsLabel.topAnchor.constraint(equalTo: reproductionLabel.bottomAnchor, constant: 10).isActive = true
        
        
        // adding a multiline text label with information about the breeding of the animal
        let breedingsLabel = UILabel()
        breedingsLabel.text = self.animal.breeding
        breedingsLabel.textColor = .black
        breedingsLabel.textAlignment = .justified
        breedingsLabel.numberOfLines = 0
        breedingsLabel.lineBreakMode = .byWordWrapping
        breedingsLabel.preferredMaxLayoutWidth = self.view.bounds.width * 10 / 11
        breedingsLabel.sizeToFit()
        self.contentView.addSubview(breedingsLabel)
        // setting constraints
        breedingsLabel.translatesAutoresizingMaskIntoConstraints = false
        breedingsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        breedingsLabel.topAnchor.constraint(equalTo: attractionsLabel.bottomAnchor, constant: 10).isActive = true
        breedingsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    
    // MARK - Actions
    
    @objc
    func goBackTapped(_ sender: UIButton){
        flowDelegate?.goBackTapped(in: self)
    }

}
