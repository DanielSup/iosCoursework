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
        view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.scrollView.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
    }

    init(animal: Animal, animalDetailViewModel: AnimalDetailViewModel){
        self.animal = animal
        self.animalDetailViewModel = animalDetailViewModel
        super.init()
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
        self.animalDetailViewModel.getContinentsOfAnimal.apply().start()
        self.animalDetailViewModel.getBiotopesOfAnimal.apply().start()
        self.animalDetailViewModel.getFoodsOfAnimal.apply().start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stringForContinentsLabel() -> String{
        var continentString: String = ""
        var first: Bool = true
        for continent in self.continents{
            if (first){
                continentString += continent.title
            } else {
                continentString += ", "+continent.title
            }
            first = false
        }
        return continentString
    }
    
    func stringForBiotopesLabel() -> String {
        var biotopeString: String = ""
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
        var foodString: String = ""
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
        let titleLabel = UILabel()
        titleLabel.text = self.animal.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize * 5 / 2 )
        titleLabel.textColor = .black
        self.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width))
        let url = URL(string: self.animal.image.replacingOccurrences(of: "https:", with: "http:"))
        var success = false
        if(url != nil){
            let data = try? Data(contentsOf: url!)
            if (data != nil){
                image.image = UIImage(data: data!)
                self.contentView.addSubview(image)
                image.translatesAutoresizingMaskIntoConstraints = false
                image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
                image.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
                image.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2/3).isActive = true
                success = true
            }
        }
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
        descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        if(success){
            descriptionLabel.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        } else {
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        }
        let continentsLabel = UILabel()
        continentsLabel.text = self.stringForContinentsLabel()
        continentsLabel.textColor = .black
        self.contentView.addSubview(continentsLabel)
        continentsLabel.translatesAutoresizingMaskIntoConstraints = false
        continentsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        continentsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        
        let biotopesLabel = UILabel()
        biotopesLabel.text = self.stringForBiotopesLabel()
        biotopesLabel.textColor = .black
        self.contentView.addSubview(biotopesLabel)
        biotopesLabel.translatesAutoresizingMaskIntoConstraints = false
        biotopesLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        biotopesLabel.topAnchor.constraint(equalTo: continentsLabel.bottomAnchor).isActive = true
        
        let foodsLabel = UILabel()
        foodsLabel.text = self.stringForFoodsLabel()
        foodsLabel.textColor = .black
        self.contentView.addSubview(foodsLabel)
        foodsLabel.translatesAutoresizingMaskIntoConstraints = false
        foodsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        foodsLabel.topAnchor.constraint(equalTo: biotopesLabel.bottomAnchor).isActive = true
        
        let proportionsLabel = UILabel()
        proportionsLabel.text = self.animal.proportions
        proportionsLabel.textColor = .black
        proportionsLabel.textAlignment = .justified
        self.contentView.addSubview(proportionsLabel)
        proportionsLabel.translatesAutoresizingMaskIntoConstraints = false
        proportionsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        proportionsLabel.topAnchor.constraint(equalTo: foodsLabel.bottomAnchor).isActive = true
        
        let reproductionLabel = UILabel()
        reproductionLabel.text = self.animal.reproduction
        reproductionLabel.textColor = .black
        reproductionLabel.textAlignment = .justified
        self.contentView.addSubview(reproductionLabel)
        reproductionLabel.translatesAutoresizingMaskIntoConstraints = false
        reproductionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        reproductionLabel.topAnchor.constraint(equalTo: proportionsLabel.bottomAnchor).isActive = true
        
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
        attractionsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        attractionsLabel.topAnchor.constraint(equalTo: reproductionLabel.bottomAnchor).isActive = true
        
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
        breedingsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        breedingsLabel.topAnchor.constraint(equalTo: attractionsLabel.bottomAnchor).isActive = true
        breedingsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true        /* let goToAnimalListButton = UIButton()
        goToAnimalListButton.setTitle(NSLocalizedString("goToAnimalList", comment: ""), for: .normal)
        goToAnimalListButton.setTitleColor(.black, for: .normal)
        goToAnimalListButton.addTarget(self, action: #selector(goBackTapped(_:)), for: .touchUpInside)
        view.addSubview(goToAnimalListButton)
        goToAnimalListButton.snp.makeConstraints{
            (make) in
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(50)
        }  */
        // Do any additional setup after loading the view.
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
