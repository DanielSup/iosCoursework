//
//  AnimalDetailViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 19/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import SnapKit

class AnimalDetailViewController: BaseViewController {
    private let animal: Animal
    private let animalDetailViewModel: AnimalDetailViewModel
    private var continents: [Continent] = []
    private var biotopes: [Biotope] = []
    private var foods: [Food] = []
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    
    weak var flowDelegate: GoBackDelegate?
    
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
        
        
        //adding an image of the animal
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width))
        let url = URL(string: self.animal.image.replacingOccurrences(of: "https:", with: "http:"))
        var success = false
        // we add image to the screen only if the data from the url can be loaded
        if(url != nil){
            let data = try? Data(contentsOf: url!)
            if (data != nil){
                // adding an image of the animal when data can be loaded
                image.image = UIImage(data: data!)
                self.contentView.addSubview(image)
                image.translatesAutoresizingMaskIntoConstraints = false
                image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
                image.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
                image.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2/3).isActive = true
                success = true
            }
        }
        
        // adding a multiline text label with description of the animal
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.text = self.animal.description
        descriptionLabel.textAlignment = .justified
        descriptionLabel.textColor = .black
        descriptionLabel.sizeToFit()
        descriptionLabel.preferredMaxLayoutWidth = self.view.bounds.width * 10 / 11
        
        self.contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        // setting constraints dependent on whether the image of the animal could be loaded
        descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        if(success){
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
        proportionsLabel.numberOfLines = 0
        proportionsLabel.lineBreakMode = .byWordWrapping
        proportionsLabel.text = "Proporce: "+self.animal.proportions
        proportionsLabel.textColor = .black
        proportionsLabel.textAlignment = .justified
        proportionsLabel.sizeToFit()
        proportionsLabel.preferredMaxLayoutWidth = self.view.bounds.width * 10 / 11
        
        self.contentView.addSubview(proportionsLabel)
        proportionsLabel.translatesAutoresizingMaskIntoConstraints = false
        // setting constraints
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
        attractionsLabel.numberOfLines = 0
        attractionsLabel.lineBreakMode = .byWordWrapping
        attractionsLabel.text = self.animal.attractions
        attractionsLabel.textColor = .black
        attractionsLabel.textAlignment = .justified
        attractionsLabel.sizeToFit()
        attractionsLabel.preferredMaxLayoutWidth = self.view.bounds.width * 10 / 11
        
        self.contentView.addSubview(attractionsLabel)
        attractionsLabel.translatesAutoresizingMaskIntoConstraints = false
        // setting constraints
        attractionsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        attractionsLabel.topAnchor.constraint(equalTo: reproductionLabel.bottomAnchor, constant: 10).isActive = true
        
        
        // adding a multiline text label with information about the breeding of the animal
        let breedingsLabel = UILabel()
        breedingsLabel.numberOfLines = 0
        breedingsLabel.lineBreakMode = .byWordWrapping
        breedingsLabel.text = self.animal.breeding
        breedingsLabel.textColor = .black
        breedingsLabel.textAlignment = .justified
        breedingsLabel.sizeToFit()
        breedingsLabel.preferredMaxLayoutWidth = self.view.bounds.width * 10 / 11
        
        self.contentView.addSubview(breedingsLabel)
        breedingsLabel.translatesAutoresizingMaskIntoConstraints = false
        // setting constraints
        breedingsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        breedingsLabel.topAnchor.constraint(equalTo: attractionsLabel.bottomAnchor, constant: 10).isActive = true
        breedingsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    @objc
    func goBackTapped(_ sender: UIButton){
        flowDelegate?.goBackTapped(in: self)
    }

}
