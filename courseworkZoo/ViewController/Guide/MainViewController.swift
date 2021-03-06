//
//  MainViewController.swift
//  courseworkZoo
//
//  Created by Daniel Šup on 26/06/2019.
//  Copyright © 2019 Daniel Šup. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import ReactiveSwift
import SwiftyGif


/**
 This class represents the main screen with a large map with markers of localities and animals with given coordinates. This class also ensures saying information about localities and animals when the user is at a locality or an animal with given coordinates.
 */
class MainViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    /// The view model which ensures getting data for the screen
    private var mainViewModel: MainViewModel
    /// The delegate which ensures taking user to different screens
    weak var flowDelegate: MainDelegate?
    /// The boolean representing whether the shortest path will be counted or not (only actualized)
    private var countShortestPath: Bool = true
    /// The animal which is enough close to machine-read information about it.
    private var closeAnimal: Animal? = nil
    /// The array of visited animals in the visit of the ZOO.
    private var visitedAnimals: [Animal] = []
    /// The length of the path with animals
    private var lengthOfTheTripInZoo: Double = 0.0
    /// The number of unvisited animals in the actual path.
    private var countOfUnvisitedAnimals: Int = 0
    /// The walk speed during the visit of the ZOO.
    private var walkSpeed: Float = 0.0
    /// The time spent at one animal during the visit of the ZOO.
    private var timeSpentAtOneAnimal: Float = 0.0
    /// The boolean representing whether the user gone at the input to the ZOO.
    private var entranceVisited = false
    /// The boolean representing whether the user gone throught the exit from the ZOO.
    private var exitVisited = false
    /// The boolean representing whether the voice is turned on (true) or turned off (false).
    private var isVoiceOn = true
    /// The boolean representing whether the guide says other information and instructions.
    private var isInformationFromGuideSaid = true
    /// The boolean representing whether there is any text machine-reading now.
    private var isMachineReadingRunning = false
    /// The double representing the radius of the map view.
    private var radius: Double = 1000000.0
    /// The coordinate of the entrance
    private var coordinateOfEntrance: CLLocationCoordinate2D!

    
    
    /// The location manager which ensures listening to changes of the actual location
    let locationManager = CLLocationManager()
    
    /// The scroll view for scrolling the main screen with map and information about any enough close animal
    private let scrollView: UIScrollView = UIScrollView()
    /// The view inside the scroll view with map and information about any enough close animal
    private let contentView: UIView = UIView()
    /// The vertical menu with buttons for actions (mostly going to a different screen, one item is for turning off (turning on) the voice)
    private var verticalMenu: VerticalMenu!
    /// The horizontal menu next to the second item of the vertical menu with buttons for actions (going to a different screen)
    private var horizontalMenu: UIView = UIView()
    /// The animation view with a speaking character.
    private var speakingCharacterImageView = try? UIImageView(gifImage: UIImage(gifName: "speakingCharacter.gif"), loopCount: 1000000000)
    /// The map of the zoo.
    private weak var zooPlanMapView: MKMapView!
    /// The multiline label for reading the actually machine-read text about a close locality or a close animal.
    private var textForReadingLabel: UILabel!
    /// The label for showing the length of the path in the ZOO.
    private var viewForTheLengthOfThePathLabel: UILabel!
    /// The label for showing the total time of the visit in the ZOO
    private var viewForTimeOfTheVisitOfTheZOOLabel: UILabel!
    /// The instance of the last dialog shown in the map view.
    private var lastDialogAtMarker: UIView!
    
    /**
     - Parameters:
        - viewModel: instance of the view model for getting data for the screen implemented by this view controller
     */
    init(mainViewModel: MainViewModel){
        self.mainViewModel = mainViewModel
        super.init()
        self.setupBindingsWithViewModelActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.mainViewModel = MainViewModel(dependencies: AppDependency.shared)
        super.init()
        self.setupBindingsWithViewModelActions()
    }
    
    
    /**
     This function ensures binding this view controller with actions of the view model for getting localities and animals with known coordinates and actions ensuring machine-reading of information about a close animal or a close locality (it is given by maximum distance).
    */
    override func setupBindingsWithViewModelActions(){
        // adding annotations of localities (especially pavilions) with known coordinates to the map
        self.mainViewModel.getLocalities.values.producer.startWithValues {(localitiesList) in
            for locality in localitiesList{
                // making and adding an annotation of the actual locality to the map
                let annotation: MKPointAnnotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: locality.latitude, longitude: locality.longitude)
                annotation.coordinate = coordinate
                annotation.title = locality.title
                self.zooPlanMapView.addAnnotation(annotation)
            }
        }
        
        // registration of the action which ensures adding annotations of animals with known coordinates to the map after getting the list of animals with given coordinates
        self.mainViewModel.getAnimals.values.producer.startWithValues { (animalList) in
            
            for animal in animalList{
                // making and adding an annotation of the actual animal to the map
                let coordinate = CLLocationCoordinate2D(latitude: animal.latitude, longitude: animal.longitude)
                let annotation: AnimalAnnotation = AnimalAnnotation(coordinate: coordinate, animal: animal)
                self.zooPlanMapView.addAnnotation(annotation)
            }
        }
        
        self.mainViewModel.isMachineReadingRunning.values.producer.startWithValues { (isMachineReadingRunning) in
            self.isMachineReadingRunning = isMachineReadingRunning
        }
        
        // registration of the actions for saying information about localities and animals in the closeness of the actual location
        self.mainViewModel.getAnimalInCloseness.values.producer.startWithValues{ (animal) in
            
            self.mainViewModel.isMachineReadingRunning.apply().start()
            
            if (animal != nil && !self.isMachineReadingRunning && self.textForReadingLabel.text == "" && self.isVoiceOn) {
                self.textForReadingLabel.text = self.mainViewModel.textForShowingAbout(animal: animal)
                
                self.mainViewModel.setCallbacksOfSpeechService(startCallback: {
                    self.speakingCharacterImageView?.startAnimatingGif()
                    self.closeAnimal = animal
                    self.refreshMapView()
                }, finishCallback: {
                    self.speakingCharacterImageView?.stopAnimatingGif()
                    self.closeAnimal = nil
                    self.mainViewModel.visitAnimal(animal!)
                    self.refreshMapView()
                    self.textForReadingLabel.text = ""
                    self.mainViewModel.getNextAnimalInThePath.apply().start()
                })
                self.mainViewModel.sayInformationAbout(animal: animal)
            } else if (animal != nil && !self.isVoiceOn) {
                self.closeAnimal = animal
                self.mainViewModel.visitAnimal(animal!)
                self.mainViewModel.getNextAnimalInThePath.apply().start()
                self.refreshMapView()
                self.closeAnimal = nil
            }
        }
        
        self.mainViewModel.getLocalityInCloseness.values.producer.startWithValues{ locality in
            
            self.mainViewModel.isMachineReadingRunning.apply().start()
            
            if (locality != nil && !self.isMachineReadingRunning && self.textForReadingLabel.text == "" && self.isVoiceOn) {
                self.textForReadingLabel.text = self.mainViewModel.textForShowingAbout(locality: locality)
                
                self.mainViewModel.setCallbacksOfSpeechService(startCallback: {
                    self.mainViewModel.visitLocality(locality!)
                    self.speakingCharacterImageView?.startAnimatingGif()
                }, finishCallback: {
                    self.speakingCharacterImageView?.stopAnimatingGif()
                    self.textForReadingLabel.text = ""
                })
                self.mainViewModel.sayInformationAbout(locality: locality)
            }
        }
        
        
        // action for turning on or off the voice
        self.mainViewModel.isVoiceOn.values.producer.startWithValues{ voiceOn in
            if (voiceOn){
                self.verticalMenu.getItemAt(index: 4)?.changeActionStringAndActionText(actionString: "turnOffVoice", actionText: L10n.turnOffVoice)
            } else {
                self.verticalMenu.getItemAt(index: 4)?.changeActionStringAndActionText(actionString: "turnOnVoice", actionText: L10n.turnOnVoice)
            }
        }
        
        self.mainViewModel.getPlacemarksForTheActualPath.values.producer.startWithValues { placemarks in
            
            self.lengthOfTheTripInZoo = 0.0
            self.zooPlanMapView.removeOverlays(self.zooPlanMapView.overlays)
            self.mainViewModel.set(sourceLocation: self.zooPlanMapView.userLocation.coordinate)
            var lastPlacemark = placemarks[0]
            var first: Bool = true
            for placemark in placemarks[1...] {
                self.drawShortestRouteBetweenTwoPlacemarks(sourcePlacemark: lastPlacemark, destinationPlacemark: placemark, fromActual: first)
                lastPlacemark = placemark
                first = false
            }
        }
        
        self.mainViewModel.getVisitedAnimals.values.producer.startWithValues { visitedAnimals in
            self.visitedAnimals = visitedAnimals
        }
        
        self.mainViewModel.getCountOfUnvisitedAnimals.values.producer.startWithValues { countOfUnvisitedAnimals in
            self.countOfUnvisitedAnimals = countOfUnvisitedAnimals
            if (countOfUnvisitedAnimals > 0) {
                self.exitVisited = false
            }
        }
        
        self.mainViewModel.getWalkSpeed.values.producer.startWithValues {
            walkSpeed in
            self.walkSpeed = walkSpeed
        }
        
        self.mainViewModel.getTimeSpentAtOneAnimal.values.producer.startWithValues {
            timeSpentAtOneAnimal in
            self.timeSpentAtOneAnimal = timeSpentAtOneAnimal
        }
        
        self.mainViewModel.getNextAnimalInThePath.values.producer.startWithValues {
            nextAnimal in
            if (nextAnimal == nil && self.visitedAnimals.count > 0) {
                self.sayText(L10n.goToExit, interrupt: false)
            } else if (nextAnimal != nil) {
                self.sayText(L10n.nextAnimalInPath + " " + nextAnimal!.title, interrupt: false)
            }
        }
        
        self.mainViewModel.isVoiceOn.values.producer.startWithValues{ (isVoiceOn) in
            self.isVoiceOn = isVoiceOn
        }
        
        self.mainViewModel.getAnimalsInPath.values.producer.startWithValues{ (animalsInPath) in
            self.mainViewModel.set(animalsInPath: animalsInPath)
        }
        
        self.mainViewModel.isInformationFromGuideSaid.values.producer.startWithValues { (isInformationFromGuideSaid) in
            self.isInformationFromGuideSaid = isInformationFromGuideSaid
        }
    }
    /**
     This function ensures refreshing the pins in the map view with markers for animals and localities.
    */
    func refreshMapView(){
        self.zooPlanMapView.removeAnnotations(self.zooPlanMapView!.annotations)
        self.addLoadedLocalitiesToMap()
    }
    
    
    /**
     This function refresh annotations of animals in the map view apart from the selected annotation. This method is called after change the actual path.
     - Parameters:
        - annotation: The selected annotation of animal.
    */
    func refreshAnimalAnnotationsWithoutSelected(annotation: MKAnnotation) {
        var annotations: [MKAnnotation] = []
        for annotationInMapView in self.zooPlanMapView!.annotations {
            if let animalAnnotation = annotationInMapView as? AnimalAnnotation {
                if (abs(animalAnnotation.coordinate.latitude - annotation.coordinate.latitude) >= 1e-7 || abs(animalAnnotation.coordinate.longitude - annotation.coordinate.longitude) >= 1e-7) {
                    annotations.append(animalAnnotation)
                }
            }
        }
        
        self.zooPlanMapView.removeAnnotations(annotations)
        self.mainViewModel.getAnimals.values.producer.startWithValues { (animalList) in
            for animal in animalList{
                if (abs(animal.latitude - annotation.coordinate.latitude) >= 1e-7 || abs(animal.longitude - annotation.coordinate.longitude) >= 1e-7) {
                    continue
                }
                // making and adding an annotation of the actual animal to the map
                let coordinate = CLLocationCoordinate2D(latitude: animal.latitude, longitude: animal.longitude)
                let annotation: AnimalAnnotation = AnimalAnnotation(coordinate: coordinate, animal: animal)
                self.zooPlanMapView.addAnnotation(annotation)
            }
            
        }
        self.mainViewModel.getAnimals.apply().start()
    }
    
    
    
    /**
     In this function there is refreshed the map view with markers and there are reloaded parameters of the visit of the ZOO.
     - Parameters:
        - animated: The boolean representing whether the view was added to the window using an animation.
    */
    override func viewDidAppear(_ animated: Bool) {
        self.refreshMapView()
        
        self.mainViewModel.set(sourceLocation: self.zooPlanMapView.userLocation.coordinate)
        self.mainViewModel.getAnimalsInPath.apply().start()
        self.mainViewModel.getCountOfUnvisitedAnimals.apply().start()
        self.mainViewModel.getPlacemarksForTheActualPath.apply(true).start()
        self.mainViewModel.isInformationFromGuideSaid.apply().start()
        if (self.countOfUnvisitedAnimals > 0 && self.isInformationFromGuideSaid) {
            self.sayText(L10n.pathIsCounting, interrupt: false)
        }
        self.mainViewModel.getWalkSpeed.apply().start()
        self.mainViewModel.getTimeSpentAtOneAnimal.apply().start()
    }
    
    
    /**
     This function ensures setting the location manager to watch the location with the best possibel accuracy. This function also ensures adding the map view and the navigation bar to the screen.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScrollView()
        self.view.backgroundColor = Colors.screenBodyBackgroundColor.color
        
        // adding a vertical menu
        let verticalMenu = VerticalMenu(width: 70, topOffset: 0, parentView: self.contentView)
        
        let goToLexiconItem = VerticalMenuItem(actionString: "goToLexicon", actionText: L10n.goToLexicon, usedBackgroundColor: Colors.goToGuideOrLexiconButtonBackgroundColor.color)
        goToLexiconItem.addTarget(self, action: #selector(goToLexiconItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(goToLexiconItem, height: 120, last: false)
        
        let selectAnimalsToPathItem = VerticalMenuItem(actionString: "selectAnimalsToPath", actionText: L10n.selectAnimalsToPath, usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
        selectAnimalsToPathItem.addTarget(self, action: #selector(selectAnimalsToPathItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(selectAnimalsToPathItem, height: 90, last: false)
        
        let settingParametersOfVisitItem = VerticalMenuItem(actionString: "settingParametersOfVisit", actionText: L10n.settingParametersOfVisit, usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
        settingParametersOfVisitItem.addTarget(self, action: #selector(settingParametersOfVisitItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(settingParametersOfVisitItem, height: 90, last: false)
        
        let selectInformationItem = VerticalMenuItem(actionString: "selectInformation", actionText: L10n.selectInformation, usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
        selectInformationItem.addTarget(self, action: #selector(selectInformationItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(selectInformationItem, height: 90, last: false)
        
        let turnOnOrOffVoiceItem = VerticalMenuItem(actionString: "turnOffVoice", actionText: L10n.turnOffVoice, usedBackgroundColor: Colors.nonSelectedItemBackgroundColor.color)
        turnOnOrOffVoiceItem.addTarget(self, action: #selector(turnOnOrOffVoiceItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(turnOnOrOffVoiceItem, height: 90, last: false)
        
        let helpItem = VerticalMenuItem(actionString: "help", actionText: L10n.help, usedBackgroundColor: Colors.helpButtonBackgroundColor.color)
        helpItem.addTarget(self, action: #selector(helpItemTapped(_:)), for: .touchUpInside)
        verticalMenu.addItem(helpItem, height: 90, last: true)
        self.verticalMenu = verticalMenu
        
        
        // adding a view for the title on the screen
        let titleHeader = TitleHeader(title: L10n.guideTitle, menuInTheParentView: verticalMenu, parentView: self.contentView)
        
        
        // adding the horizontal menu
        let horizontalMenu = UIView()
        horizontalMenu.backgroundColor = .black
        self.contentView.addSubview(horizontalMenu)
        horizontalMenu.snp.makeConstraints{ (make) in
            make.top.equalTo(goToLexiconItem.snp.bottom)
            make.left.equalTo(goToLexiconItem.snp.right)
            make.width.equalToSuperview().offset(-198).multipliedBy(73.0 / 76.0)
            make.height.equalTo(90)
        }
        self.horizontalMenu = horizontalMenu
        
        // add an item for saving path
        let savePathButton = self.getItemInTheHorizontalMenu(previousItem: selectAnimalsToPathItem, actionString: "savePath", actionText: L10n.savePath)
        savePathButton.addTarget(self, action: #selector(savePathButtonTapped(_:)), for: .touchUpInside)
        // add in item for choosing the path
        let chooseSavedPathButton = self.getItemInTheHorizontalMenu(previousItem: savePathButton, actionString: "chooseSavedPath", actionText: L10n.chooseSavedPath)
        chooseSavedPathButton.addTarget(self, action: #selector(chooseSavedPathButtonTapped(_:)), for: .touchUpInside)
        
        
        let backgroundOfAnimationView = UIView()
        backgroundOfAnimationView.backgroundColor = Colors.titleBackgroundColor.color
        self.contentView.addSubview(backgroundOfAnimationView)
        backgroundOfAnimationView.snp.makeConstraints{ (make) in
            make.top.equalTo(self.horizontalMenu.snp.top)
            make.left.equalTo(self.horizontalMenu.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(180)
        }
        
        if(self.speakingCharacterImageView != nil) {
            backgroundOfAnimationView.addSubview(self.speakingCharacterImageView!)
            self.speakingCharacterImageView!.snp.makeConstraints{ (make) in
                make.top.equalTo(self.horizontalMenu.snp.top)
                make.left.equalTo(self.horizontalMenu.snp.right)
                make.width.equalTo(128)
                make.height.equalTo(180)
            }
            self.speakingCharacterImageView?.stopAnimatingGif()
        }
        
        
        // Views for showing statistics of the visit of the ZOO
        let viewForTheLengthOfThePath = UIView()
        viewForTheLengthOfThePath.backgroundColor = Colors.titleBackgroundColor.color
        self.contentView.addSubview(viewForTheLengthOfThePath)
        viewForTheLengthOfThePath.snp.makeConstraints { (make) in
            make.top.equalTo(self.horizontalMenu.snp.bottom)
            make.left.equalTo(verticalMenu.snp.right)
            make.width.equalTo(self.horizontalMenu.snp.width)
            make.height.equalTo(45)
        }
        
        let viewForTheLengthOfThePathLabel = UILabel()
        viewForTheLengthOfThePathLabel.attributedText = self.getAttributedStringWithStatistic(statistic: L10n.lengthOfThePathInZOO, value: Float(self.lengthOfTheTripInZoo / 1000.0), units: "km")
        viewForTheLengthOfThePathLabel.numberOfLines = 0
        viewForTheLengthOfThePathLabel.lineBreakMode = .byWordWrapping
        viewForTheLengthOfThePathLabel.preferredMaxLayoutWidth = 140
        viewForTheLengthOfThePathLabel.sizeToFit()
        viewForTheLengthOfThePath.addSubview(viewForTheLengthOfThePathLabel)
        viewForTheLengthOfThePathLabel.snp.makeConstraints{ (make) in
            make.center.equalToSuperview()
        }
        self.viewForTheLengthOfThePathLabel = viewForTheLengthOfThePathLabel
        
        
        
        let viewForTimeOfTheVisitOfTheZOO = UIView()
        viewForTimeOfTheVisitOfTheZOO.backgroundColor = Colors.titleBackgroundColor.color
        self.contentView.addSubview(viewForTimeOfTheVisitOfTheZOO)
        viewForTimeOfTheVisitOfTheZOO.snp.makeConstraints{ (make) in
            make.top.equalTo(viewForTheLengthOfThePath.snp.bottom)
            make.left.equalTo(verticalMenu.snp.right)
            make.width.equalTo(self.horizontalMenu.snp.width)
            make.height.equalTo(45)
        }
        
        let viewForTimeOfTheVisitOfTheZOOLabel = UILabel()
        viewForTimeOfTheVisitOfTheZOOLabel.attributedText = self.getAttributedStringWithStatistic(statistic: L10n.timeOfTheVisitOfTheZOO, value: 0, units: "min")
        viewForTimeOfTheVisitOfTheZOOLabel.numberOfLines = 0
        viewForTimeOfTheVisitOfTheZOOLabel.lineBreakMode = .byWordWrapping
        viewForTimeOfTheVisitOfTheZOOLabel.preferredMaxLayoutWidth = 140
        viewForTimeOfTheVisitOfTheZOOLabel.sizeToFit()
        viewForTimeOfTheVisitOfTheZOO.addSubview(viewForTimeOfTheVisitOfTheZOOLabel)
        viewForTimeOfTheVisitOfTheZOOLabel.snp.makeConstraints{ (make) in
            make.center.equalToSuperview()
        }
        self.viewForTimeOfTheVisitOfTheZOOLabel = viewForTimeOfTheVisitOfTheZOOLabel
        
        
        //adding the main map view
        let zooPlanMapView = MKMapView()
        self.contentView.addSubview(zooPlanMapView)
        zooPlanMapView.showsUserLocation = true
        zooPlanMapView.delegate = self
        zooPlanMapView.snp.makeConstraints { (make) in
            make.top.equalTo(settingParametersOfVisitItem.snp.bottom)
            make.left.equalTo(verticalMenu.snp.right)
            make.bottom.equalTo(verticalMenu.snp.bottom)
            make.right.equalToSuperview()
        }
        // setting of the ZOO plan map view for further work
        self.zooPlanMapView = zooPlanMapView
        
        let userLocation = self.zooPlanMapView.userLocation.coordinate
        self.mainViewModel.set(sourceLocation: userLocation)
        
        
        let legendView = LegendView(parentView: self.contentView, zooPlanMapView: self.zooPlanMapView)
        
        
        let animalSelectedItem = LegendViewItem(imageName: "animalSelected", textOfTheLegend: L10n.animalSelectedLegend)
        legendView.addItem(animalSelectedItem, last: false)
        
        let nextAnimalToVisitItem = LegendViewItem(imageName: "nextAnimalToVisit", textOfTheLegend: L10n.nextAnimalToVisitLegend)
        legendView.addItem(nextAnimalToVisitItem, last: false)
        
        let animalLegendItem = LegendViewItem(imageName: "animal", textOfTheLegend: L10n.animalLegend)
        legendView.addItem(animalLegendItem, last: false)
        
        let closeAnimalItem = LegendViewItem(imageName: "closeAnimal", textOfTheLegend: L10n.closeAnimalLegend)
        legendView.addItem(closeAnimalItem, last: false)
        
        let visitedAnimalItem = LegendViewItem(imageName: "visitedAnimal", textOfTheLegend: L10n.visitedAnimalLegend)
        legendView.addItem(visitedAnimalItem, last: false)
        
        let localityItem = LegendViewItem(imageName: "locality", textOfTheLegend: L10n.localityLegend)
        legendView.addItem(localityItem, last: false)
        
        let entranceItem = LegendViewItem(imageName: "entrance", textOfTheLegend: L10n.entranceLegend)
        legendView.addItem(entranceItem, last: false)
        
        let exitItem = LegendViewItem(imageName: "exit", textOfTheLegend: L10n.exitLegend)
        legendView.addItem(exitItem, last: true)
        
        
        let addAllAnimalsButton = UIButton()
        addAllAnimalsButton.backgroundColor = UIColor(red: 0.1, green: 0.55, blue: 0.2, alpha: 1.0)
        addAllAnimalsButton.setTitle(L10n.addAllAnimalsToPath, for: .normal)
        addAllAnimalsButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        addAllAnimalsButton.titleLabel?.numberOfLines = 0
        addAllAnimalsButton.titleLabel?.lineBreakMode = .byWordWrapping
        addAllAnimalsButton.titleLabel?.preferredMaxLayoutWidth = 60
        addAllAnimalsButton.titleLabel?.sizeToFit()
        addAllAnimalsButton.addTarget(self, action: #selector(addAllAnimalsButtonTapped(_:)), for: .touchUpInside)
        self.contentView.addSubview(addAllAnimalsButton)
        addAllAnimalsButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.verticalMenu.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(verticalMenu.snp.width)
            make.height.equalTo(legendView.snp.height).multipliedBy(0.5)
        }
        
        
        let removeAllAnimalsButton = UIButton()
        removeAllAnimalsButton.backgroundColor = UIColor(red: 0.8, green: 0.4, blue: 0.3, alpha: 1.0)
        removeAllAnimalsButton.setTitle(L10n.removeAllAnimalsFromPath, for: .normal)
        removeAllAnimalsButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        removeAllAnimalsButton.titleLabel?.numberOfLines = 0
        removeAllAnimalsButton.titleLabel?.lineBreakMode = .byWordWrapping
        removeAllAnimalsButton.titleLabel?.preferredMaxLayoutWidth = 60
        removeAllAnimalsButton.titleLabel?.sizeToFit()
        removeAllAnimalsButton.addTarget(self, action: #selector(removeAllAnimalsButtonTapped(_:)), for: .touchUpInside)
        self.contentView.addSubview(removeAllAnimalsButton)
        removeAllAnimalsButton.snp.makeConstraints { (make) in
            make.top.equalTo(addAllAnimalsButton.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(verticalMenu.snp.width)
            make.height.equalTo(addAllAnimalsButton.snp.height)
        }
        
        self.textForReadingLabel = UILabel()
        self.textForReadingLabel.text = ""
        self.textForReadingLabel.numberOfLines = 0
        self.textForReadingLabel.lineBreakMode = .byWordWrapping
        self.textForReadingLabel.preferredMaxLayoutWidth = self.view.bounds.size.width * 11.0 / 12.0
        self.textForReadingLabel.sizeToFit()
        self.contentView.addSubview(self.textForReadingLabel)
        self.textForReadingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(legendView.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
        }
        
        // settings of the location manager
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        self.mainViewModel.isVoiceOn.apply().start()
        self.mainViewModel.isInformationFromGuideSaid.apply().start()
        
        // adding loaded localities to map
        self.addLoadedLocalitiesToMap()

        if (self.isInformationFromGuideSaid) {
            self.sayText(L10n.welcome, interrupt: false)
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
     This function ensures adding and then returning an item in the horizontal menu. It adds a button with a label and an image to the horizontal menu and then it returns the created menu item.
     - Parameters:
        - previousItem: The item in the menu next to the item which will be added and then returned
        - actionString: The string representing the given action of the item
        - actionText: The text which is shown above the icon in the item
     - Returns: The item of the menu as a button with a label and an image representing the given action
    */
    func getItemInTheHorizontalMenu(previousItem: UIButton, actionString: String, actionText: String) -> UIButton{
        let actionButton = UIButton()
        actionButton.backgroundColor = Colors.nonSelectedItemBackgroundColor.color
        actionButton.layer.cornerRadius = 1
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.black.cgColor
        self.horizontalMenu.addSubview(actionButton)
        actionButton.snp.makeConstraints{ (make) in
            make.left.equalTo(previousItem.snp.right)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalToSuperview()
        }
        
        // add a text label to the action button
        let actionButtonLabel = UILabel()
        actionButtonLabel.textColor = .black
        actionButtonLabel.text = actionText
        actionButtonLabel.textAlignment = .center
        actionButtonLabel.font = actionButtonLabel.font.withSize(9)
        actionButtonLabel.numberOfLines = 0
        actionButtonLabel.lineBreakMode = .byWordWrapping
        actionButtonLabel.preferredMaxLayoutWidth = actionButton.bounds.size.width - 4.0
        actionButtonLabel.sizeToFit()
        actionButton.addSubview(actionButtonLabel)
        actionButtonLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
        }
        
        // add an icon of book to the action button
        let actionButtonIcon = UIImageView()
        actionButtonIcon.image = UIImage(named: actionString)
        actionButtonIcon.contentMode = .scaleToFill
        actionButton.addSubview(actionButtonIcon)
        actionButtonIcon.snp.makeConstraints{ (make) in
            make.top.equalTo(actionButtonLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.width.equalTo(43)
            make.height.equalTo(48)
        }
        return actionButton
    }
    
    
    /**
     This function returns an attributed string with a statistic of the visit of the ZOO.
     - Returns: Attributed strings containing a statistic of the visit of the ZOO with the given value and the given unit.
    */
    func getAttributedStringWithStatistic(statistic: String, value: Float, units: String) -> NSAttributedString{
        let normalText = statistic + " "
        let attributesOfNormalText = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9)]
        let attributedString = NSMutableAttributedString(string: normalText, attributes: attributesOfNormalText)
        
        let boldTextWithValueAndUnit = String(value) + " " + units
        let attributesOfBoldText = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 9)]
        let boldAttributedString = NSMutableAttributedString(string: boldTextWithValueAndUnit, attributes: attributesOfBoldText)
        attributedString.append(boldAttributedString)
        
        return attributedString
    }
    
    
    /**
        This function ensures adding markers of localities and animals with coordintates to the map of the ZOO by running of registered actions for getting the list of localities and animals with known coordinates.
     */
    func addLoadedLocalitiesToMap(){
        //running actions - getting localities and animals from the view model
        self.mainViewModel.getLocalities.apply().start()
        self.mainViewModel.getAnimals.apply().start()
        
        for coordinateOfEntrance in Constants.coordinatesOfEntrances {
            let entranceAnnotation = MKPointAnnotation()
            entranceAnnotation.coordinate = coordinateOfEntrance
            entranceAnnotation.title = L10n.entranceLegend
            self.zooPlanMapView.addAnnotation(entranceAnnotation)
        }
            
        for coordinateOfExit in Constants.coordinatesOfExits {
            let exitAnnotation = MKPointAnnotation()
            exitAnnotation.coordinate = coordinateOfExit
            exitAnnotation.title = L10n.exitLegend
            self.zooPlanMapView.addAnnotation(exitAnnotation)
        }
    }
    
    
    /**
     This function finds the shortest route betweeen the two given placemarks and ensures showing the found route to the map view. It is used for showing the route with the selected animals in the ZOO.
     - Parameters:
        - sourcePlacemark: The source placemark representing the start.
        - destinationPlacemark: The placemark representing the destination.
    */
    private func drawShortestRouteBetweenTwoPlacemarks(sourcePlacemark: MKPlacemark, destinationPlacemark: MKPlacemark, fromActual: Bool){
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .walking
        
        var pieceOfPathBetweenPlacemarks: PieceOfPath? = nil
        
        self.mainViewModel.getSavedPieceOfPathBetweenPlacemarks.values.producer.startWithValues {
            (pieceOfPath) in
            pieceOfPathBetweenPlacemarks = pieceOfPath
        }
        self.mainViewModel.getSavedPieceOfPathBetweenPlacemarks.apply((sourcePlacemark, destinationPlacemark)).start()
        
        if (pieceOfPathBetweenPlacemarks != nil) {
            self.actualizeInformationAboutRoute(pieceOfPathBetweenPlacemarks!.route)
            return
        }
        
        // calculating the shortest path to the target selected location
        let directions = MKDirections(request: directionRequest)
        directions.calculate{ (response, error) in
            guard let directionResponse = response else {
                return
            }
            
            var shortestRoute = directionResponse.routes[0]
            for route in directionResponse.routes{
                if(route.distance < shortestRoute.distance){
                    shortestRoute = route
                }
            }
            
            let entrance = self.mainViewModel.entranceAtTheRoute(shortestRoute)
            if (fromActual && self.visitedAnimals.count == 0 && entrance != nil) {
                self.mainViewModel.setClosestExitCoordinateFromEntrance(entrance!)
                if (self.coordinateOfEntrance == nil) {
                    self.countShortestPath = true
                } else if (abs(self.coordinateOfEntrance.latitude - entrance!.latitude) > 1e-7 ||
                    abs(self.coordinateOfEntrance.longitude - entrance!.longitude) > 1e-7 ) {
                    self.countShortestPath = true
                } else {
                    self.countShortestPath = false
                }
                self.coordinateOfEntrance = entrance
                self.drawRouteFromEntranceToFirstAnimal(entranceCoordinate: entrance!, destinationPlacemark: destinationPlacemark)
                return
            }
            
            if (!fromActual) {
                let pieceOfPath = PieceOfPath(sourcePlacemark: sourcePlacemark, destinationPlacemark: destinationPlacemark, route: shortestRoute)
                self.mainViewModel.savePieceOfPath(pieceOfPath)
            }
            self.actualizeInformationAboutRoute(shortestRoute)
        }
    }
    
    
    /**
     This function draws the shortest route from the entrance to the ZOO to the first animal in the path.
     - Parameters:
        - destinationPlacemark: The destination placemark (the placemark of the first animal in the actual path).
    */
    func drawRouteFromEntranceToFirstAnimal(entranceCoordinate: CLLocationCoordinate2D, destinationPlacemark: MKPlacemark){
        let entrancePlacemark = MKPlacemark(coordinate: entranceCoordinate)
        
        let directionFromEntranceToDestinationRequest = MKDirections.Request()
        directionFromEntranceToDestinationRequest.source = MKMapItem(placemark: entrancePlacemark)
        directionFromEntranceToDestinationRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionFromEntranceToDestinationRequest.transportType = .walking
        
        var pieceOfPathBetweenPlacemarks: PieceOfPath? = nil
        
        self.mainViewModel.getSavedPieceOfPathBetweenPlacemarks.values.producer.startWithValues {
            (pieceOfPath) in
            pieceOfPathBetweenPlacemarks = pieceOfPath
        }
        self.mainViewModel.getSavedPieceOfPathBetweenPlacemarks.apply((entrancePlacemark, destinationPlacemark)).start()
        
        if (pieceOfPathBetweenPlacemarks != nil) {
            self.actualizeInformationAboutRoute(pieceOfPathBetweenPlacemarks!.route)
            return
        }
        
        let directionsFromEntranceToDestination = MKDirections(request: directionFromEntranceToDestinationRequest)
        directionsFromEntranceToDestination.calculate { (response, error) in
            guard let directionResponse = response else {
                return
            }
            
            var shortestRoute = directionResponse.routes[0]
            for route in directionResponse.routes{
                if(route.distance < shortestRoute.distance){
                    shortestRoute = route
                }
            }
            
            let pieceOfPath = PieceOfPath(sourcePlacemark: entrancePlacemark, destinationPlacemark: destinationPlacemark, route: shortestRoute)
            self.mainViewModel.savePieceOfPath(pieceOfPath)
            self.actualizeInformationAboutRoute(shortestRoute)
        }
    }
    
    
    /**
     This function ensures the actualization of the information about the actual visit of the ZOO with the selected animals in the actual path. It also ensures the drawing the route on the map view.
     - Parameters:
        - shortestRoute: The path between two animals or between an animal in the path and exit or actual location and the first animal of from entrance to the first animal.
    */
    func actualizeInformationAboutRoute(_ shortestRoute: MKRoute) {
        self.lengthOfTheTripInZoo += shortestRoute.distance
        self.viewForTheLengthOfThePathLabel.attributedText = self.getAttributedStringWithStatistic(statistic: L10n.lengthOfThePathInZOO, value: Float(self.lengthOfTheTripInZoo / 1000.0), units: "km")
        
        self.mainViewModel.getCountOfUnvisitedAnimals.apply().start()
        
        let totalTimeInZOO: Float = Float(self.countOfUnvisitedAnimals) * self.timeSpentAtOneAnimal + Float(self.lengthOfTheTripInZoo) * 60 / (1000.0 * self.walkSpeed)
        self.viewForTimeOfTheVisitOfTheZOOLabel.attributedText = self.getAttributedStringWithStatistic(statistic: L10n.timeOfTheVisitOfTheZOO, value: totalTimeInZOO, units: "min")
        
        self.zooPlanMapView.addOverlay(shortestRoute.polyline, level: .aboveRoads)
    }
    
    
    /**
     This function is called each time when location was updated. In this function there are updated informations about location in the view model. There are also run actions for saying information about an animal or a locality which is close to the actual position
     
     - Parameters:
        - manager: The location manager
        - locations: The array of locations in which can be the actual location
    */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            self.mainViewModel.updateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            
            /// This block of code ensures that it will be checked whether the user is at the exit from the ZOO if there are no unvisited animals. The user is also informed about this. If the user gone through the exit, the path from the actual location to the exit will not be shown.
            if (self.countOfUnvisitedAnimals == 0 && self.mainViewModel.checkExitAndGoThroughIt()) {
                self.speechAtExit()
                
                self.zooPlanMapView.removeOverlays(self.zooPlanMapView.overlays)
                
                self.viewForTheLengthOfThePathLabel.attributedText = self.getAttributedStringWithStatistic(statistic: L10n.lengthOfThePathInZOO, value: 0, units: "km")
                self.viewForTimeOfTheVisitOfTheZOOLabel.attributedText = self.getAttributedStringWithStatistic(statistic: L10n.timeOfTheVisitOfTheZOO, value: 0, units: "min")
                return
            }
            
            if (self.visitedAnimals.count == 0) {
                self.speechAtEntrance()
            }
            
            self.mainViewModel.getLocalityInCloseness.apply().start()
            self.mainViewModel.getAnimalInCloseness.apply().start()
            self.mainViewModel.getPlacemarksForTheActualPath.apply(self.countShortestPath).start()
            self.mainViewModel.isInformationFromGuideSaid.apply().start()
            if (self.countShortestPath && self.countOfUnvisitedAnimals > 0 && self.isInformationFromGuideSaid) {
                self.sayText(L10n.pathIsCounting, interrupt: true)
            }
            self.countShortestPath = false
        }
    }
    
    
    // MARK - Methods for machine-reading of any text in any situation.
    
    /**
     This function ensures saying the given text and showing it under the legend for the map view.
     - Parameters:
     - text: The text which is shown and machine-read.
     - interrupt: The boolean representing whether the previous machine-reading will be interrupted or not.
     */
    func sayText(_ text: String, interrupt: Bool) {
        self.mainViewModel.isMachineReadingRunning.apply().start()
        if (!self.isVoiceOn || ((self.isMachineReadingRunning || self.textForReadingLabel.text != "") && !interrupt)) {
            return
        }
        
        if (interrupt) {
            self.mainViewModel.stopSpeaking()
        }
        
        self.textForReadingLabel.text = text
        
        self.mainViewModel.setCallbacksOfSpeechService(startCallback: {
            self.speakingCharacterImageView?.startAnimatingGif()
        }, finishCallback: {
            self.speakingCharacterImageView?.stopAnimatingGif()
            self.textForReadingLabel.text = ""
            if (text == L10n.pathIsCounting) {
                self.mainViewModel.getNextAnimalInThePath.apply().start()
            }
        })
        self.mainViewModel.sayText(text)
    }
    
    
    /**
     This function informs the user that he/she is at the exit from the ZOO. There are set callbacks which ensure showing the information.
    */
    func speechAtExit() {
        self.mainViewModel.isMachineReadingRunning.apply().start()
        
        if (self.exitVisited || self.isMachineReadingRunning || self.textForReadingLabel.text != "" || !self.isVoiceOn) {
            return
        }
        self.exitVisited = true
        self.mainViewModel.setCallbacksOfSpeechService(startCallback: {
            self.textForReadingLabel.text = L10n.speechAtExit
            self.speakingCharacterImageView?.startAnimatingGif()
        }, finishCallback: {
            self.speakingCharacterImageView?.stopAnimatingGif()
            self.textForReadingLabel.text = ""
        })
        self.mainViewModel.speechAtExit()
    }
    
    
    /**
     This function informs the user that he/she is at the entrance to the ZOO. There are set callbacks which ensure showing the information.
     */
    func speechAtEntrance() {
        self.mainViewModel.isMachineReadingRunning.apply().start()
        
        if (self.entranceVisited || self.isMachineReadingRunning || self.textForReadingLabel.text != "" || self.coordinateOfEntrance == nil || !self.isVoiceOn) {
            return
        }
        
        
        let actualCoordinate = self.zooPlanMapView.userLocation.coordinate
        if (abs(actualCoordinate.latitude - self.coordinateOfEntrance.latitude) > Constants.closeDistance ||
            abs(actualCoordinate.longitude - self.coordinateOfEntrance.longitude) > Constants.closeDistance) {
            return
        }
        
        self.entranceVisited = true
        self.textForReadingLabel.text = L10n.speechAtEntrance
        
        self.mainViewModel.setCallbacksOfSpeechService(startCallback: {
            self.speakingCharacterImageView?.startAnimatingGif()
        }, finishCallback: {
            self.speakingCharacterImageView?.stopAnimatingGif()
            self.textForReadingLabel.text = ""
        })
        self.mainViewModel.speechAtEntrance()
    }
    
    
    // MARK - Map view methods
    
    
    /**
     This function ensures drawing the path from the actual locality to the selected target locality.
     
     - Parameters:
        - mapView: The MapView on which the shortest path should be drawed.
        - overlay: The value representing how the polyline will be rendered on the map (the polyline could be drawed for example above roads)
     
     - Returns: An object which ensures drawing the polyline representing the shortest path to the selected locality.
     */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    

    
    /**
     This function is called every time when the region of the map view changes. There is counted a radius important for decision whether labels at markers will be shown or not.
     - Parameters:
        - mapView: The map view with markers of animals, localities, entrances and exits
        - animated: The boolean representing whether the change is animated or not.
    */
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centralLocationCoordinate = mapView.centerCoordinate
        let centralLocation = CLLocation(latitude: centralLocationCoordinate.latitude, longitude: centralLocationCoordinate.longitude)
    
        let topCentralLatitude = centralLocationCoordinate.latitude - mapView.region.span.latitudeDelta
        let topCentralLocation = CLLocation(latitude: topCentralLatitude, longitude: centralLocationCoordinate.longitude)
        let radius = centralLocation.distance(from: topCentralLocation)
        let lastRadius = self.radius
        self.radius = radius
        
        if (lastRadius >= Constants.maximumRadiusToShowLabels && self.radius < Constants.maximumRadiusToShowLabels) {
            self.refreshMapView()
        }
        
        if (self.radius >= Constants.maximumRadiusToShowLabels && lastRadius < Constants.maximumRadiusToShowLabels) {
            self.refreshMapView()
        }
    }
    
    
    /**
     This function ensures showing an annotation for animal or locality. The image for the annotation is dependent on whether the animal is in the actual path or not and whether the animal was visited or not.
     - Parameters:
        - mapView: The map view of the ZOO with markers for animals and localities
        - annotation: The annotation which is shown in the map view as the selected image.
    */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if var animalAnnotation = annotation as? AnimalAnnotation {
            let animal = animalAnnotation.animal
            var isTheAnimalInPath = false
            self.mainViewModel.getAnimalsInPath.values.producer.startWithValues{ (animalsInPath) in
                for animalInPath in animalsInPath {
                    if (animal.id == animalInPath.id) {
                        isTheAnimalInPath = true
                        break
                    }
                }
            }
            self.mainViewModel.getAnimalsInPath.apply().start()
            
            var imageName = isTheAnimalInPath ? "animalSelected" : "animal"
            
            if (self.closeAnimal != nil) {
                if (self.closeAnimal!.id == animal.id) {
                    imageName = "closeAnimal"
                }
            }
            
            
            var firstAnimalLocation: CLLocationCoordinate2D!
            self.mainViewModel.getPlacemarksForTheActualPath.values.producer.startWithValues { placemarks in
                if (placemarks.count >= 2) {
                    firstAnimalLocation = placemarks[1].location!.coordinate
                }
            }
            self.mainViewModel.getPlacemarksForTheActualPath.apply(false).start()
            
            if (firstAnimalLocation != nil) {
                if (abs(firstAnimalLocation.latitude - animalAnnotation.coordinate.latitude) < 1e-7 && abs(firstAnimalLocation.longitude - animalAnnotation.coordinate.longitude) < 1e-7) {
                    imageName = "nextAnimalToVisit"
                }
            }
            
            self.mainViewModel.getVisitedAnimals.apply().start()

            for visitedAnimal in self.visitedAnimals {
                if (visitedAnimal.id == animal.id) {
                    imageName = "visitedAnimal"
                    break
                }
            }
            
            animalAnnotation.title = animalAnnotation.animal.title
            let annotationView = MKAnnotationView(annotation: animalAnnotation, reuseIdentifier: "animalAnnotation")
            annotationView.image = UIImage(named: imageName)
            let titleLabel = UILabel(frame: CGRect(x: -5, y: -24, width: annotation.title!!.count * 11, height: 32))
            titleLabel.text = annotation.title!
            titleLabel.font = UIFont.systemFont(ofSize: 10)
            if (self.radius < Constants.maximumRadiusToShowLabels) {
                annotationView.addSubview(titleLabel)
            }
            annotationView.canShowCallout = true
            return annotationView
        }
        
        var imageName = "locality"
        
        let annotationCoordinate = annotation.coordinate
        let annotationCoordinateLatitude = annotationCoordinate.latitude
        let annotationCoordinateLongitude = annotationCoordinate.longitude
        
        for coordinateOfEntrance in Constants.coordinatesOfEntrances {
            if (abs(annotationCoordinateLatitude - coordinateOfEntrance.latitude) < 1e-7 &&
                abs(annotationCoordinateLongitude - coordinateOfEntrance.longitude) < 1e-7) {
                imageName = "entrance"
                break
            }
        }
        
        for coordinateOfExit in Constants.coordinatesOfExits {
            if (abs(annotationCoordinateLatitude - coordinateOfExit.latitude) < 1e-7 &&
                abs(annotationCoordinateLongitude - coordinateOfExit.longitude) < 1e-7) {
                imageName = "exit"
                break
            }
        }
        
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "localityAnnotation")
        annotationView.image = UIImage(named: imageName)
        let titleLabel = UILabel(frame: CGRect(x: -5, y: -24, width: annotation.title!!.count * 11, height: 32))
        titleLabel.text = annotation.title!
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        if (self.radius < Constants.maximumRadiusToShowLabels) {
            annotationView.addSubview(titleLabel)
        }
        annotationView.canShowCallout = true
        return annotationView
    
    }
    
    
    /**
     This function is called after selecting any annotation in map at coordinates of any animal. There is selected an image for the selected annotation. The image for the selected annotation is dependent on whether the animal was visited or not and whether the animal is in the path or not.
     - Parameters:
        - mapView: The map view of the ZOO with markers of animals
        - view: The annotation view of an animal which was selected.
    */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        if var animalAnnotation = view.annotation as? AnimalAnnotation {
            view.isEnabled = true
            view.canShowCallout = true
            
            var isAnimalInPath = false
            self.mainViewModel.getAnimalsInPath.values.producer.startWithValues { (animalsInPath) in
                for animalInPath in animalsInPath {
                    if (animalInPath.id == animalAnnotation.animal.id) {
                        isAnimalInPath = true
                        break
                    }
                }
            }
            self.mainViewModel.getAnimalsInPath.apply().start()
            
            
            let viewWithButtons = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 50))
            
            let selectAnimalButton = ButtonWithAnimalProperty(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
            selectAnimalButton.animal = animalAnnotation.animal
            if (isAnimalInPath) {
                selectAnimalButton.setTitle(L10n.removeFromPath, for: .normal)
                selectAnimalButton.backgroundColor = UIColor(red: 0.7, green: 0.18, blue: 0.18, alpha: 1)
            } else {
                selectAnimalButton.setTitle(L10n.addToPath, for: .normal)
                selectAnimalButton.backgroundColor = UIColor(red: 0, green: 0.7, blue: 0.35, alpha: 1)
            }
            selectAnimalButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            selectAnimalButton.titleLabel?.numberOfLines = 0
            selectAnimalButton.titleLabel?.lineBreakMode = .byWordWrapping
            selectAnimalButton.titleLabel?.preferredMaxLayoutWidth = 74
            selectAnimalButton.titleLabel?.sizeToFit()
            selectAnimalButton.addTarget(self, action: #selector(selectAnimalButtonTapped(_:)), for: .touchUpInside)
            viewWithButtons.addSubview(selectAnimalButton)
            
            let detailButton = ButtonWithAnimalProperty(frame: CGRect(x: 80, y: 0, width: 80, height: 50))
            detailButton.animal = animalAnnotation.animal
            detailButton.setTitle(L10n.detailOfAnimal, for: .normal)
            detailButton.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.7, alpha: 1)
            detailButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            detailButton.titleLabel?.numberOfLines = 0
            detailButton.titleLabel?.preferredMaxLayoutWidth = 74
            detailButton.titleLabel?.sizeToFit()
            detailButton.addTarget(self, action: #selector(detailButtonTapped(_:)), for: .touchUpInside)
            viewWithButtons.addSubview(detailButton)
            
            let closeButton = ButtonWithAnimalProperty(frame: CGRect(x: 160, y: 0, width: 80, height: 50))
            closeButton.animal = animalAnnotation.animal
            closeButton.setTitle(L10n.close, for: .normal)
            closeButton.backgroundColor = UIColor(red: 0.8, green: 0.6, blue: 0.6, alpha: 1)
            closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            closeButton.titleLabel?.numberOfLines = 0
            closeButton.titleLabel?.lineBreakMode = .byWordWrapping
            closeButton.titleLabel?.preferredMaxLayoutWidth = 74
            closeButton.titleLabel?.sizeToFit()
            closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
            viewWithButtons.addSubview(closeButton)

            
            
            view.rightCalloutAccessoryView = viewWithButtons
            
            self.refreshAnimalAnnotationsWithoutSelected(annotation: view.annotation!)
            self.countShortestPath = true
        }
    }
    
    // MARK - Actions
    
    
    /**
     This function ensures going to the main screen of the lexicon part of the application after tapping the goToLexiconItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
    */
    @objc func goToLexiconItemTapped(_ sender: VerticalMenuItem){
        self.mainViewModel.isInformationFromGuideSaid.apply().start()
        if (self.isInformationFromGuideSaid) {
            self.sayText(L10n.goToLexiconSpeech, interrupt: true)
        }
        flowDelegate?.goToLexicon(in: self)
    }
    
    
    /**
     This function ensures going to the screen for selecting animal to the actual unsaved path after tapping the selectAnimalsToPathItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func selectAnimalsToPathItemTapped(_ sender: VerticalMenuItem){
        self.mainViewModel.isInformationFromGuideSaid.apply().start()
        if (self.isInformationFromGuideSaid) {
            self.sayText(L10n.goToSelectAnimalsSpeech, interrupt: true)
        }
            
        let selectAnimalsToPathVM = SelectAnimalsToPathViewModel(dependencies: AppDependency.shared)
        let selectAnimalsToPathVC = SelectAnimalsToPathViewController(selectAnimalsToPathViewModel: selectAnimalsToPathVM)
        
        selectAnimalsToPathVC.addAnimalCallback = { (animal) in
            self.sayText(animal + " " + L10n.addAnimalToPathSpeech, interrupt: true)
        }
        
        selectAnimalsToPathVC.removeAnimalCallback = { (animal) in
            self.sayText(animal + " " + L10n.removeAnimalFromPathSpeech, interrupt: true)
        }
        
        
        selectAnimalsToPathVC.closeCallback = {
            self.refreshMapView()
            self.mainViewModel.getAnimalsInPath.apply().start()
            self.mainViewModel.getCountOfUnvisitedAnimals.apply().start()
            if (self.countOfUnvisitedAnimals > 0) {
                self.mainViewModel.getPlacemarksForTheActualPath.apply(true).start()
                
                self.mainViewModel.isInformationFromGuideSaid.apply().start()
                if (self.isInformationFromGuideSaid) {
                    self.sayText(L10n.pathIsCounting, interrupt: true)
                }
            }
        }
        
        self.addChild(selectAnimalsToPathVC)
        selectAnimalsToPathVC.view.frame = self.view.frame
        self.view.addSubview(selectAnimalsToPathVC.view)
        selectAnimalsToPathVC.didMove(toParent: self)
    }
    
    
    /**
     This function ensures turning off the voice (or turning on if the voice is turned off) the turnOnOrOffVoiceItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func turnOnOrOffVoiceItemTapped(_ sender: VerticalMenuItem){
        self.mainViewModel.turnVoiceOnOrOff()
        self.mainViewModel.isVoiceOn.apply().start()
        self.mainViewModel.isInformationFromGuideSaid.apply().start()
        if (self.isVoiceOn && self.isInformationFromGuideSaid) {
            self.sayText(L10n.turnOnVoiceSpeech, interrupt: true)
        }
    }
    
    
    /**
     This function ensures going to the screen for setting parameters of the actual visit of the ZOO (walk speed and time spent at one animal during the visit of the ZOO) after tapping the settingParametersOfVIsitItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func settingParametersOfVisitItemTapped(_ sender: VerticalMenuItem){
        self.mainViewModel.isInformationFromGuideSaid.apply().start()
        if (self.isInformationFromGuideSaid) {
            self.sayText(L10n.goToSettingParametersSpeech, interrupt: true)
        }
        flowDelegate?.goToSettingParametersOfVisit(in: self)
    }
    
    
    /**
     This function ensures going to the screen for selecting information about an enough close animal which are machine-read after tapping the selectInformaitonItem item from the vertical menu.
     - Parameters:
        - sender: The item with this method as a target which was tapped.
     */
    @objc func selectInformationItemTapped(_ sender: VerticalMenuItem){
        self.mainViewModel.isInformationFromGuideSaid.apply().start()
        if (self.isInformationFromGuideSaid) {
            self.sayText(L10n.goToSelectInformationSpeech, interrupt: true)
        }
        flowDelegate?.goToSelectInformation(in: self)
    }
    
    
    
    /**
     This function ensures going to the screen with the help for the application after tapping the last item in the vertical menu.
     - Parameters:
        - sender: The last item in the vertical menu which was tapped and has set this function as a target.
    */
    @objc func helpItemTapped(_ sender: VerticalMenuItem) {
        self.mainViewModel.isInformationFromGuideSaid.apply().start()
        if (self.isInformationFromGuideSaid) {
            self.sayText(L10n.goToSelectInformationSpeech, interrupt: true)
        }
        flowDelegate?.goToHelp(in: self)
    }
    
    
    /**
     This function ensures going to the screen for choosing one of saved paths with animals after the tapping the chooseSavedPathButton button from the horizontal menu.
     - Parameters:
        - sender: The button with this method as a target which was tapped.
     */
    @objc func chooseSavedPathButtonTapped(_ sender: VerticalMenuItem){
        self.mainViewModel.isInformationFromGuideSaid.apply().start()
        if (self.isInformationFromGuideSaid) {
            self.sayText(L10n.goToChoosePathSpeech, interrupt: true)
        }
        flowDelegate?.goToChooseSavedPath(in: self)
    }
    
    
    /**
     This function ensures showing a popover for saving the actual unsaved path with a title after the tapping the savePathButton button from the horizontal menu. This function shows the popover with a text field for filling the title and two buttons - one for saving the actual path and the second one for cancelling and closing the popover.
     - Parameters:
        - sender: The button with this method as a target which was tapped.
     */
    @objc func savePathButtonTapped(_ sender: VerticalMenu){
        self.mainViewModel.isInformationFromGuideSaid.apply().start()
        if (self.isInformationFromGuideSaid) {
            self.sayText(L10n.goToSavePathSpeech, interrupt: true)
        }
        
        let savePathVM = SavePathViewModel(dependencies: AppDependency.shared)
        let savePathPopoverVC = SavePathPopoverViewController(savePathViewModel: savePathVM)
        self.addChild(savePathPopoverVC)
        savePathPopoverVC.view.frame = self.view.frame
        self.view.addSubview(savePathPopoverVC.view)
        savePathPopoverVC.didMove(toParent: self)
    }
    
    
    /**
     This function ensures adding all animals to the actual path after tapping the button.
     - Parameters:
        - sender: The button for adding all animals to the actual path which was tapped. It has set this method as a target.
    */
    @objc func addAllAnimalsButtonTapped(_ sender: UIButton) {
        self.mainViewModel.addAllAnimalsToPath()
        self.mainViewModel.getAnimalsInPath.apply().start()
        self.mainViewModel.getPlacemarksForTheActualPath.apply(true).start()
        self.mainViewModel.isInformationFromGuideSaid.apply().start()
        if (self.isInformationFromGuideSaid) {
            self.sayText(L10n.pathIsCounting, interrupt: true)
        }
        self.refreshMapView()
    }
    
    /**
     This function ensures removing all animals from the actual path after tapping the button.
     - Parameters:
        - sender: The button for removing all animals from the actual path which was tapped and has set this method as a target.
    */
    @objc func removeAllAnimalsButtonTapped(_ sender: UIButton) {
        self.mainViewModel.removeAllAnimalsFromPath()
        self.mainViewModel.getAnimalsInPath.apply().start()
        self.mainViewModel.getPlacemarksForTheActualPath.apply(true).start()
        self.refreshMapView()
        
        self.lengthOfTheTripInZoo = 0
        self.viewForTheLengthOfThePathLabel.attributedText = self.getAttributedStringWithStatistic(statistic: L10n.lengthOfThePathInZOO, value: 0, units: "km")
        self.viewForTimeOfTheVisitOfTheZOOLabel.attributedText = self.getAttributedStringWithStatistic(statistic: L10n.timeOfTheVisitOfTheZOO, value: 0, units: "min")
    }
    
    
    /**
        This function ensures adding an animal to the actual path or removing the animal from the actual path if it is selected after tapping the button.
     - Parameters:
        - sender: The button for adding the animal to the actual path or removing the animal from the actual path if it is selected. The button has set this method as a target and was tapped.
    */
    @objc func selectAnimalButtonTapped(_ sender: ButtonWithAnimalProperty) {
        self.mainViewModel.addOrRemoveAnimal(sender.animal!)
        self.mainViewModel.getAnimalsInPath.apply().start()
        self.mainViewModel.getPlacemarksForTheActualPath.apply(true).start()
        self.mainViewModel.isInformationFromGuideSaid.apply().start()
        if (self.isInformationFromGuideSaid) {
            self.sayText(L10n.pathIsCounting, interrupt: true)
        }
        self.refreshMapView()
    }
    
    /**
     This function ensures going to the screen with the detailed information about the animal after tapping the button.
     - Parameters:
        - sender: The button for going to the screen with detailed information about the animals which was tapped and has set this method as a target.
    */
    @objc func detailButtonTapped(_ sender: ButtonWithAnimalProperty) {
        flowDelegate?.goToAnimalDetail(in: self, to: sender.animal!)
    }
    
    /**
     This function ensures deselecting the actual annotation of the animal after tapping the close button.
     - Parameters:
        - sender: The button which was tapped and has set this method as a target.
    */
    @objc func closeButtonTapped(_ sender: ButtonWithAnimalProperty) {
        for annotation in self.zooPlanMapView.annotations {
            if let animalAnnotation = annotation as? AnimalAnnotation {
                if (animalAnnotation.animal.id == sender.animal!.id) {
                    self.zooPlanMapView.deselectAnnotation(annotation, animated: false)
                    break
                }
            }
        }
    }
    
}
